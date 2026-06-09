import 'package:fpdart/fpdart.dart';
import 'package:hackathon/features/auth/data/datasource/auth_local_datasource.dart';
import 'package:hackathon/features/auth/data/datasource/auth_remote_datasource.dart';
import 'package:hackathon/features/auth/data/model/auth_model.dart';
import 'package:hackathon/features/auth/domain/repository/auth_repository.dart';
import 'package:hackathon/features/auth/domain/usecase/auth_params.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';
import 'package:hackathon/globals/models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  AuthRepositoryImpl(
      {required this.remoteDataSource, required this.localDataSource});

  @override
  Future<Either<ErrorModel, AuthResponseModel>> signIn(SignInParams params) =>
      remoteDataSource.signIn(params);

  @override
  Future<Either<ErrorModel, AuthResponseModel>> signUp(SignUpParams params) =>
      remoteDataSource.signUp(params);

  @override
  Either<ErrorModel, String> getToken() {
    return localDataSource.getToken();
  }

  @override
  Future<Either<ErrorModel, void>> saveToken(String token) async {
    return await localDataSource.saveToken(token);
  }

  @override
  Future<Either<ErrorModel, AuthResponseModel>> acceptInvite({
    required String token,
    required String password,
  }) {
    return remoteDataSource.acceptInvite(token: token, password: password);
  }

  @override
  Future<Either<ErrorModel, void>> sendVerificationEmail() {
    return remoteDataSource.sendVerificationEmail();
  }

  @override
  Future<Either<ErrorModel, void>> verifyEmail(String token) {
    return remoteDataSource.verifyEmail(token);
  }

  @override
  Future<Either<ErrorModel, AuthResponseModel>> getMe() {
    return remoteDataSource.getMe();
  }
}
