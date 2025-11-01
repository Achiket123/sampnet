import 'package:fpdart/fpdart.dart';
import 'package:hackathon/features/dashboards/data/data_sources/validate_emp_datasource.dart';
import 'package:hackathon/features/dashboards/domain/repositories/validate_emp_repo.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';

class ValidateEmpRepoImpl implements ValidateEmployeeRepository {
  final ValidateEmpDataSource dataSource;
  ValidateEmpRepoImpl({required this.dataSource});
  @override
  Future<Either<ErrorModel, bool>> validateEmployee(String token) async =>
      dataSource.validateEmployee(token);
}
