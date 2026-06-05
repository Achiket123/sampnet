import 'package:fpdart/fpdart.dart';
import '../entities/research_entry_entity.dart';
import '../../../../globals/error_handling/error_model.dart';

abstract class ResearchRepository {
  Future<Either<ErrorModel, ResearchEntryEntity>> createEntry(ResearchEntryEntity entry);
  Future<Either<ErrorModel, ResearchEntryEntity>> getEntry(int id);
  Future<Either<ErrorModel, ResearchListResponse>> getEntries({
    String? status,
    int? projectId,
    int? teamId,
    String? query,
    int limit = 10,
    int offset = 0,
  });
  Future<Either<ErrorModel, void>> updateEntry(ResearchEntryEntity entry);
  Future<Either<ErrorModel, void>> deleteEntry(int id);
}

class ResearchListResponse {
  final List<ResearchEntryEntity> items;
  final int total;

  ResearchListResponse({required this.items, required this.total});
}
