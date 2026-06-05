import 'package:fpdart/fpdart.dart';
import 'package:hackathon/features/employees/domain/entities/employee_entity.dart';
import 'package:hackathon/features/employees/domain/repositories/employees_repository.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';

class GetEmployeeProfileUsecase {
  final EmployeesRepository repository;
  GetEmployeeProfileUsecase(this.repository);

  Future<Either<ErrorModel, EmployeeEntity>> call(int id) {
    return repository.getEmployeeById(id);
  }
}
