import 'package:fpdart/fpdart.dart';
import '../../domain/entities/research_entry_entity.dart';
import '../../domain/repositories/research_repository.dart';
import '../data_sources/research_remote_data_source.dart';
import '../models/research_entry_model.dart';
import '../../../../globals/error_handling/error_model.dart';

class ResearchRepositoryImpl implements ResearchRepository {
  final ResearchRemoteDataSource remoteDataSource;

  ResearchRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<ErrorModel, ResearchEntryEntity>> createEntry(ResearchEntryEntity entry) async {
    try {
      final model = ResearchEntryModel.fromEntity(entry);
      final result = await remoteDataSource.createEntry(model);
      return Right(result);
    } catch (e) {
      return Left(ServerError(message: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, ResearchEntryEntity>> getEntry(int id) async {
    try {
      final result = await remoteDataSource.getEntry(id);
      return Right(result);
    } catch (e) {
      return Left(ServerError(message: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, ResearchListResponse>> getEntries({
    String? status,
    int? projectId,
    int? teamId,
    String? query,
    int limit = 10,
    int offset = 0,
  }) async {
    try {
      final result = await remoteDataSource.getEntries(
        status: status,
        projectId: projectId,
        teamId: teamId,
        query: query,
        limit: limit,
        offset: offset,
      );
      final List<dynamic> itemsJson = result['items'] ?? [];
      final int total = result['total'] ?? 0;
      final items = itemsJson.map((e) => ResearchEntryModel.fromJson(e)).toList();
      return Right(ResearchListResponse(items: items, total: total));
    } catch (e) {
      return Left(ServerError(message: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, void>> updateEntry(ResearchEntryEntity entry) async {
    try {
      final model = ResearchEntryModel.fromEntity(entry);
      await remoteDataSource.updateEntry(model);
      return const Right(null);
    } catch (e) {
      return Left(ServerError(message: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, void>> deleteEntry(int id) async {
    try {
      await remoteDataSource.deleteEntry(id);
      return const Right(null);
    } catch (e) {
      return Left(ServerError(message: e.toString()));
    }
  }
}
