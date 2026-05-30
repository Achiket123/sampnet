import 'package:fpdart/fpdart.dart';
import 'package:hackathon/features/auth/domain/entity/user_entity.dart';
import 'package:hackathon/features/auth/domain/usecase/auth_params.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';

abstract class AuthRepository {
  Future<Either<ErrorModel, AuthResponseEntity>> signIn(SignInParams params);
  Future<Either<ErrorModel, AuthResponseEntity>> signUp(SignUpParams params);
  Future<Either<ErrorModel, void>> saveToken(String token);
  Either<ErrorModel, String> getToken();
}
