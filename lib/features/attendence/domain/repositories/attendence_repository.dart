import 'package:fpdart/fpdart.dart';
import 'package:hackathon/features/attendence/domain/entities/attendamce_entity.dart';
import 'package:hackathon/features/attendence/domain/use_cases/attendence_params.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';

abstract class AttendenceRepository {
  Future<Either<ErrorModel, AttendenceEntity>> checkInAttendence(AttendenceParams params);
  Future<Either<ErrorModel, AttendenceEntity>> checkOutAttendence(AttendenceParams params);
  Future<Either<ErrorModel, AttendenceEntity>> getAttendence(int userId);
}
