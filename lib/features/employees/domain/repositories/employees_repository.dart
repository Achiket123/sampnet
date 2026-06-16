import 'package:fpdart/fpdart.dart';
import 'package:hackathon/features/employees/domain/entities/employee_entity.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';

abstract class EmployeesRepository {
  Future<Either<ErrorModel, List<EmployeeEntity>>> getEmployees(int organisationId);
  Future<Either<ErrorModel, EmployeeEntity>> getEmployeeById(int id);
  Future<Either<ErrorModel, void>> addEmployee({
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
    required int employmentId,
  });
  Future<Either<ErrorModel, void>> updateEmployee(int employeeId, EmployeeEntity updated);
  Future<Either<ErrorModel, void>> deleteEmployee(int employeeId);
  Future<Either<ErrorModel, List<EmployeeEntity>>> searchEmployees(String query);
  Future<Either<ErrorModel, void>> makeManager({
    required int userId,
    required int organisationId,
    required String type,
    required String salary,
  });
  Future<Either<ErrorModel, void>> resendInvite(String email);
}
