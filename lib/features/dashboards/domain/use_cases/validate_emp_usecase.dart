import 'package:fpdart/fpdart.dart';
import 'package:hackathon/features/dashboards/domain/repositories/validate_emp_repo.dart';
import 'package:hackathon/globals/constants/usecase.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';

class ValidateEmpUsecase implements Usecase<bool, String> {
  final ValidateEmployeeRepository repository;
  ValidateEmpUsecase({required this.repository});
  @override
  Future<Either<ErrorModel, bool>> call(String token) async =>
      repository.validateEmployee(token);
}
