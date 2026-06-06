import 'package:fpdart/fpdart.dart';
import '../../domain/entities/research_entry_entity.dart';
import '../../domain/entities/research_folder_entity.dart';
import '../../domain/entities/research_document_entity.dart';
import '../../domain/entities/research_file_entity.dart';
import '../../domain/entities/research_reference_entity.dart';
import '../../domain/entities/research_workspace_data_entity.dart';
import '../../domain/repositories/research_repository.dart';
import '../data_sources/research_remote_data_source.dart';
import '../models/research_entry_model.dart';
import '../models/research_file_model.dart';
import '../models/research_reference_model.dart';
import '../../../../globals/error_handling/error_model.dart';

class ResearchRepositoryImpl implements ResearchRepository {
  final ResearchRemoteDataSource remoteDataSource;

  ResearchRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<ErrorModel, ResearchEntryEntity>> createEntry(
      ResearchEntryEntity entry) async {
    try {
      final model = ResearchEntryModel.fromEntity(entry);
      final result = await remoteDataSource.createEntry(model);
      return Right(result);
    } catch (e) {
      return Left(ServerError(message: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, ResearchEntryEntity>> getEntry(int id) async {
    try {
      final result = await remoteDataSource.getEntry(id);
      return Right(result);
    } catch (e) {
      return Left(ServerError(message: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, ResearchListResponse>> getEntries({
    String? status,
    int? projectId,
    int? teamId,
    String? query,
    int limit = 10,
    int offset = 0,
  }) async {
    try {
      final result = await remoteDataSource.getEntries(
        status: status,
        projectId: projectId,
        teamId: teamId,
        query: query,
        limit: limit,
        offset: offset,
      );
      final List<dynamic> itemsJson = result['items'] ?? [];
      final int total = result['total'] ?? 0;
      final items =
          itemsJson.map((e) => ResearchEntryModel.fromJson(e)).toList();
      return Right(ResearchListResponse(items: items, total: total));
    } catch (e) {
      return Left(ServerError(message: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, void>> updateEntry(
      ResearchEntryEntity entry) async {
    try {
      final model = ResearchEntryModel.fromEntity(entry);
      await remoteDataSource.updateEntry(model);
      return const Right(null);
    } catch (e) {
      return Left(ServerError(message: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, void>> deleteEntry(int id) async {
    try {
      await remoteDataSource.deleteEntry(id);
      return const Right(null);
    } catch (e) {
      return Left(ServerError(message: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, ResearchWorkspaceDataEntity>> getWorkspace({
    required int researchId,
    int? parentFolderId,
  }) async {
    try {
      final folders = await remoteDataSource.getFolders(
        researchId: researchId,
        parentFolderId: parentFolderId,
      );
      final documents = await remoteDataSource.getDocuments(
        researchId: researchId,
        folderId: parentFolderId,
      );
      return Right(
        ResearchWorkspaceDataEntity(
          folders: folders,
          documents: documents,
        ),
      );
    } catch (e) {
      return Left(ServerError(message: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, ResearchFolderEntity>> createFolder({
    required int researchId,
    required String name,
    int? parentFolderId,
  }) async {
    try {
      final result = await remoteDataSource.createFolder(
        researchId: researchId,
        name: name,
        parentFolderId: parentFolderId,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerError(message: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, void>> updateFolder({
    required int folderId,
    required String name,
    int? parentFolderId,
  }) async {
    try {
      await remoteDataSource.updateFolder(
        folderId: folderId,
        name: name,
        parentFolderId: parentFolderId,
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerError(message: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, void>> deleteFolder(int folderId) async {
    try {
      await remoteDataSource.deleteFolder(folderId);
      return const Right(null);
    } catch (e) {
      return Left(ServerError(message: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, ResearchDocumentEntity>> getDocument(int id) async {
    try {
      final result = await remoteDataSource.getDocument(id);
      return Right(result);
    } catch (e) {
      return Left(ServerError(message: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, ResearchDocumentEntity>> createDocument({
    required int researchId,
    required String title,
    required String content,
    int? folderId,
  }) async {
    try {
      final result = await remoteDataSource.createDocument(
        researchId: researchId,
        title: title,
        content: content,
        folderId: folderId,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerError(message: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, void>> updateDocument({
    required int documentId,
    required String title,
    required String content,
    int? folderId,
  }) async {
    try {
      await remoteDataSource.updateDocument(
        documentId: documentId,
        title: title,
        content: content,
        folderId: folderId,
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerError(message: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, void>> deleteDocument(int documentId) async {
    try {
      await remoteDataSource.deleteDocument(documentId);
      return const Right(null);
    } catch (e) {
      return Left(ServerError(message: e.toString()));
    }
  }

  // --- Artifact Operations ---

  @override
  Future<Either<ErrorModel, List<ResearchFileEntity>>> getFilesByDocument(
      int documentId) async {
    try {
      final result = await remoteDataSource.getFilesByDocument(documentId);
      return Right(result);
    } catch (e) {
      return Left(ServerError(message: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, ResearchFileEntity>> uploadFile({
    required int researchId,
    int? documentId,
    int? folderId,
    required String fileName,
    required List<int> bytes,
    required String mimeType,
  }) async {
    try {
      final result = await remoteDataSource.uploadFile(
        researchId: researchId,
        documentId: documentId,
        folderId: folderId,
        fileName: fileName,
        bytes: bytes,
        mimeType: mimeType,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerError(message: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, void>> deleteFile(int fileId) async {
    try {
      await remoteDataSource.deleteFile(fileId);
      return const Right(null);
    } catch (e) {
      return Left(ServerError(message: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, List<ResearchReferenceEntity>>>
      getReferencesByDocument(int documentId) async {
    try {
      final result = await remoteDataSource.getReferencesByDocument(documentId);
      return Right(result);
    } catch (e) {
      return Left(ServerError(message: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, ResearchReferenceEntity>> addReference({
    required int researchId,
    int? documentId,
    required String title,
    required String url,
    String? authors,
  }) async {
    try {
      final result = await remoteDataSource.addReference(
        researchId: researchId,
        documentId: documentId,
        title: title,
        url: url,
        authors: authors,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerError(message: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, void>> deleteReference(int referenceId) async {
    try {
      await remoteDataSource.deleteReference(referenceId);
      return const Right(null);
    } catch (e) {
      return Left(ServerError(message: e.toString()));
    }
  }
}
