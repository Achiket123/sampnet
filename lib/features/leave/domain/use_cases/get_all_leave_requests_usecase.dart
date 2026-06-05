import 'package:fpdart/fpdart.dart';
import 'package:hackathon/features/leave/domain/entities/leave_entity.dart';
import 'package:hackathon/features/leave/domain/repositories/leave_repository.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';

class GetAllLeaveRequestsUsecase {
  final LeaveRepository repository;

  GetAllLeaveRequestsUsecase({required this.repository});

  Future<Either<ErrorModel, List<Leave>>> call({
    required int organisationId,
    String status = '',
    int offset = 0,
  }) {
    return repository.getOrganisationLeaves(
      organisationId: organisationId,
      status: status,
      offset: offset,
    );
  }
}
