import 'package:timeexplorer/features/profile/domain/entities/profile_entity.dart';
import 'package:timeexplorer/features/profile/domain/repositories/profile_repository.dart';

class GetProfileUseCase {
  final ProfileRepository repository;
  GetProfileUseCase(this.repository);

  Future<ProfileEntity> call(String userId) {
    return repository.getProfile(userId);
  }
}

class UpdateProfileUseCase {
  final ProfileRepository repository;
  UpdateProfileUseCase(this.repository);

  Future<void> call(ProfileEntity profile) {
    return repository.updateProfile(profile);
  }
}

class ChangePasswordUseCase {
  final ProfileRepository repository;
  ChangePasswordUseCase(this.repository);

  Future<void> call(String currentPassword, String newPassword) {
    return repository.changePassword(currentPassword, newPassword);
  }
}

class UpdateEmailUseCase {
  final ProfileRepository repository;
  UpdateEmailUseCase(this.repository);

  Future<void> call(String newEmail, {String? currentPassword}) {
    return repository.updateEmail(newEmail, currentPassword: currentPassword);
  }
}

class CheckUsernameUniquenessUseCase {
  final ProfileRepository repository;
  CheckUsernameUniquenessUseCase(this.repository);

  Future<bool> call(String username) {
    return repository.checkUsernameUniqueness(username);
  }
}

class UploadProfileImageUseCase {
  final ProfileRepository repository;
  UploadProfileImageUseCase(this.repository);

  Future<String> call(String userId, dynamic file) {
    return repository.uploadProfileImage(userId, file);
  }
}
