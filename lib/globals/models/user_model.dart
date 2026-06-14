// Dart Model for UserModel

import 'package:flutter/material.dart';
import 'package:hackathon/features/auth/domain/entity/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.email,
    required super.phoneNumber,
    required super.isVerified,
    super.hashedPassword,
    required super.profilePic,
    required super.city,
    required super.country,
    required super.lastLoginAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    debugPrint('DESIRIALIZE USER $json');

    return UserModel(
      id: (json['ID'] ?? json['id'] ?? 0) as int,
      firstName: (json['first_name'] ?? '') as String,
      lastName: (json['last_name'] ?? '') as String,
      email: (json['email'] ?? '') as String,
      phoneNumber: (json['phone_number'] ?? '') as String,
      isVerified: (json['is_verified'] ?? false) as bool,
      profilePic: (json['profile_id'] ?? json['profile_pic'] ?? '') as String,
      city: (json['city'] ?? '') as String,
      country: (json['country'] ?? '') as String,
      lastLoginAt: json['last_login_at'] != null && (json['last_login_at'] as String).isNotEmpty
          ? DateTime.parse(json['last_login_at'] as String)
          : DateTime.fromMillisecondsSinceEpoch(0),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ID': id,
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
