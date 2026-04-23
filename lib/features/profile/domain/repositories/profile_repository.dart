import 'package:timeexplorer/features/profile/domain/entities/profile_entity.dart';

abstract class ProfileRepository {
  Future<ProfileEntity> getProfile(String userId);
  Future<void> updateProfile(ProfileEntity profile);
  Future<void> changePassword(String currentPassword, String newPassword);
  Future<void> updateEmail(String newEmail, {String? currentPassword});
  Future<bool> checkUsernameUniqueness(String username);
  Future<String> uploadProfileImage(String userId, dynamic file);
}
