import 'package:fpdart/fpdart.dart';
import '../repositories/research_repository.dart';
import '../entities/research_file_entity.dart';
import '../../../../globals/error_handling/error_model.dart';

class GetResearchFilesUsecase {
  final ResearchRepository repository;
  GetResearchFilesUsecase({required this.repository});

  Future<Either<ErrorModel, List<ResearchFileEntity>>> call(int documentId) {
    return repository.getFilesByDocument(documentId);
  }
}

class UploadResearchFileUsecase {
  final ResearchRepository repository;
  UploadResearchFileUsecase({required this.repository});

  Future<Either<ErrorModel, ResearchFileEntity>> call({
    required int researchId,
    int? documentId,
    int? folderId,
    required String fileName,
    required List<int> bytes,
    required String mimeType,
  }) {
    return repository.uploadFile(
      researchId: researchId,
      documentId: documentId,
      folderId: folderId,
      fileName: fileName,
      bytes: bytes,
      mimeType: mimeType,
    );
  }
}

class DeleteResearchFileUsecase {
  final ResearchRepository repository;
  DeleteResearchFileUsecase({required this.repository});

  Future<Either<ErrorModel, void>> call(int fileId) {
    return repository.deleteFile(fileId);
  }
}
