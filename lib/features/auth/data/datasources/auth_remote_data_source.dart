import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
  final FirebaseFirestore _firestore;

  AuthRemoteDataSourceImpl({
    FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
    FirebaseFirestore? firestore,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn(scopes: ['email', 'profile', 'https://www.googleapis.com/auth/user.birthday.read']),
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

      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      final data = userDoc.data() ?? {};

      await _firestore.collection('users').doc(user.uid).set(
        {'lastActive': FieldValue.serverTimestamp()},
        SetOptions(merge: true),
      );

      debugPrint('[AUTH] Sign in successful via Firebase');
      return UserEntity(
        id: user.uid,
        email: user.email ?? '',
        displayName: data['displayName'] ?? user.displayName,
        photoUrl: data['photoUrl'] ?? user.photoURL,
        dob: data['dob'],
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

      await _firestore.collection('users').doc(user.uid).set({
        'id': user.uid,
        'email': email,
        'displayName': name,
        'dob': dob,
        'xp': 0,
        'level': 1,
        'streak': 0,
        'lastActive': FieldValue.serverTimestamp(),
        'fcmToken': null,
        'createdAt': FieldValue.serverTimestamp(),
      });

      debugPrint('[AUTH] Sign up successful via Firebase');
      return UserEntity(
        id: user.uid,
        email: email,
        displayName: name,
        dob: dob,
      );
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
      
      if (googleUser == null) {
        throw Exception('Google sign in was aborted.');
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _firebaseAuth.signInWithCredential(credential);
      final user = userCredential.user;
      if (user == null) throw Exception('Google sign in failed: User is null');

      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      Map<String, dynamic> data;

      if (!userDoc.exists) {
        data = {
          'id': user.uid,
          'email': user.email ?? '',
          'displayName': user.displayName ?? '',
          'photoUrl': user.photoURL,
          'streak': 0,
          'lastActive': FieldValue.serverTimestamp(),
          'fcmToken': null,
          'createdAt': FieldValue.serverTimestamp(),
        };
        await _firestore.collection('users').doc(user.uid).set(data);
      } else {
        data = userDoc.data()!;
        await _firestore.collection('users').doc(user.uid).set(
          {'lastActive': FieldValue.serverTimestamp()},
          SetOptions(merge: true),
        );
      }

      debugPrint('[AUTH] Google sign in successful via Firebase');
      return UserEntity(
        id: user.uid,
        email: user.email ?? '',
        displayName: data['displayName'] ?? user.displayName,
        photoUrl: data['photoUrl'] ?? user.photoURL,
        dob: data['dob'],
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

    // Re-authenticate before deletion
    if (user.email != null && password.isNotEmpty) {
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );
      await user.reauthenticateWithCredential(credential);
    }

    // Delete Firestore user document and subcollections
    final batch = _firestore.batch();
    final userRef = _firestore.collection('users').doc(uid);

    // Delete known subcollections
    for (final sub in ['notifications', 'progress', 'bookmarks', 'chats']) {
      final docs = await userRef.collection(sub).get();
      for (final doc in docs.docs) {
        batch.delete(doc.reference);
      }
    }
    batch.delete(userRef);
    await batch.commit();

    // Delete Firebase Auth account
    await _googleSignIn.signOut();
    await user.delete();
    debugPrint('[AUTH] Account deleted for $uid');
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) return null;

      debugPrint('[AUTH] Fetching user profile from Firebase');
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      
      if (!userDoc.exists) {
        return UserEntity(
          id: user.uid,
          email: user.email ?? '',
          displayName: user.displayName,
          photoUrl: user.photoURL,
        );
      }

      final data = userDoc.data()!;
      return UserEntity(
        id: user.uid,
        email: user.email ?? '',
        displayName: data['displayName'] ?? user.displayName,
        photoUrl: data['photoUrl'] ?? user.photoURL,
        dob: data['dob'],
      );
    } catch (e) {
      debugPrint('[AUTH] Error fetching current user: $e');
      return null;
    }
  }
}

