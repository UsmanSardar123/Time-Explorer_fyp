import 'dart:async';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'dart:io' as io;
import 'package:timeexplorer/features/profile/domain/entities/profile_entity.dart';
import 'package:timeexplorer/features/profile/data/services/profile_image_service.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileEntity> getProfile(String userId);
  Future<void> updateProfile(ProfileEntity profile);
  Future<void> changePassword(String currentPassword, String newPassword);
  Future<void> updateEmail(String newEmail, {String? currentPassword});
  Future<bool> checkUsernameUniqueness(String username);
  /// [imageData] is either a [ProfileImageResult] (preferred) or a raw [File] / [Uint8List] (legacy).
  Future<String> uploadProfileImage(String userId, dynamic imageData);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;
  final FirebaseStorage _firebaseStorage;

  ProfileRemoteDataSourceImpl({
    FirebaseFirestore? firestore,
    FirebaseAuth? firebaseAuth,
    FirebaseStorage? firebaseStorage,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firebaseStorage = firebaseStorage ?? FirebaseStorage.instance;

  @override
  Future<ProfileEntity> getProfile(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (!doc.exists) {
        // Return default if not exists yet
        final user = _firebaseAuth.currentUser;
        if (user != null && user.uid == userId) {
          return ProfileEntity(
            id: userId,
            email: user.email ?? '',
            displayName: user.displayName ?? '',
            photoUrl: user.photoURL,
          );
        }
        throw Exception('Profile not found');
      }
      
      final data = doc.data()!;
      return ProfileEntity(
        id: userId,
        email: data['email'] ?? '',
        displayName: data['displayName'] ?? '',
        username: data['username'],
        photoUrl: data['photoUrl'],
        bio: data['bio'],
        dob: data['dob'],
        phoneNumber: data['phoneNumber'],
        address: data['address'],
        gender: data['gender'],
        privacySettings: data['privacySettings']?.toString(),
      );
    } catch (e) {
      debugPrint('[PROFILE] getProfile error: $e');
      throw Exception('Failed to get profile: $e');
    }
  }

  @override
  Future<void> updateProfile(ProfileEntity profile) async {
    try {
      await _firestore.collection('users').doc(profile.id).set({
        'displayName': profile.displayName,
        'username': profile.username,
        'photoUrl': profile.photoUrl,
        'bio': profile.bio,
        'dob': profile.dob,
        'phoneNumber': profile.phoneNumber,
        'address': profile.address,
        'gender': profile.gender,
        'privacySettings': profile.privacySettings,
        'email': profile.email,
        'id': profile.id,
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint('[PROFILE] updateProfile error: $e');
      throw Exception('Failed to update profile: $e');
    }
  }

  @override
  Future<void> changePassword(String currentPassword, String newPassword) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) throw Exception('No authenticated user found');

      // Re-authenticate user before changing password
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );

      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      debugPrint('[PROFILE] changePassword Firebase error: ${e.code}');
      throw Exception(_mapFirebaseErrorCode(e.code));
    } catch (e) {
      debugPrint('[PROFILE] changePassword error: $e');
      throw Exception('Failed to change password: $e');
    }
  }

  @override
  Future<void> updateEmail(String newEmail, {String? currentPassword}) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) throw Exception('No authenticated user found');

      if (currentPassword != null) {
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: currentPassword,
        );
        await user.reauthenticateWithCredential(credential);
      }

      await user.verifyBeforeUpdateEmail(newEmail);
      
      // Update email in firestore
      await _firestore.collection('users').doc(user.uid).update({
        'email': newEmail,
      });
    } on FirebaseAuthException catch (e) {
      debugPrint('[PROFILE] updateEmail Firebase error: ${e.code}');
      throw Exception(_mapFirebaseErrorCode(e.code));
    } catch (e) {
      debugPrint('[PROFILE] updateEmail error: $e');
      throw Exception('Failed to update email: $e');
    }
  }

  @override
  Future<bool> checkUsernameUniqueness(String username) async {
    try {
      final currentUid = _firebaseAuth.currentUser?.uid;

      final query = await _firestore
          .collection('users')
          .where('username', isEqualTo: username)
          .limit(1)
          .get();

      if (query.docs.isEmpty) return true;

      // The only match is the current user's own document — allow saving same username
      return query.docs.first.id == currentUid;
    } catch (e) {
      debugPrint('[PROFILE] checkUsernameUniqueness error: $e');
      return true;
    }
  }

  @override
  Future<String> uploadProfileImage(String userId, dynamic imageData) async {
    if (userId.isEmpty) {
      throw Exception('Couldn\'t update your profile photo right now.');
    }

    // Derive safe extension from filename
    String ext = 'jpg';
    if (imageData is ProfileImageResult) {
      final raw = imageData.fileName.split('.').last.toLowerCase();
      if (['jpg', 'jpeg', 'png', 'webp'].contains(raw)) ext = raw == 'jpeg' ? 'jpg' : raw;
    }

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final storagePath = 'users/$userId/profile/avatar_$timestamp.$ext';

    debugPrint('[PROFILE] 📁 path: $storagePath | uid: $userId');

    final ref = _firebaseStorage.ref().child(storagePath);

    // Resolve upload task — all failures here are real upload failures
    UploadTask uploadTask;
    if (imageData is ProfileImageResult) {
      final mime = _mimeFromFileName(imageData.fileName);
      if (kIsWeb || imageData.bytes != null) {
        uploadTask = ref.putData(imageData.bytes!, SettableMetadata(contentType: mime));
      } else {
        uploadTask = ref.putFile(imageData.file! as io.File, SettableMetadata(contentType: mime));
      }
    } else if (imageData is Uint8List) {
      uploadTask = ref.putData(imageData, SettableMetadata(contentType: 'image/jpeg'));
    } else if (!kIsWeb && imageData is io.File) {
      uploadTask = ref.putFile(imageData, SettableMetadata(contentType: 'image/jpeg'));
    } else {
      throw Exception('Couldn\'t update your profile photo right now.');
    }

    try {
      // ── Step 1: upload ────────────────────────────────────────────────────
      debugPrint('[PROFILE] ⬆️ Upload started');
      final snapshot = await uploadTask;

      // ── Step 2: fetch URL ─────────────────────────────────────────────────
      debugPrint('[PROFILE] ✅ Upload complete, fetching URL...');
      final downloadUrl = await snapshot.ref.getDownloadURL();
      debugPrint('[PROFILE] 🔗 URL fetched successfully');

      // ── Step 3: persist to Firestore ─────────────────────────────────────
      debugPrint('[PROFILE] 💾 Updating Firestore...');
      await _firestore.collection('users').doc(userId).set(
        {'photoUrl': downloadUrl},
        SetOptions(merge: true),
      );
      debugPrint('[PROFILE] ✅ Firestore updated — UI refresh triggered');

      // ── Step 4: sync to Firebase Auth (best-effort, fully isolated) ───────
      final user = _firebaseAuth.currentUser;
      if (user != null && user.uid == userId) {
        try {
          await user.updatePhotoURL(downloadUrl);
        } catch (e) {
          debugPrint('[PROFILE] ⚠️ Auth photoURL sync failed (non-fatal): $e');
        }
      }

      return downloadUrl;
    } on FirebaseException catch (e) {
      debugPrint('[PROFILE] 🔥 Firebase error [${e.code}]: ${e.message}');
      throw Exception(_mapStorageError(e.code));
    } on io.SocketException {
      debugPrint('[PROFILE] 🌐 Socket error during upload');
      throw Exception('You\'re offline. Try again when connected.');
    } on TimeoutException {
      debugPrint('[PROFILE] ⏱ Upload timed out');
      throw Exception('Photo upload took too long. Please retry.');
    } catch (e) {
      debugPrint('[PROFILE] ❌ uploadProfileImage error: $e');
      throw Exception('Couldn\'t update your profile photo right now.');
    }
  }

  static String _mimeFromFileName(String fileName) {
    final ext = fileName.split('.').last.toLowerCase();
    switch (ext) {
      case 'png':
        return 'image/png';
      case 'webp':
        return 'image/webp';
      default:
        return 'image/jpeg';
    }
  }

  String _mapStorageError(String code) {
    switch (code) {
      case 'storage/unauthorized':
      case 'storage/unauthenticated':
        return 'Please sign in again to update your photo.';
      case 'storage/canceled':
        return 'Upload was cancelled.';
      case 'storage/quota-exceeded':
        return 'Storage limit reached. Please contact support.';
      case 'storage/invalid-format':
        return 'That image format isn\'t supported yet.';
      case 'storage/object-not-found':
      case 'storage/bucket-not-found':
      case 'storage/project-not-found':
        return 'Couldn\'t update your profile photo right now.';
      case 'storage/network-request-failed':
        return 'You\'re offline. Try again when connected.';
      case 'storage/retry-limit-exceeded':
        return 'Photo upload took too long. Please retry.';
      default:
        return 'Couldn\'t update your profile photo right now.';
    }
  }

  String _mapFirebaseErrorCode(String code) {
    switch (code) {
      case 'wrong-password':
        return 'Incorrect current password.';
      case 'requires-recent-login':
        return 'Please sign in again to perform this sensitive action.';
      case 'weak-password':
        return 'The new password is too weak.';
      case 'email-already-in-use':
        return 'This email is already registered to another account.';
      case 'invalid-email':
        return 'The email address is invalid.';
      default:
        return 'An error occurred during authentication. ($code)';
    }
  }
}
