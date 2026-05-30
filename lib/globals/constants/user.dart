import 'package:flutter/material.dart';
import 'package:hackathon/features/auth/domain/entity/user_entity.dart';
import 'package:hackathon/features/dashboards/data/models/emp_model.dart';
import 'package:hackathon/globals/models/organisation_model.dart';

class User {
  UserEntity? user;
  String? token;
  Organisation? organisation;
  EmpModel? employee;
  String? employeeToken;
  User({
    this.user,
    this.token,
    this.organisation,
    this.employee,
    this.employeeToken,
  });

  @override
  toString() {
    if (organisation == null) {
      debugPrint("No Org");
    }
    if (employee == null) {
      debugPrint("No Emp");
    }
    if (user == null) {
      debugPrint("No User");
    }
    return "{}{}{}";
  }
}
