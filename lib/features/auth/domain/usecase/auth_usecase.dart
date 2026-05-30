import 'package:fpdart/fpdart.dart';
import 'package:hackathon/features/auth/domain/entity/user_entity.dart';
import 'package:hackathon/features/auth/domain/repository/auth_repository.dart';
import 'package:hackathon/features/auth/domain/usecase/auth_params.dart';
import 'package:hackathon/globals/constants/usecase.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';

class SignUpUsecase implements Usecase<AuthResponseEntity, SignUpParams> {
  final AuthRepository repository;
  SignUpUsecase({required this.repository});

  @override
  Future<Either<ErrorModel, AuthResponseEntity>> call(SignUpParams params) =>
      repository.signUp(params);
}

class SignInUsecase implements Usecase<AuthResponseEntity, SignInParams> {
  final AuthRepository repository;
  SignInUsecase({required this.repository});

  @override
  Future<Either<ErrorModel, AuthResponseEntity>> call(SignInParams params) =>
      repository.signIn(params);
}

class SaveTokenUsecase implements Usecase<void, String> {
  final AuthRepository repository;
  SaveTokenUsecase({required this.repository});

  @override
  Future<Either<ErrorModel, void>> call(String token) async =>
      await repository.saveToken(token);
}

class GetTokenUsecase implements NonFutureUsecase<String, Null> {
  final AuthRepository repository;
  GetTokenUsecase({required this.repository});

  @override
  Either<ErrorModel, String> call(Null _null) => repository.getToken();
}
