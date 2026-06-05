import 'package:fpdart/fpdart.dart';
import 'package:hackathon/features/leave/data/data_sources/leave_remote_data_source.dart';
import 'package:hackathon/features/leave/domain/entities/leave_entity.dart';
import 'package:hackathon/features/leave/domain/repositories/leave_repository.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';

class LeaveRepositoryImpl implements LeaveRepository {
  final LeaveRemoteDataSource remoteDataSource;

  LeaveRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<ErrorModel, Leave>> requestLeave({
    required int organisationId,
    required String leaveType,
    required DateTime startDate,
    required DateTime endDate,
    required String reason,
  }) async {
    try {
      final leave = await remoteDataSource.requestLeave(
        organisationId: organisationId,
        leaveType: leaveType,
        startDate: startDate,
        endDate: endDate,
        reason: reason,
      );
      return Right(leave);
    } catch (e) {
      return Left(ServerError(message: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, List<Leave>>> getMyLeaves({int offset = 0}) async {
    try {
      final leaves = await remoteDataSource.getMyLeaves(offset: offset);
      return Right(leaves);
    } catch (e) {
      return Left(ServerError(message: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, List<Leave>>> getOrganisationLeaves({
    required int organisationId,
    String status = '',
    int offset = 0,
  }) async {
    try {
      final leaves = await remoteDataSource.getOrganisationLeaves(
        organisationId: organisationId,
        status: status,
        offset: offset,
      );
      return Right(leaves);
    } catch (e) {
      return Left(ServerError(message: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, void>> approveLeave({
    required int leaveId,
    String? managerNote,
  }) async {
    try {
      await remoteDataSource.approveLeave(
        leaveId: leaveId,
        managerNote: managerNote,
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerError(message: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, void>> rejectLeave({
    required int leaveId,
    String? managerNote,
  }) async {
    try {
      await remoteDataSource.rejectLeave(
        leaveId: leaveId,
        managerNote: managerNote,
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerError(message: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, void>> cancelLeave({required int leaveId}) async {
    try {
      await remoteDataSource.cancelLeave(leaveId: leaveId);
      return const Right(null);
    } catch (e) {
      return Left(ServerError(message: e.toString()));
    }
  }
}
