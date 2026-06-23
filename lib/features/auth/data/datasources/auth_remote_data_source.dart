import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:timeexplorer/core/services/api_service.dart';
import 'package:timeexplorer/features/auth/domain/entities/user_entity.dart';

abstract class AuthRemoteDataSource {
  Future<UserEntity> signInWithEmail(String email, String password);
  Future<UserEntity> signUpWithEmail(String email, String password, String name, String dob);
  Future<UserEntity> signInWithGoogle();
  Future<void> signOut();
  Future<UserEntity?> getCurrentUser();
  Future<void> deleteAccount(String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final ApiService _api;
  // Firestore is kept ONLY for deleteAccount subcollection cleanup (no cascade delete on backend)
  final FirebaseFirestore _firestore;

  AuthRemoteDataSourceImpl({
    FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
    ApiService? api,
    FirebaseFirestore? firestore,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn(scopes: ['email', 'profile', 'https://www.googleapis.com/auth/user.birthday.read']),
        _api = api ?? ApiService(),
        _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<UserEntity> signInWithEmail(String email, String password) async {
    try {
      debugPrint('[AUTH] Signing in via Firebase Auth for $email');
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;
      if (user == null) throw Exception('Sign in failed: User is null');

      // Fetch user profile from API and update lastActive
      Map<String, dynamic> data = {};
      try {
        data = await _api.get('/users/${user.uid}') as Map<String, dynamic>;
        await _api.put('/users/${user.uid}', {'lastActive': DateTime.now().toIso8601String()});
      } catch (e) {
        debugPrint('[AUTH] Profile fetch failed (non-fatal): $e');
      }

      debugPrint('[AUTH] Sign in successful');
      return UserEntity(
        id: user.uid,
        email: user.email ?? '',
        displayName: data['displayName'] as String? ?? user.displayName,
        photoUrl: data['photoUrl'] as String? ?? user.photoURL,
        dob: data['dob'] as String?,
      );
    } catch (e) {
      debugPrint('[AUTH] Sign in error: $e');
      rethrow;
    }
  }

  @override
  Future<UserEntity> signUpWithEmail(String email, String password, String name, String dob) async {
    try {
      debugPrint('[AUTH] Signing up via Firebase Auth for $email');
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;
      if (user == null) throw Exception('Sign up failed: User is null');

      await user.updateDisplayName(name);

      // Create user document via API (PUT with merge:true creates if not exists)
      try {
        await _api.put('/users/${user.uid}', {
          'email': email,
          'displayName': name,
          'dob': dob,
          'xp': 0,
          'level': 1,
          'streak': 0,
          'lastActive': DateTime.now().toIso8601String(),
          'createdAt': DateTime.now().toIso8601String(),
        });
      } catch (e) {
        debugPrint('[AUTH] User document creation failed (non-fatal): $e');
      }

      debugPrint('[AUTH] Sign up successful');
      return UserEntity(id: user.uid, email: email, displayName: name, dob: dob);
    } catch (e) {
      debugPrint('[AUTH] Sign up error: $e');
      rethrow;
    }
  }

  @override
  Future<UserEntity> signInWithGoogle() async {
    try {
      debugPrint('[AUTH] Attempting Google sign in');
      await _googleSignIn.disconnect().catchError((_) => null);
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) throw Exception('Google sign in was aborted.');

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _firebaseAuth.signInWithCredential(credential);
      final user = userCredential.user;
      if (user == null) throw Exception('Google sign in failed: User is null');

      // Check if profile exists via API; create if new user
      Map<String, dynamic> data = {};
      try {
        data = await _api.get('/users/${user.uid}') as Map<String, dynamic>;
        await _api.put('/users/${user.uid}', {'lastActive': DateTime.now().toIso8601String()});
      } on ApiException catch (e) {
        if (e.statusCode == 404) {
          // New Google user — create profile
          final newProfile = {
            'email': user.email ?? '',
            'displayName': user.displayName ?? '',
            'photoUrl': user.photoURL,
            'streak': 0,
            'lastActive': DateTime.now().toIso8601String(),
            'createdAt': DateTime.now().toIso8601String(),
          };
          try {
            await _api.put('/users/${user.uid}', newProfile);
            data = newProfile;
          } catch (createErr) {
            debugPrint('[AUTH] Profile creation failed (non-fatal): $createErr');
          }
        } else {
          debugPrint('[AUTH] Profile fetch failed (non-fatal): $e');
        }
      } catch (e) {
        debugPrint('[AUTH] Profile fetch failed (non-fatal): $e');
      }

      debugPrint('[AUTH] Google sign in successful');
      return UserEntity(
        id: user.uid,
        email: user.email ?? '',
        displayName: data['displayName'] as String? ?? user.displayName,
        photoUrl: data['photoUrl'] as String? ?? user.photoURL,
        dob: data['dob'] as String?,
      );
    } catch (e) {
      debugPrint('[AUTH] Google sign in error: $e');
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    debugPrint('[AUTH] Signing out');
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }

  @override
  Future<void> deleteAccount(String password) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) throw Exception('No authenticated user');

    final uid = user.uid;
    debugPrint('[AUTH] Deleting account for $uid');

    if (user.email != null && password.isNotEmpty) {
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );
      await user.reauthenticateWithCredential(credential);
    }

    // Delete main user document via API
    try {
      await _api.delete('/users/$uid');
    } catch (e) {
      debugPrint('[AUTH] API user delete failed (non-fatal): $e');
    }

    // Clean up subcollections — Firestore is kept here because the backend
    // does not support cascading subcollection deletion yet.
    try {
      final batch = _firestore.batch();
      final userRef = _firestore.collection('users').doc(uid);
      for (final sub in ['notifications', 'progress', 'bookmarks', 'chats', 'conversations']) {
        final docs = await userRef.collection(sub).get();
        for (final doc in docs.docs) {
          batch.delete(doc.reference);
        }
      }
      await batch.commit();
    } catch (e) {
      debugPrint('[AUTH] Subcollection cleanup failed (non-fatal): $e');
    }

    await _googleSignIn.signOut();
    await user.delete();
    debugPrint('[AUTH] Account deleted for $uid');
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) return null;

      debugPrint('[AUTH] Fetching user profile from API');
      try {
        final data = await _api.get('/users/${user.uid}') as Map<String, dynamic>;
        return UserEntity(
          id: user.uid,
          email: user.email ?? '',
          displayName: data['displayName'] as String? ?? user.displayName,
          photoUrl: data['photoUrl'] as String? ?? user.photoURL,
          dob: data['dob'] as String?,
        );
      } on ApiException catch (e) {
        if (e.statusCode == 404) {
          return UserEntity(
            id: user.uid,
            email: user.email ?? '',
            displayName: user.displayName,
            photoUrl: user.photoURL,
          );
        }
        rethrow;
      }
    } catch (e) {
      debugPrint('[AUTH] Error fetching current user: $e');
      return null;
    }
  }
}
