import 'package:fpdart/fpdart.dart';
import 'package:hackathon/features/employees/domain/entities/employee_entity.dart';
import 'package:hackathon/features/employees/domain/repositories/employees_repository.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';

class EditEmployeeUsecase {
  final EmployeesRepository repository;
  EditEmployeeUsecase(this.repository);

  Future<Either<ErrorModel, void>> call(int employeeId, EmployeeEntity updated) {
    return repository.updateEmployee(employeeId, updated);
  }
}
