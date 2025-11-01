// Dart Model for UserModel

import 'package:hackathon/features/auth/domain/entity/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.email,
    required super.phoneNumber,
    required super.isVerified,
    required super.hashedPassword,
    required super.profilePic,
    required super.city,
    required super.country,
    required super.lastLoginAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['ID'] as int,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      email: json['email'] as String,
      phoneNumber: json['phone_number'] as String,
      isVerified: json['is_verified'] as bool,
      hashedPassword: json['HashedPassword'] as String,
      profilePic: json['profile_id'] as String,
      city: json['city'] as String,
      country: json['country'] as String,
      lastLoginAt: DateTime.parse(json['last_login_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone_number': phoneNumber,
      'is_verified': isVerified,
      'hashed_password': hashedPassword,
      'profile_id': profilePic,
      'city': city,
      'country': country,
      'last_login_at': lastLoginAt.toIso8601String(),
    };
  }
}
