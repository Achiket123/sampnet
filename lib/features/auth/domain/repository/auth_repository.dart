import 'package:fpdart/fpdart.dart';
import 'package:hackathon/features/auth/domain/entity/user_entity.dart';
import 'package:hackathon/features/auth/domain/usecase/auth_params.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';

abstract class AuthRepository {
  Future<Either<ErrorModel, UserEntity>> signIn(SignInParams params);
  Future<Either<ErrorModel, UserEntity>> signUp(SignUpParams params);
  Future<Either<ErrorModel, void>> saveToken(String token);
  Future<Either<ErrorModel, String>> getToken();
}
