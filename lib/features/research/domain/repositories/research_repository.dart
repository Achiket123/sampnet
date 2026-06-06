import 'package:fpdart/fpdart.dart';
import '../entities/research_entry_entity.dart';
import '../entities/research_folder_entity.dart';
import '../entities/research_document_entity.dart';
import '../entities/research_file_entity.dart';
import '../entities/research_reference_entity.dart';
import '../entities/research_workspace_data_entity.dart';
import '../../../../globals/error_handling/error_model.dart';

abstract class ResearchRepository {
  Future<Either<ErrorModel, ResearchEntryEntity>> createEntry(
      ResearchEntryEntity entry);
  Future<Either<ErrorModel, ResearchEntryEntity>> getEntry(int id);
  Future<Either<ErrorModel, ResearchListResponse>> getEntries({
    String? status,
    int? projectId,
    int? teamId,
    String? query,
    int limit = 10,
    int offset = 0,
  });
  Future<Either<ErrorModel, void>> updateEntry(ResearchEntryEntity entry);
  Future<Either<ErrorModel, void>> deleteEntry(int id);
  Future<Either<ErrorModel, ResearchWorkspaceDataEntity>> getWorkspace({
    required int researchId,
    int? parentFolderId,
  });
  Future<Either<ErrorModel, ResearchFolderEntity>> createFolder({
    required int researchId,
    required String name,
    int? parentFolderId,
  });
  Future<Either<ErrorModel, void>> updateFolder({
    required int folderId,
    required String name,
    int? parentFolderId,
  });
  Future<Either<ErrorModel, void>> deleteFolder(int folderId);
  Future<Either<ErrorModel, ResearchDocumentEntity>> getDocument(int id);
  Future<Either<ErrorModel, ResearchDocumentEntity>> createDocument({
    required int researchId,
    required String title,
    required String content,
    int? folderId,
  });
  Future<Either<ErrorModel, void>> updateDocument({
    required int documentId,
    required String title,
    required String content,
    int? folderId,
  });
  Future<Either<ErrorModel, void>> deleteDocument(int documentId);

  // Artifact Operations
  Future<Either<ErrorModel, List<ResearchFileEntity>>> getFilesByDocument(
      int documentId);
  Future<Either<ErrorModel, ResearchFileEntity>> uploadFile({
    required int researchId,
    int? documentId,
    int? folderId,
    required String fileName,
    required List<int> bytes,
    required String mimeType,
  });
  Future<Either<ErrorModel, void>> deleteFile(int fileId);

  Future<Either<ErrorModel, List<ResearchReferenceEntity>>>
      getReferencesByDocument(int documentId);
  Future<Either<ErrorModel, ResearchReferenceEntity>> addReference({
    required int researchId,
    int? documentId,
    required String title,
    required String url,
    String? authors,
  });
  Future<Either<ErrorModel, void>> deleteReference(int referenceId);
}

class ResearchListResponse {
  final List<ResearchEntryEntity> items;
  final int total;

  ResearchListResponse({required this.items, required this.total});
}
