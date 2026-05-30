class UserEntity {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final bool isVerified;
  final String? hashedPassword;
  final String profilePic;
  final String city;
  final String country;
  final DateTime lastLoginAt;

  UserEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.isVerified,
    this.hashedPassword,
    required this.profilePic,
    required this.city,
    required this.country,
    required this.lastLoginAt,
  });
}

class AuthResponseEntity {
  final UserEntity userEntity;
  final String token;
  AuthResponseEntity({required this.userEntity, required this.token});
}
