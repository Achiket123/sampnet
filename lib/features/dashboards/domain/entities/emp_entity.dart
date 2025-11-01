
import 'package:hackathon/features/auth/domain/entity/user_entity.dart';
import 'package:hackathon/globals/models/organisation_model.dart';

class EmployeeEntity {
  final int userId; 
  final UserEntity  user; 
  final int employmentId; 
  final int organisationId; 
  final Organisation organisation; 
  final String type; 
  final String salary; 
  final DateTime lastLoginAt; 

  EmployeeEntity({
    required this.userId,
    required this.user,
    required this.employmentId,
    required this.organisationId,
    required this.organisation,
    required this.type,
    required this.salary,
    required this.lastLoginAt,
  });

  
}
