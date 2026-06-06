import 'package:fpdart/fpdart.dart';

import '../../../../globals/error_handling/error_model.dart';
import '../repositories/research_repository.dart';

class DeleteResearchDocumentUsecase {
  final ResearchRepository repository;

  DeleteResearchDocumentUsecase({required this.repository});

  Future<Either<ErrorModel, void>> call(int documentId) {
    return repository.deleteDocument(documentId);
  }
}
