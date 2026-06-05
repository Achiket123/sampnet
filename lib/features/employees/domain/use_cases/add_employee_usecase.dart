import 'package:fpdart/fpdart.dart';
import 'package:hackathon/features/employees/domain/repositories/employees_repository.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';

class AddEmployeeUsecase {
  final EmployeesRepository repository;
  AddEmployeeUsecase(this.repository);

  Future<Either<ErrorModel, void>> call({
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
    required int employmentId,
  }) {
    return repository.addEmployee(
      firstName: firstName,
      lastName: lastName,
      email: email,
      phoneNumber: phoneNumber,
      employmentId: employmentId,
    );
  }
}
