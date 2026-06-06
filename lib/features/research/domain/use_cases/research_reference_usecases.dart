import 'package:fpdart/fpdart.dart';
import '../repositories/research_repository.dart';
import '../entities/research_reference_entity.dart';
import '../../../../globals/error_handling/error_model.dart';

class GetResearchReferencesUsecase {
  final ResearchRepository repository;
  GetResearchReferencesUsecase({required this.repository});

  Future<Either<ErrorModel, List<ResearchReferenceEntity>>> call(int documentId) {
    return repository.getReferencesByDocument(documentId);
  }
}

class AddResearchReferenceUsecase {
  final ResearchRepository repository;
  AddResearchReferenceUsecase({required this.repository});

  Future<Either<ErrorModel, ResearchReferenceEntity>> call({
    required int researchId,
    int? documentId,
    required String title,
    required String url,
    String? authors,
  }) {
    return repository.addReference(
      researchId: researchId,
      documentId: documentId,
      title: title,
      url: url,
      authors: authors,
    );
  }
}

class DeleteResearchReferenceUsecase {
  final ResearchRepository repository;
  DeleteResearchReferenceUsecase({required this.repository});

  Future<Either<ErrorModel, void>> call(int referenceId) {
    return repository.deleteReference(referenceId);
  }
}
