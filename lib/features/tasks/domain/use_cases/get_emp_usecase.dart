import 'package:fpdart/fpdart.dart';
import 'package:hackathon/features/tasks/domain/entities/assignee_entity.dart';
import 'package:hackathon/features/tasks/domain/repositories/emp_repository.dart';
import 'package:hackathon/globals/constants/usecase.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';

class GetEmployeesUseCase implements Usecase< List<AssigneeEntity>, String> {
  final EmployeeRepository employeeRepository;
  GetEmployeesUseCase({required this.employeeRepository});

  @override
  Future<Either<ErrorModel, List<AssigneeEntity>>> call(String token) async =>
      employeeRepository.getEmployees(token);
}
