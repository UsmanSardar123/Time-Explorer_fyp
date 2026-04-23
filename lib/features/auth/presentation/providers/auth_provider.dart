import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:timeexplorer/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:timeexplorer/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:timeexplorer/features/auth/domain/entities/user_entity.dart';
import 'package:timeexplorer/features/auth/domain/usecases/auth_usecases.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepositoryImpl _repository = AuthRepositoryImpl(
    remoteDataSource: AuthRemoteDataSourceImpl(),
  );
  
  late final SignInUseCase _signInUseCase;
  late final SignUpUseCase _signUpUseCase;
  late final GoogleSignInUseCase _googleSignInUseCase;
  late final SignOutUseCase _signOutUseCase;
  late final GetCurrentUserUseCase _getCurrentUserUseCase;

  UserEntity? _currentUser;
  bool _isLoading = true; // Start as true during initial check
  String? _error;
  StreamSubscription<User?>? _authSubscription;

  UserEntity? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  // Directly check Firebase state for instant transitions
  bool get isAuthenticated => FirebaseAuth.instance.currentUser != null;

  bool get isAdmin {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || user.email == null) return false;
    return user.email!.toLowerCase().trim() == 'usmansardar037@gmail.com';
  }

  AuthProvider() {
    _signInUseCase = SignInUseCase(_repository);
    _signUpUseCase = SignUpUseCase(_repository);
    _googleSignInUseCase = GoogleSignInUseCase(_repository);
    _signOutUseCase = SignOutUseCase(_repository);
    _getCurrentUserUseCase = GetCurrentUserUseCase(_repository);
    
    _initAuthListener();
  }

  void _initAuthListener() {
    _authSubscription?.cancel();
    _authSubscription = FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user != null) {
        // Fetch full entity in background
        _currentUser = await _getCurrentUserUseCase();
      } else {
        _currentUser = null;
      }
      _isLoading = false;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  Future<void> signIn(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _signInUseCase(email, password);
      // Let the stream listener handle _currentUser assignment and navigation trigger
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
    } finally {
      notifyListeners();
    }
  }

  Future<void> signUp(String email, String password, String name, String dob) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _signUpUseCase(email, password, name, dob);
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
    } finally {
      notifyListeners();
    }
  }

  Future<void> signInWithGoogle() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _googleSignInUseCase();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
    } finally {
      notifyListeners();
    }
  }

  Future<void> forgotPassword(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  Future<void> signOut() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _signOutUseCase();
      _currentUser = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
