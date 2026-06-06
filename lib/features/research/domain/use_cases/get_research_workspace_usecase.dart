import 'package:fpdart/fpdart.dart';

import '../../../../globals/error_handling/error_model.dart';
import '../entities/research_workspace_data_entity.dart';
import '../repositories/research_repository.dart';

class GetResearchWorkspaceUsecase {
  final ResearchRepository repository;

  GetResearchWorkspaceUsecase({required this.repository});

  Future<Either<ErrorModel, ResearchWorkspaceDataEntity>> call({
    required int researchId,
    int? parentFolderId,
  }) {
    return repository.getWorkspace(
      researchId: researchId,
      parentFolderId: parentFolderId,
    );
  }
}
