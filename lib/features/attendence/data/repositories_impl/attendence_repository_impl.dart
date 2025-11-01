import 'package:fpdart/src/either.dart';
import 'package:hackathon/features/attendence/data/data_sources/attendence_remote_data_source.dart';
import 'package:hackathon/features/attendence/data/models/attendence_model.dart';
import 'package:hackathon/features/attendence/domain/entities/attendamce_entity.dart';
import 'package:hackathon/features/attendence/domain/repositories/attendence_repository.dart';
import 'package:hackathon/features/attendence/domain/use_cases/attendence_params.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';

class AttendenceRepositoryImpl extends AttendenceRepository {
  final AttendenceRemoteDataSource attendenceRemoteDataSource;
  AttendenceRepositoryImpl({required this.attendenceRemoteDataSource});

  @override
  Future<Either<ErrorModel, AttendenceModel>> checkInAttendence(
      AttendenceParams params) async {
    return await attendenceRemoteDataSource.checkInAttendence(params);
  }

  @override
  Future<Either<ErrorModel, AttendenceModel>> checkOutAttendence(AttendenceParams params) async {
    return await attendenceRemoteDataSource.checkOutAttendence(params);
  }

  @override
  Future<Either<ErrorModel, AttendenceEntity>> getAttendence(int userId) async {
    return await attendenceRemoteDataSource.getAttendence(userId);
  }
}

