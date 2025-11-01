import 'package:fpdart/fpdart.dart';
import 'package:hackathon/features/tasks/domain/entities/assignee_entity.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';

abstract class EmployeeRepository {
  Future<Either<ErrorModel, List<AssigneeEntity>>> getEmployees(String token);
}
