import 'package:fpdart/fpdart.dart';
import '../repositories/research_repository.dart';
import '../../../../globals/error_handling/error_model.dart';

class FetchResearchListUsecase {
  final ResearchRepository repository;

  FetchResearchListUsecase({required this.repository});

  Future<Either<ErrorModel, ResearchListResponse>> call({
    String? status,
    int? projectId,
    int? teamId,
    String? query,
    int limit = 10,
    int offset = 0,
  }) {
    return repository.getEntries(
      status: status,
      projectId: projectId,
      teamId: teamId,
      query: query,
      limit: limit,
      offset: offset,
    );
  }
}
