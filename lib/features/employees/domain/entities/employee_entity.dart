import 'package:equatable/equatable.dart';

class EmployeeEntity extends Equatable {
  final int userId;
  final int employmentId;
  final int organisationId;
  final String organisationName;
  final String type;
  final String salary;
  final DateTime lastLoginAt;
  final UserSummaryEntity user;

  const EmployeeEntity({
    required this.userId,
    required this.employmentId,
    required this.organisationId,
    required this.organisationName,
    required this.type,
    required this.salary,
    required this.lastLoginAt,
    required this.user,
  });

  bool get isRecentlyActive {
    final now = DateTime.now();
    final sevenDaysAgo = now.subtract(const Duration(days: 7));
    return lastLoginAt.isAfter(sevenDaysAgo);
  }

  String get roleDisplayLabel => type.isNotEmpty ? type : "Employee";

  bool get salaryIsSet => salary.isNotEmpty;

  @override
  List<Object?> get props => [
        userId,
        employmentId,
        organisationId,
        organisationName,
        type,
        salary,
        lastLoginAt,
        user,
      ];
}

class UserSummaryEntity extends Equatable {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String profilePic;

  const UserSummaryEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.profilePic,
  });

  String get fullName => '$firstName $lastName';
  
  String get initials {
    String first = firstName.isNotEmpty ? firstName[0].toUpperCase() : '';
    String last = lastName.isNotEmpty ? lastName[0].toUpperCase() : '';
    return '$first$last';
  }

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        email,
        phoneNumber,
        profilePic,
      ];
}
