import 'package:flutter/material.dart';
import 'package:hackathon/dependency_injection.g.dart';
import 'package:hackathon/features/dashboards/domain/entities/emp_entity.dart';
import 'package:hackathon/globals/constants/user.dart';

class EmpModel extends EmployeeEntity {
  EmpModel(
      {required super.userId,
      required super.user,
      required super.employmentId,
      required super.organisationId,
      required super.organisation,
      required super.type,
      required super.salary,
      required super.lastLoginAt});

  factory EmpModel.fromJson(Map<String, dynamic> json) {
    debugPrint(
      json.toString(),
    );
    return EmpModel(
      userId: json['user_id'],
      user: getIt<User>().user!,
      employmentId: json['employment_id'] ?? 0,
      organisationId: json['organisation_id'],
      organisation: getIt<User>().organisation!,
      type: json['type'] ?? 'employee',
      salary: json['salary'] ?? '',
      lastLoginAt: DateTime.parse(json['last_login_at']),
    );
  }
}
