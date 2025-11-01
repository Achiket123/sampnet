import 'package:fpdart/fpdart.dart';
import 'package:hackathon/features/attendence/domain/entities/attendamce_entity.dart';
import 'package:hackathon/features/attendence/domain/repositories/attendence_repository.dart';
import 'package:hackathon/features/attendence/domain/use_cases/attendence_params.dart';
import 'package:hackathon/globals/constants/usecase.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';

class AttendenceCheckInUsecase implements Usecase<AttendenceEntity,AttendenceParams>{
  final AttendenceRepository attendenceRepository;
  AttendenceCheckInUsecase({required this.attendenceRepository});

  @override
  Future<Either<ErrorModel, AttendenceEntity>> call(AttendenceParams params) async {
    return await attendenceRepository.checkInAttendence(params);
  }
}
class AttendenceCheckOutUsecase implements Usecase<AttendenceEntity,AttendenceParams>{
  final AttendenceRepository attendenceRepository;
  AttendenceCheckOutUsecase({required this.attendenceRepository});

  @override
  Future<Either<ErrorModel, AttendenceEntity>> call(AttendenceParams params) async {
    return await attendenceRepository.checkOutAttendence(params);
  }
}

class AttendenceGetUsecase implements Usecase<AttendenceEntity,int>{
  final AttendenceRepository attendenceRepository;
  AttendenceGetUsecase({required this.attendenceRepository});

  @override
  Future<Either<ErrorModel, AttendenceEntity>> call(int params) async {
    return await attendenceRepository.getAttendence(params);
  }
}

