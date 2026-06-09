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

class AcceptInviteParams {
  final String token;
  final String password;
  AcceptInviteParams({required this.token, required this.password});
}

class AcceptInviteUseCase implements Usecase<AuthResponseEntity, AcceptInviteParams> {
  final AuthRepository repository;
  AcceptInviteUseCase({required this.repository});

  @override
  Future<Either<ErrorModel, AuthResponseEntity>> call(AcceptInviteParams params) =>
      repository.acceptInvite(token: params.token, password: params.password);
}

class SendVerificationEmailUsecase implements Usecase<void, Null> {
  final AuthRepository repository;
  SendVerificationEmailUsecase({required this.repository});

  @override
  Future<Either<ErrorModel, void>> call(Null _) =>
      repository.sendVerificationEmail();
}

class VerifyEmailUsecase implements Usecase<void, String> {
  final AuthRepository repository;
  VerifyEmailUsecase({required this.repository});

  @override
  Future<Either<ErrorModel, void>> call(String token) =>
      repository.verifyEmail(token);
}

class GetMeUsecase implements Usecase<AuthResponseEntity, Null> {
  final AuthRepository repository;
  GetMeUsecase({required this.repository});

  @override
  Future<Either<ErrorModel, AuthResponseEntity>> call(Null _) =>
      repository.getMe();
}
