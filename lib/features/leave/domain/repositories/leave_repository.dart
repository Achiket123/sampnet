import 'package:fpdart/fpdart.dart';
import 'package:hackathon/features/leave/domain/entities/leave_entity.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';

abstract class LeaveRepository {
  Future<Either<ErrorModel, Leave>> requestLeave({
    required int organisationId,
    required String leaveType,
    required DateTime startDate,
    required DateTime endDate,
    required String reason,
  });

  Future<Either<ErrorModel, List<Leave>>> getMyLeaves({int offset = 0});

  Future<Either<ErrorModel, List<Leave>>> getOrganisationLeaves({
    required int organisationId,
    String status = '',
    int offset = 0,
  });

  Future<Either<ErrorModel, void>> approveLeave({
    required int leaveId,
    String? managerNote,
  });

  Future<Either<ErrorModel, void>> rejectLeave({
    required int leaveId,
    String? managerNote,
  });

  Future<Either<ErrorModel, void>> cancelLeave({required int leaveId});
}
