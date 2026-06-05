import 'package:fpdart/fpdart.dart';
import 'package:hackathon/features/employees/domain/entities/employee_entity.dart';
import 'package:hackathon/features/employees/domain/repositories/employees_repository.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';

class SearchEmployeesUsecase {
  final EmployeesRepository repository;
  SearchEmployeesUsecase(this.repository);

  Future<Either<ErrorModel, List<EmployeeEntity>>> call(String query) {
    return repository.searchEmployees(query);
  }
}
