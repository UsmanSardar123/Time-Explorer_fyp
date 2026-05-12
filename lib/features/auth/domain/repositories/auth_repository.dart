import 'package:timeexplorer/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> signInWithEmail(String email, String password);
  Future<UserEntity> signUpWithEmail(String email, String password, String name, String dob);
  Future<UserEntity> signInWithGoogle();
  Future<void> signOut();
  Future<UserEntity?> getCurrentUser();
  Future<void> deleteAccount(String password);
}
