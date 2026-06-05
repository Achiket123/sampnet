import 'package:hackathon/features/employees/domain/entities/employee_entity.dart';

class EmployeeModel {
  final int userId;
  final int employmentId;
  final int organisationId;
  final String organisationName;
  final String type;
  final String salary;
  final DateTime lastLoginAt;
  final UserSummaryModel user;

  const EmployeeModel({
    required this.userId,
    required this.employmentId,
    required this.organisationId,
    required this.organisationName,
    required this.type,
    required this.salary,
    required this.lastLoginAt,
    required this.user,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    final userJson = json['user'] as Map<String, dynamic>?;
    final orgJson = json['organisation'] as Map<String, dynamic>?;

    return EmployeeModel(
      userId: json['user_id'] as int? ?? 0,
      employmentId: json['employment_id'] as int? ?? 0,
      organisationId: json['organisation_id'] as int? ?? 0,
      organisationName: orgJson != null ? orgJson['company_name'] as String? ?? '' : '',
      type: json['type'] as String? ?? '',
      salary: json['salary'] as String? ?? '',
      lastLoginAt: json['last_login_at'] != null 
          ? DateTime.parse(json['last_login_at'] as String) 
          : DateTime.now(),
      user: UserSummaryModel.fromJson(userJson ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'employment_id': employmentId,
      'organisation_id': organisationId,
      'type': type,
      'salary': salary,
      'user': {
        'id': user.id,
        'first_name': user.firstName,
        'last_name': user.lastName,
        'email': user.email,
        'phone_number': user.phoneNumber,
        'profile_pic': user.profilePic,
      },
    };
  }

  EmployeeModel copyWith({
    int? userId,
    int? employmentId,
    int? organisationId,
    String? organisationName,
    String? type,
    String? salary,
    DateTime? lastLoginAt,
    UserSummaryModel? user,
  }) {
    return EmployeeModel(
      userId: userId ?? this.userId,
      employmentId: employmentId ?? this.employmentId,
      organisationId: organisationId ?? this.organisationId,
      organisationName: organisationName ?? this.organisationName,
      type: type ?? this.type,
      salary: salary ?? this.salary,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      user: user ?? this.user,
    );
  }

  EmployeeEntity toEntity() {
    return EmployeeEntity(
      userId: userId,
      employmentId: employmentId,
      organisationId: organisationId,
      organisationName: organisationName,
      type: type,
      salary: salary,
      lastLoginAt: lastLoginAt,
      user: user.toEntity(),
    );
  }
}

class UserSummaryModel {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String profilePic;

  const UserSummaryModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.profilePic,
  });

  factory UserSummaryModel.fromJson(Map<String, dynamic> json) {
    return UserSummaryModel(
      id: json['id'] as int? ?? 0,
      firstName: json['first_name'] as String? ?? '',
      lastName: json['last_name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phoneNumber: json['phone_number'] as String? ?? '',
      profilePic: json['profile_pic']?.toString() ?? '', // profile_id integer or string URL
    );
  }

  String get fullName => '$firstName $lastName';
  
  String get initials {
    String first = firstName.isNotEmpty ? firstName[0].toUpperCase() : '';
    String last = lastName.isNotEmpty ? lastName[0].toUpperCase() : '';
    return '$first$last';
  }

  UserSummaryEntity toEntity() {
    return UserSummaryEntity(
      id: id,
      firstName: firstName,
      lastName: lastName,
      email: email,
      phoneNumber: phoneNumber,
      profilePic: profilePic,
    );
  }
}
