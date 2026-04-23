import 'package:timeexplorer/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:timeexplorer/features/profile/domain/entities/profile_entity.dart';
import 'package:timeexplorer/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;

  ProfileRepositoryImpl({required ProfileRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<ProfileEntity> getProfile(String userId) {
    return _remoteDataSource.getProfile(userId);
  }

  @override
  Future<void> updateProfile(ProfileEntity profile) {
    return _remoteDataSource.updateProfile(profile);
  }

  @override
  Future<void> changePassword(String currentPassword, String newPassword) {
    return _remoteDataSource.changePassword(currentPassword, newPassword);
  }

  @override
  Future<void> updateEmail(String newEmail, {String? currentPassword}) {
    return _remoteDataSource.updateEmail(newEmail, currentPassword: currentPassword);
  }

  @override
  Future<bool> checkUsernameUniqueness(String username) {
    return _remoteDataSource.checkUsernameUniqueness(username);
  }

  @override
  Future<String> uploadProfileImage(String userId, dynamic file) {
    return _remoteDataSource.uploadProfileImage(userId, file);
  }
}
