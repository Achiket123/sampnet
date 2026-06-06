import 'package:fpdart/fpdart.dart';

import '../../../../globals/error_handling/error_model.dart';
import '../entities/research_document_entity.dart';
import '../repositories/research_repository.dart';

class GetResearchDocumentUsecase {
  final ResearchRepository repository;

  GetResearchDocumentUsecase({required this.repository});

  Future<Either<ErrorModel, ResearchDocumentEntity>> call(int documentId) {
    return repository.getDocument(documentId);
  }
}
