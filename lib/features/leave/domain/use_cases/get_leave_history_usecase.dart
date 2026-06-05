import 'package:fpdart/fpdart.dart';
import 'package:hackathon/features/leave/domain/entities/leave_entity.dart';
import 'package:hackathon/features/leave/domain/repositories/leave_repository.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';

class GetLeaveHistoryUsecase {
  final LeaveRepository repository;

  GetLeaveHistoryUsecase({required this.repository});

  Future<Either<ErrorModel, List<Leave>>> call({int offset = 0}) {
    return repository.getMyLeaves(offset: offset);
  }
}
