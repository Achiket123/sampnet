import 'package:fpdart/fpdart.dart';
import 'package:hackathon/features/auth/data/datasource/auth_local_datasource.dart';
import 'package:hackathon/features/auth/data/datasource/auth_remote_datasource.dart';
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
  Future<Either<ErrorModel, UserModel>> signIn(SignInParams params) =>
      remoteDataSource.signIn(params);

  @override
  Future<Either<ErrorModel, UserModel>> signUp(SignUpParams params) =>
      remoteDataSource.signUp(params);
      
        @override
        Future<Either<ErrorModel, String>> getToken() {
    return  localDataSource.getToken();
  }

        @override
        Future<Either<ErrorModel, void>> saveToken(String token) async {
    return await localDataSource.saveToken(token);
  }
  
}
