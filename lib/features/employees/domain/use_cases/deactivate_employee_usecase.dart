import 'package:fpdart/fpdart.dart';
import 'package:hackathon/features/employees/domain/repositories/employees_repository.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';

class DeactivateEmployeeUsecase {
  final EmployeesRepository repository;
  DeactivateEmployeeUsecase(this.repository);

  Future<Either<ErrorModel, void>> call(int employeeId) {
    return repository.deleteEmployee(employeeId);
  }
}
