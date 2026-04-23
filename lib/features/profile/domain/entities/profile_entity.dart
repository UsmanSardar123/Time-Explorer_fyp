import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
  final String id;
  final String email;
  final String displayName;
  final String? username;
  final String? photoUrl;
  final String? bio;
  final String? dob;
  final String? phoneNumber;
  final String? address;
  final String? gender;
  final String? privacySettings;

  const ProfileEntity({
    required this.id,
    required this.email,
    required this.displayName,
    this.username,
    this.photoUrl,
    this.bio,
    this.dob,
    this.phoneNumber,
    this.address,
    this.gender,
    this.privacySettings,
  });

  ProfileEntity copyWith({
    String? id,
    String? email,
    String? displayName,
    String? username,
    String? photoUrl,
    String? bio,
    String? dob,
    String? phoneNumber,
    String? address,
    String? gender,
    String? privacySettings,
  }) {
    return ProfileEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      username: username ?? this.username,
      photoUrl: photoUrl ?? this.photoUrl,
      bio: bio ?? this.bio,
      dob: dob ?? this.dob,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      gender: gender ?? this.gender,
      privacySettings: privacySettings ?? this.privacySettings,
    );
  }

  @override
  List<Object?> get props => [
        id,
        email,
        displayName,
        username,
        photoUrl,
        bio,
        dob,
        phoneNumber,
        address,
        gender,
        privacySettings,
      ];
}
