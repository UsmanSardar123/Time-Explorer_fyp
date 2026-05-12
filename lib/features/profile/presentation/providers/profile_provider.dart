import 'package:flutter/material.dart';
import 'package:timeexplorer/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:timeexplorer/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:timeexplorer/features/profile/domain/entities/profile_entity.dart';
import 'package:timeexplorer/features/profile/domain/usecases/profile_usecases.dart';

class ProfileProvider extends ChangeNotifier {
  final ProfileRepositoryImpl _repository;
  
  late final GetProfileUseCase _getProfileUseCase;
  late final UpdateProfileUseCase _updateProfileUseCase;
  late final ChangePasswordUseCase _changePasswordUseCase;
  late final UpdateEmailUseCase _updateEmailUseCase;
  late final CheckUsernameUniquenessUseCase _checkUsernameUniquenessUseCase;
  late final UploadProfileImageUseCase _uploadProfileImageUseCase;

  ProfileEntity? _profile;
  bool _isLoading = false;
  String? _error;

  ProfileEntity? get profile => _profile;
  bool get isLoading => _isLoading;
  String? get error => _error;

  ProfileProvider({ProfileRepositoryImpl? repository})
      : _repository = repository ?? ProfileRepositoryImpl(
          remoteDataSource: ProfileRemoteDataSourceImpl(),
        ) {
    _getProfileUseCase = GetProfileUseCase(_repository);
    _updateProfileUseCase = UpdateProfileUseCase(_repository);
    _changePasswordUseCase = ChangePasswordUseCase(_repository);
    _updateEmailUseCase = UpdateEmailUseCase(_repository);
    _checkUsernameUniquenessUseCase = CheckUsernameUniquenessUseCase(_repository);
    _uploadProfileImageUseCase = UploadProfileImageUseCase(_repository);
  }

  Future<void> loadProfile(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _profile = await _getProfileUseCase(userId);
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateProfile(ProfileEntity newProfile) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _updateProfileUseCase(newProfile);
      _profile = newProfile;
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> changePassword(String currentPassword, String newPassword) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _changePasswordUseCase(currentPassword, newPassword);
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateEmail(String newEmail, {String? currentPassword}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _updateEmailUseCase(newEmail, currentPassword: currentPassword);
      if (_profile != null) {
        _profile = _profile!.copyWith(email: newEmail);
      }
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> isUsernameUnique(String username) async {
    _error = null;
    try {
      return await _checkUsernameUniquenessUseCase(username);
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      return false;
    }
  }

  Future<String?> uploadProfileImage(dynamic file) async {
    if (_profile == null) return null;
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final downloadUrl = await _uploadProfileImageUseCase(_profile!.id, file);
      _profile = _profile!.copyWith(photoUrl: downloadUrl);
      _error = null; // confirm clean state — guards against stale error on rebuild
      return downloadUrl;
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
