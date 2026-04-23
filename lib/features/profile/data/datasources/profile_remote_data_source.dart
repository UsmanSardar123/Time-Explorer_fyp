import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'dart:io' if (dart.library.html) 'dart:html';
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
    try {
      final ref = _firebaseStorage
          .ref()
          .child('profile_images')
          .child('$userId.jpg');

      UploadTask uploadTask;

      // ── Resolve image data to bytes or file ──────────────────────────────
      if (imageData is ProfileImageResult) {
        if (kIsWeb || imageData.bytes != null) {
          // Web path: upload raw bytes
          final bytes = imageData.bytes!
              as Uint8List; // always Uint8List from XFile.readAsBytes
          uploadTask = ref.putData(
            bytes,
            SettableMetadata(contentType: 'image/jpeg'),
          );
        } else {
          // Mobile path: upload File
          uploadTask = ref.putFile(
            imageData.file! as File,
            SettableMetadata(contentType: 'image/jpeg'),
          );
        }
      } else if (imageData is Uint8List) {
        // Legacy web path
        uploadTask = ref.putData(
          imageData,
          SettableMetadata(contentType: 'image/jpeg'),
        );
      } else if (!kIsWeb && imageData is File) {
        // Legacy mobile path
        uploadTask = ref.putFile(
          imageData,
          SettableMetadata(contentType: 'image/jpeg'),
        );
      } else {
        throw ArgumentError(
          'Unsupported imageData type: ${imageData.runtimeType}',
        );
      }

      debugPrint('[PROFILE] ⬆️ Uploading profile image for user $userId...');
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();
      debugPrint('[PROFILE] ✅ Upload complete. URL: $downloadUrl');

      // Persist to Firestore
      await _firestore.collection('users').doc(userId).set(
        {'photoUrl': downloadUrl},
        SetOptions(merge: true),
      );

      // Sync to Firebase Auth user record
      final user = _firebaseAuth.currentUser;
      if (user != null && user.uid == userId) {
        await user.updatePhotoURL(downloadUrl);
      }

      return downloadUrl;
    } on FirebaseException catch (e) {
      debugPrint('[PROFILE] 🔥 Firebase upload error [${e.code}]: ${e.message}');
      throw Exception(_mapStorageError(e.code));
    } catch (e) {
      debugPrint('[PROFILE] ❌ uploadProfileImage error: $e');
      throw Exception('Failed to upload profile image. Please try again.');
    }
  }

  String _mapStorageError(String code) {
    switch (code) {
      case 'storage/unauthorized':
        return 'You do not have permission to upload images.';
      case 'storage/canceled':
        return 'Upload was cancelled.';
      case 'storage/quota-exceeded':
        return 'Storage quota exceeded. Contact support.';
      case 'storage/invalid-format':
        return 'Invalid file format. Only JPEG images are accepted.';
      default:
        return 'Upload failed ($code). Please try again.';
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
