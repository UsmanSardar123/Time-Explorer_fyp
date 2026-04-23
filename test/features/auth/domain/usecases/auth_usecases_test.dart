import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:timeexplorer/features/auth/domain/entities/user_entity.dart';
import 'package:timeexplorer/features/auth/domain/repositories/auth_repository.dart';
import 'package:timeexplorer/features/auth/domain/usecases/auth_usecases.dart';

import 'auth_usecases_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  late MockAuthRepository mockAuthRepository;
  late SignInUseCase signInUseCase;
  late SignUpUseCase signUpUseCase;
  late GoogleSignInUseCase googleSignInUseCase;
  late SignOutUseCase signOutUseCase;
  late GetCurrentUserUseCase getCurrentUserUseCase;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    signInUseCase = SignInUseCase(mockAuthRepository);
    signUpUseCase = SignUpUseCase(mockAuthRepository);
    googleSignInUseCase = GoogleSignInUseCase(mockAuthRepository);
    signOutUseCase = SignOutUseCase(mockAuthRepository);
    getCurrentUserUseCase = GetCurrentUserUseCase(mockAuthRepository);
  });

  const tUser = UserEntity(
    id: '1',
    email: 'test@example.com',
    displayName: 'Test User',
    photoUrl: 'https://example.com/photo.jpg',
  );

  group('SignInUseCase', () {
    test('should return UserEntity when sign in is successful', () async {
      // Arrange
      when(mockAuthRepository.signInWithEmail(any, any))
          .thenAnswer((_) async => tUser);

      // Act
      final result = await signInUseCase('test@example.com', 'password');

      // Assert
      expect(result, tUser);
      verify(mockAuthRepository.signInWithEmail('test@example.com', 'password'));
      verifyNoMoreInteractions(mockAuthRepository);
    });
  });

  group('SignUpUseCase', () {
    test('should return UserEntity when sign up is successful', () async {
      // Arrange
      when(mockAuthRepository.signUpWithEmail(any, any, any, any))
          .thenAnswer((_) async => tUser);

      // Act
      final result = await signUpUseCase('test@example.com', 'password', 'Test User', '2000-01-01');

      // Assert
      expect(result, tUser);
      verify(mockAuthRepository.signUpWithEmail('test@example.com', 'password', 'Test User', '2000-01-01'));
      verifyNoMoreInteractions(mockAuthRepository);
    });
  });

  group('GoogleSignInUseCase', () {
    test('should return UserEntity when google sign in is successful', () async {
      // Arrange
      when(mockAuthRepository.signInWithGoogle())
          .thenAnswer((_) async => tUser);

      // Act
      final result = await googleSignInUseCase();

      // Assert
      expect(result, tUser);
      verify(mockAuthRepository.signInWithGoogle());
      verifyNoMoreInteractions(mockAuthRepository);
    });
  });

  group('SignOutUseCase', () {
    test('should call signOut on repository', () async {
      // Arrange
      when(mockAuthRepository.signOut()).thenAnswer((_) async => {});

      // Act
      await signOutUseCase();

      // Assert
      verify(mockAuthRepository.signOut());
      verifyNoMoreInteractions(mockAuthRepository);
    });
  });

  group('GetCurrentUserUseCase', () {
    test('should return UserEntity when user is logged in', () async {
      // Arrange
      when(mockAuthRepository.getCurrentUser())
          .thenAnswer((_) async => tUser);

      // Act
      final result = await getCurrentUserUseCase();

      // Assert
      expect(result, tUser);
      verify(mockAuthRepository.getCurrentUser());
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should return null when user is not logged in', () async {
      // Arrange
      when(mockAuthRepository.getCurrentUser())
          .thenAnswer((_) async => null);

      // Act
      final result = await getCurrentUserUseCase();

      // Assert
      expect(result, null);
      verify(mockAuthRepository.getCurrentUser());
      verifyNoMoreInteractions(mockAuthRepository);
    });
  });
}
