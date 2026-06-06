import 'package:fpdart/fpdart.dart';

import '../../../../globals/error_handling/error_model.dart';
import '../entities/research_folder_entity.dart';
import '../repositories/research_repository.dart';

class CreateResearchFolderUsecase {
  final ResearchRepository repository;

  CreateResearchFolderUsecase({required this.repository});

  Future<Either<ErrorModel, ResearchFolderEntity>> call({
    required int researchId,
    required String name,
    int? parentFolderId,
  }) {
    return repository.createFolder(
      researchId: researchId,
      name: name,
      parentFolderId: parentFolderId,
    );
  }
}
