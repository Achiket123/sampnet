import 'package:fpdart/fpdart.dart';

import '../../../../globals/error_handling/error_model.dart';
import '../repositories/research_repository.dart';

class DeleteResearchFolderUsecase {
  final ResearchRepository repository;

  DeleteResearchFolderUsecase({required this.repository});

  Future<Either<ErrorModel, void>> call(int folderId) {
    return repository.deleteFolder(folderId);
  }
}
