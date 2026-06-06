import 'package:fpdart/fpdart.dart';

import '../../../../globals/error_handling/error_model.dart';
import '../repositories/research_repository.dart';

class UpdateResearchDocumentUsecase {
  final ResearchRepository repository;

  UpdateResearchDocumentUsecase({required this.repository});

  Future<Either<ErrorModel, void>> call({
    required int documentId,
    required String title,
    required String content,
    int? folderId,
  }) {
    return repository.updateDocument(
      documentId: documentId,
      title: title,
      content: content,
      folderId: folderId,
    );
  }
}
