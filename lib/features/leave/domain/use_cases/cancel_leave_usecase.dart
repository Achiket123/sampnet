import 'package:fpdart/fpdart.dart';
import 'package:hackathon/features/leave/domain/repositories/leave_repository.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';

class CancelLeaveUsecase {
  final LeaveRepository repository;

  CancelLeaveUsecase({required this.repository});

  Future<Either<ErrorModel, void>> call({required int leaveId}) {
    return repository.cancelLeave(leaveId: leaveId);
  }
}
