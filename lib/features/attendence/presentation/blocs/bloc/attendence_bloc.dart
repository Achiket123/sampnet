import 'package:bloc/bloc.dart';
import 'package:hackathon/features/attendence/domain/entities/attendamce_entity.dart';
import 'package:hackathon/features/attendence/domain/use_cases/attendence_params.dart';
import 'package:hackathon/features/attendence/domain/use_cases/attendence_usecase.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';
import 'package:meta/meta.dart';

part 'attendence_event.dart';
part 'attendence_state.dart';

class AttendenceBloc extends Bloc<AttendenceEvent, AttendenceState> {
  final AttendenceCheckInUsecase _attendenceCheckInUsecase;
  final AttendenceCheckOutUsecase _attendenceCheckOutUsecase;
  final AttendenceGetUsecase _attendenceGetUsecase;
  AttendenceBloc(
      {required AttendenceCheckInUsecase attendenceCheckInUsecase,
      required AttendenceCheckOutUsecase attendenceCheckOutUsecase,
      required AttendenceGetUsecase attendenceGetUsecase})
      : _attendenceCheckInUsecase = attendenceCheckInUsecase,
        _attendenceCheckOutUsecase = attendenceCheckOutUsecase,
        _attendenceGetUsecase = attendenceGetUsecase,
        super(AttendenceInitial()) {
    on<AttendenceEvent>((event, emit) {
      emit(AttendenceLoading());
    });

    on<AttendenceCheckInEvent>((event, emit) async {
      final result = await _attendenceCheckInUsecase(event.params);
      result.fold(
          (l) => emit(AttendenceFailure(errorModel: l)),
          (r) => emit(AttendenceSuccess(
              attendenceEntity: r,
              message: "Attendence Checked In Successfully")));
    });
    on<AttendenceCheckOutEvent>((event, emit) async {
      final result = await _attendenceCheckOutUsecase(event.params);
      result.fold(
          (l) => emit(AttendenceFailure(errorModel: l)),
          (r) => emit(AttendenceSuccess(
              attendenceEntity: r,
              message: "Attendence Checked Out Successfully")));
    });
    on<AttendenceGetEvent>((event, emit) async {
      final result = await _attendenceGetUsecase(event.userId);
      result.fold((l) => emit(AttendenceFailure(errorModel: l)),
          (r) => emit(AttendenceGetSuccess(attendenceEntity: r)));
    });
  }
}
