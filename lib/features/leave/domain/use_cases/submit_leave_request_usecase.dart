import 'package:fpdart/fpdart.dart';
import 'package:hackathon/features/leave/domain/entities/leave_entity.dart';
import 'package:hackathon/features/leave/domain/repositories/leave_repository.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';

class SubmitLeaveRequestUsecase {
  final LeaveRepository repository;

  SubmitLeaveRequestUsecase({required this.repository});

  Future<Either<ErrorModel, Leave>> call({
    required int organisationId,
    required String leaveType,
    required DateTime startDate,
    required DateTime endDate,
    required String reason,
  }) {
    return repository.requestLeave(
      organisationId: organisationId,
      leaveType: leaveType,
      startDate: startDate,
      endDate: endDate,
      reason: reason,
    );
  }
}
