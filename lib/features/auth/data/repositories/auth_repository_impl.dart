import 'package:timeexplorer/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:timeexplorer/features/auth/domain/entities/user_entity.dart';
import 'package:timeexplorer/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<UserEntity> signInWithEmail(String email, String password) {
    return _remoteDataSource.signInWithEmail(email, password);
  }

  @override
  Future<UserEntity> signUpWithEmail(String email, String password, String name, String dob) {
    return _remoteDataSource.signUpWithEmail(email, password, name, dob);
  }

  @override
  Future<UserEntity> signInWithGoogle() {
    return _remoteDataSource.signInWithGoogle();
  }

  @override
  Future<void> signOut() {
    return _remoteDataSource.signOut();
  }

  @override
  Future<UserEntity?> getCurrentUser() {
    return _remoteDataSource.getCurrentUser();
  }

  @override
  Future<void> deleteAccount(String password) {
    return _remoteDataSource.deleteAccount(password);
  }
}
