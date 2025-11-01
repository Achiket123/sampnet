import 'package:fpdart/fpdart.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';

abstract class ValidateEmployeeRepository {
  Future<Either<ErrorModel, bool>> validateEmployee(String token);
}
