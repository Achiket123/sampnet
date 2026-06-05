import 'package:fpdart/fpdart.dart';
import 'package:hackathon/features/leave/domain/repositories/leave_repository.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';

class RejectLeaveUsecase {
  final LeaveRepository repository;

  RejectLeaveUsecase({required this.repository});

  Future<Either<ErrorModel, void>> call({
    required int leaveId,
    String? managerNote,
  }) {
    return repository.rejectLeave(
      leaveId: leaveId,
      managerNote: managerNote,
    );
  }
}
