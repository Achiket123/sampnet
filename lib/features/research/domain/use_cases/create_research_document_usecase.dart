import 'package:fpdart/fpdart.dart';

import '../../../../globals/error_handling/error_model.dart';
import '../entities/research_document_entity.dart';
import '../repositories/research_repository.dart';

class CreateResearchDocumentUsecase {
  final ResearchRepository repository;

  CreateResearchDocumentUsecase({required this.repository});

  Future<Either<ErrorModel, ResearchDocumentEntity>> call({
    required int researchId,
    required String title,
    required String content,
    int? folderId,
  }) {
    return repository.createDocument(
      researchId: researchId,
      title: title,
      content: content,
      folderId: folderId,
    );
  }
}
