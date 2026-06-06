import 'dart:convert';
import '../../../../services/api_client.dart';
import '../models/research_entry_model.dart';
import '../models/research_folder_model.dart';
import '../models/research_document_model.dart';
import '../models/research_file_model.dart';
import '../models/research_reference_model.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

abstract class ResearchRemoteDataSource {
  Future<ResearchEntryModel> createEntry(ResearchEntryModel entry);
  Future<ResearchEntryModel> getEntry(int id);
  Future<Map<String, dynamic>> getEntries({
    String? status,
    int? projectId,
    int? teamId,
    String? query,
    int limit = 10,
    int offset = 0,
  });
  Future<void> updateEntry(ResearchEntryModel entry);
  Future<void> deleteEntry(int id);
  Future<List<ResearchFolderModel>> getFolders({
    required int researchId,
    int? parentFolderId,
  });
  Future<ResearchFolderModel> createFolder({
    required int researchId,
    required String name,
    int? parentFolderId,
  });
  Future<void> updateFolder({
    required int folderId,
    required String name,
    int? parentFolderId,
  });
  Future<void> deleteFolder(int folderId);
  Future<List<ResearchDocumentModel>> getDocuments({
    required int researchId,
    int? folderId,
  });
  Future<ResearchDocumentModel> getDocument(int id);
  Future<ResearchDocumentModel> createDocument({
    required int researchId,
    required String title,
    required String content,
    int? folderId,
  });
  Future<void> updateDocument({
    required int documentId,
    required String title,
    required String content,
    int? folderId,
  });
  Future<void> deleteDocument(int documentId);

  // Artifact Operations
  Future<List<ResearchFileModel>> getFilesByDocument(int documentId);
  Future<ResearchFileModel> uploadFile({
    required int researchId,
    int? documentId,
    int? folderId,
    required String fileName,
    required List<int> bytes,
    required String mimeType,
  });
  Future<void> deleteFile(int fileId);

  Future<List<ResearchReferenceModel>> getReferencesByDocument(int documentId);
  Future<ResearchReferenceModel> addReference({
    required int researchId,
    int? documentId,
    required String title,
    required String url,
    String? authors,
  });
  Future<void> deleteReference(int referenceId);
}

class ResearchRemoteDataSourceImpl implements ResearchRemoteDataSource {
  final ApiClient apiClient;

  ResearchRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<ResearchEntryModel> createEntry(ResearchEntryModel entry) async {
    final response = await apiClient.post('/research', body: entry.toJson());
    if (response.statusCode == 201) {
      final data = json.decode(response.body);
      return ResearchEntryModel.fromJson(data['data']);
    } else {
      throw Exception('Failed to create research entry');
    }
  }

  @override
  Future<ResearchEntryModel> getEntry(int id) async {
    final response = await apiClient.get('/research/$id');
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return ResearchEntryModel.fromJson(data['data']);
    } else {
      throw Exception('Failed to get research entry');
    }
  }

  @override
  Future<Map<String, dynamic>> getEntries({
    String? status,
    int? projectId,
    int? teamId,
    String? query,
    int limit = 10,
    int offset = 0,
  }) async {
    String endpoint = '/research?limit=$limit&offset=$offset';
    if (status != null) endpoint += '&status=$status';
    if (projectId != null) endpoint += '&project_id=$projectId';
    if (teamId != null) endpoint += '&team_id=$teamId';
    if (query != null) endpoint += '&q=$query';

    final response = await apiClient.get(endpoint);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to get research entries');
    }
  }

  @override
  Future<void> updateEntry(ResearchEntryModel entry) async {
    final response =
        await apiClient.put('/research/${entry.id}', body: entry.toJson());
    if (response.statusCode != 200) {
      throw Exception('Failed to update research entry');
    }
  }

  @override
  Future<void> deleteEntry(int id) async {
    final response = await apiClient.delete('/research/$id');
    if (response.statusCode != 200) {
      throw Exception('Failed to delete research entry');
    }
  }

  @override
  Future<List<ResearchFolderModel>> getFolders({
    required int researchId,
    int? parentFolderId,
  }) async {
    var endpoint = '/research/folders?research_id=$researchId';
    if (parentFolderId != null) {
      endpoint += '&parent_id=$parentFolderId';
    }
    final response = await apiClient.get(endpoint);
    if (response.statusCode != 200) {
      throw Exception('Failed to get folders');
    }
    final data = json.decode(response.body) as Map<String, dynamic>;
    return (data['data'] as List<dynamic>? ?? const [])
        .map((item) =>
            ResearchFolderModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<ResearchFolderModel> createFolder({
    required int researchId,
    required String name,
    int? parentFolderId,
  }) async {
    final response = await apiClient.post(
      '/research/folders',
      body: {
        'research_id': researchId,
        'name': name,
        'parent_id': parentFolderId,
      },
    );
    if (response.statusCode != 201) {
      throw Exception(
          _extractError(response.body, fallback: 'Failed to create folder'));
    }
    final data = json.decode(response.body) as Map<String, dynamic>;
    return ResearchFolderModel.fromJson(data['data'] as Map<String, dynamic>);
  }

  @override
  Future<void> updateFolder({
    required int folderId,
    required String name,
    int? parentFolderId,
  }) async {
    final response = await apiClient.put(
      '/research/folders/$folderId',
      body: {
        'name': name,
        'parent_id': parentFolderId,
      },
    );
    if (response.statusCode != 200) {
      throw Exception(
          _extractError(response.body, fallback: 'Failed to update folder'));
    }
  }

  @override
  Future<void> deleteFolder(int folderId) async {
    final response = await apiClient.delete('/research/folders/$folderId');
    if (response.statusCode != 200) {
      throw Exception(
          _extractError(response.body, fallback: 'Failed to delete folder'));
    }
  }

  @override
  Future<List<ResearchDocumentModel>> getDocuments({
    required int researchId,
    int? folderId,
  }) async {
    var endpoint = '/research/documents?research_id=$researchId';
    if (folderId != null) {
      endpoint += '&folder_id=$folderId';
    }
    final response = await apiClient.get(endpoint);
    if (response.statusCode != 200) {
      throw Exception('Failed to get documents');
    }
    final data = json.decode(response.body) as Map<String, dynamic>;
    return (data['data'] as List<dynamic>? ?? const [])
        .map((item) =>
            ResearchDocumentModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<ResearchDocumentModel> getDocument(int id) async {
    final response = await apiClient.get('/research/documents/$id');
    if (response.statusCode != 200) {
      throw Exception('Failed to get document');
    }
    final data = json.decode(response.body) as Map<String, dynamic>;
    return ResearchDocumentModel.fromJson(data['data'] as Map<String, dynamic>);
  }

  @override
  Future<ResearchDocumentModel> createDocument({
    required int researchId,
    required String title,
    required String content,
    int? folderId,
  }) async {
    final response = await apiClient.post(
      '/research/documents',
      body: {
        'research_id': researchId,
        'title': title,
        'content': content,
        'folder_id': folderId,
      },
    );
    if (response.statusCode != 201) {
      throw Exception(
          _extractError(response.body, fallback: 'Failed to create document'));
    }
    final data = json.decode(response.body) as Map<String, dynamic>;
    return ResearchDocumentModel.fromJson(data['data'] as Map<String, dynamic>);
  }

  @override
  Future<void> updateDocument({
    required int documentId,
    required String title,
    required String content,
    int? folderId,
  }) async {
    final response = await apiClient.put(
      '/research/documents/$documentId',
      body: {
        'title': title,
        'content': content,
        'folder_id': folderId,
      },
    );
    if (response.statusCode != 200) {
      throw Exception(
          _extractError(response.body, fallback: 'Failed to update document'));
    }
  }

  @override
  Future<void> deleteDocument(int documentId) async {
    final response = await apiClient.delete('/research/documents/$documentId');
    if (response.statusCode != 200) {
      throw Exception(
          _extractError(response.body, fallback: 'Failed to delete document'));
    }
  }

  // --- Artifact Operations ---

  @override
  Future<List<ResearchFileModel>> getFilesByDocument(int documentId) async {
    final response =
        await apiClient.get('/research/files?document_id=$documentId');
    if (response.statusCode != 200) {
      throw Exception('Failed to get document files');
    }
    final data = json.decode(response.body) as Map<String, dynamic>;
    return (data['data'] as List<dynamic>? ?? const [])
        .map((item) => ResearchFileModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<ResearchFileModel> uploadFile({
    required int researchId,
    int? documentId,
    int? folderId,
    required String fileName,
    required List<int> bytes,
    required String mimeType,
  }) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('${apiClient.baseUrl}/research/files'),
    );

    request.fields['research_id'] = researchId.toString();
    if (documentId != null)
      request.fields['document_id'] = documentId.toString();
    if (folderId != null) request.fields['folder_id'] = folderId.toString();

    final multipartFile = http.MultipartFile.fromBytes(
      'file',
      bytes,
      filename: fileName,
      contentType: MediaType.parse(mimeType),
    );
    request.files.add(multipartFile);

    final response = await apiClient.sendMultipart(request);
    if (response.statusCode != 201) {
      final body = await response.stream.bytesToString();
      throw Exception(_extractError(body, fallback: 'Failed to upload file'));
    }
    final data = json.decode(await response.stream.bytesToString())
        as Map<String, dynamic>;
    return ResearchFileModel.fromJson(data['data'] as Map<String, dynamic>);
  }

  @override
  Future<void> deleteFile(int fileId) async {
    final response = await apiClient.delete('/research/files/$fileId');
    if (response.statusCode != 200) {
      throw Exception('Failed to delete file');
    }
  }

  @override
  Future<List<ResearchReferenceModel>> getReferencesByDocument(
      int documentId) async {
    final response =
        await apiClient.get('/research/references?document_id=$documentId');
    if (response.statusCode != 200) {
      throw Exception('Failed to get document references');
    }
    final data = json.decode(response.body) as Map<String, dynamic>;
    return (data['data'] as List<dynamic>? ?? const [])
        .map((item) =>
            ResearchReferenceModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<ResearchReferenceModel> addReference({
    required int researchId,
    int? documentId,
    required String title,
    required String url,
    String? authors,
  }) async {
    final response = await apiClient.post(
      '/research/references',
      body: {
        'research_id': researchId,
        'document_id': documentId,
        'title': title,
        'url': url,
        'authors': authors,
      },
    );
    if (response.statusCode != 201) {
      throw Exception(
          _extractError(response.body, fallback: 'Failed to add link'));
    }
    final data = json.decode(response.body) as Map<String, dynamic>;
    return ResearchReferenceModel.fromJson(data['data'] as Map<String, dynamic>);
  }

  @override
  Future<void> deleteReference(int referenceId) async {
    final response =
        await apiClient.delete('/research/references/$referenceId');
    if (response.statusCode != 200) {
      throw Exception('Failed to delete reference');
    }
  }

  String _extractError(String body, {required String fallback}) {
    try {
      final decoded = json.decode(body) as Map<String, dynamic>;
      return decoded['error']?.toString() ?? fallback;
    } catch (_) {
      return fallback;
    }
  }
}
