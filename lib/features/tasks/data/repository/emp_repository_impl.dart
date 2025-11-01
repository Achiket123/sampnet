import 'package:fpdart/fpdart.dart';
import 'package:hackathon/features/tasks/data/data_sources/emp_data_sorce.dart';
import 'package:hackathon/features/tasks/data/models/assignee_model.dart';
import 'package:hackathon/features/tasks/domain/repositories/emp_repository.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';


class EmployeeRepositoryImpl implements EmployeeRepository {
  final EmployeeDataSource dataSource;
  EmployeeRepositoryImpl({required this.dataSource});
  @override
  Future<Either<ErrorModel, List<AssigneeModel>>> getEmployees(String token) async =>
      dataSource.getEmployees(token);
}
