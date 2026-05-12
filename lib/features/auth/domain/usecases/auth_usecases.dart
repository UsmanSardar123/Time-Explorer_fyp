import 'package:timeexplorer/features/auth/domain/entities/user_entity.dart';
import 'package:timeexplorer/features/auth/domain/repositories/auth_repository.dart';

class SignInUseCase {
  final AuthRepository repository;
  SignInUseCase(this.repository);

  Future<UserEntity> call(String email, String password) {
    return repository.signInWithEmail(email, password);
  }
}

class SignUpUseCase {
  final AuthRepository repository;
  SignUpUseCase(this.repository);

  Future<UserEntity> call(String email, String password, String name, String dob) {
    return repository.signUpWithEmail(email, password, name, dob);
  }
}

class GoogleSignInUseCase {
  final AuthRepository repository;
  GoogleSignInUseCase(this.repository);

  Future<UserEntity> call() {
    return repository.signInWithGoogle();
  }
}

class SignOutUseCase {
  final AuthRepository repository;
  SignOutUseCase(this.repository);

  Future<void> call() {
    return repository.signOut();
  }
}

class GetCurrentUserUseCase {
  final AuthRepository repository;
  GetCurrentUserUseCase(this.repository);

  Future<UserEntity?> call() {
    return repository.getCurrentUser();
  }
}

class DeleteAccountUseCase {
  final AuthRepository repository;
  DeleteAccountUseCase(this.repository);

  Future<void> call(String password) {
    return repository.deleteAccount(password);
  }
}
