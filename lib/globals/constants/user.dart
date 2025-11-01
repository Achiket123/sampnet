import 'package:hackathon/features/auth/domain/entity/user_entity.dart';
import 'package:hackathon/features/dashboards/data/models/emp_model.dart';
import 'package:hackathon/globals/models/organisation_model.dart';

class User {
  static late UserEntity user;
  static late String token;
  static late Organisation organisation;
  static late EmpModel employee;
  static late String employeeToken;
}
