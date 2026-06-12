import 'dart:convert';
import 'package:flutter/material.dart';

import '../../../../services/api_client.dart';
import '../models/research_entry_model.dart';
import '../models/research_folder_model.dart';
import '../models/research_document_model.dart';
import '../models/research_file_model.dart';
import '../models/research_reference_model.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:hackathon/globals/constants/api_end_points.dart';

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

  // ─── Entry ───────────────────────────────────────────────────────────────────

  @override
  Future<ResearchEntryModel> createEntry(ResearchEntryModel entry) async {
    final response = await apiClient.post('${ApiConstants.baseUrl}/research',
        body: entry.toJson());
    if (response.statusCode == 201) {
      return ResearchEntryModel.fromJson(_decode(response.body)['data']);
    }
    throw Exception(_extractError(response.body,
        fallback: 'Failed to create research entry'));
  }

  @override
  Future<ResearchEntryModel> getEntry(int id) async {
    final response =
        await apiClient.get('${ApiConstants.baseUrl}/research/$id');
    if (response.statusCode == 200) {
      return ResearchEntryModel.fromJson(_decode(response.body)['data']);
    }
    throw Exception(
        _extractError(response.body, fallback: 'Failed to get research entry'));
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
    final params = {
      'limit': '$limit',
      'offset': '$offset',
      if (status != null) 'status': status,
      if (projectId != null) 'project_id': '$projectId',
      if (teamId != null) 'team_id': '$teamId',
      if (query != null) 'q': query,
    };
    final endpoint =
        Uri(path: '${ApiConstants.baseUrl}/research', queryParameters: params)
            .path;
    debugPrint("endpoint: $endpoint");
    final response =
        await apiClient.get('${ApiConstants.baseUrl}/research?$endpoint');
    if (response.statusCode == 200) {
      return _decode(response.body);
    }
    throw Exception(_extractError(response.body,
        fallback: 'Failed to get research entries'));
  }

  @override
  Future<void> updateEntry(ResearchEntryModel entry) async {
    final response = await apiClient.put(
        '${ApiConstants.baseUrl}/research/${entry.id}',
        body: entry.toJson());
    if (response.statusCode != 200) {
      throw Exception(_extractError(response.body,
          fallback: 'Failed to update research entry'));
    }
  }

  @override
  Future<void> deleteEntry(int id) async {
    final response =
        await apiClient.delete('${ApiConstants.baseUrl}/research/$id');
    if (response.statusCode != 200) {
      throw Exception(_extractError(response.body,
          fallback: 'Failed to delete research entry'));
    }
  }

  // ─── Folders ─────────────────────────────────────────────────────────────────

  @override
  Future<List<ResearchFolderModel>> getFolders({
    required int researchId,
    int? parentFolderId,
  }) async {
    final params = {
      'research_id': '$researchId',
      if (parentFolderId != null) 'parent_id': '$parentFolderId',
    };
    final endpoint = Uri(
            path: '${ApiConstants.baseUrl}/research/folders',
            queryParameters: params)
        .toString();
    final response = await apiClient.get(endpoint);
    if (response.statusCode != 200) {
      throw Exception(
          _extractError(response.body, fallback: 'Failed to get folders'));
    }
    final data = _decode(response.body);
    return _mapList(data['data'], ResearchFolderModel.fromJson);
  }

  @override
  Future<ResearchFolderModel> createFolder({
    required int researchId,
    required String name,
    int? parentFolderId,
  }) async {
    final response = await apiClient.post(
      '${ApiConstants.baseUrl}/research/folders',
      body: {
        'research_id': researchId,
        'name': name,
        if (parentFolderId != null) 'parent_id': parentFolderId,
      },
    );
    if (response.statusCode != 201) {
      throw Exception(
          _extractError(response.body, fallback: 'Failed to create folder'));
    }
    return ResearchFolderModel.fromJson(_decode(response.body)['data']);
  }

  @override
  Future<void> updateFolder({
    required int folderId,
    required String name,
    int? parentFolderId,
  }) async {
    final response = await apiClient.put(
      '${ApiConstants.baseUrl}/research/folders/$folderId',
      body: {
        'name': name,
        if (parentFolderId != null) 'parent_id': parentFolderId,
      },
    );
    if (response.statusCode != 200) {
      throw Exception(
          _extractError(response.body, fallback: 'Failed to update folder'));
    }
  }

  @override
  Future<void> deleteFolder(int folderId) async {
    final response = await apiClient
        .delete('${ApiConstants.baseUrl}/research/folders/$folderId');
    if (response.statusCode != 200) {
      throw Exception(
          _extractError(response.body, fallback: 'Failed to delete folder'));
    }
  }

  // ─── Documents ───────────────────────────────────────────────────────────────

  @override
  Future<List<ResearchDocumentModel>> getDocuments({
    required int researchId,
    int? folderId,
  }) async {
    final params = {
      'research_id': '$researchId',
      if (folderId != null) 'folder_id': '$folderId',
    };
    final endpoint = Uri(
            path: '${ApiConstants.baseUrl}/research/documents',
            queryParameters: params)
        .toString();
    final response = await apiClient.get(endpoint);
    if (response.statusCode != 200) {
      throw Exception(
          _extractError(response.body, fallback: 'Failed to get documents'));
    }
    final data = _decode(response.body);
    return _mapList(data['data'], ResearchDocumentModel.fromJson);
  }

  @override
  Future<ResearchDocumentModel> getDocument(int id) async {
    final response =
        await apiClient.get('${ApiConstants.baseUrl}/research/documents/$id');
    if (response.statusCode != 200) {
      throw Exception(
          _extractError(response.body, fallback: 'Failed to get document'));
    }
    return ResearchDocumentModel.fromJson(_decode(response.body)['data']);
  }

  @override
  Future<ResearchDocumentModel> createDocument({
    required int researchId,
    required String title,
    required String content,
    int? folderId,
  }) async {
    final response = await apiClient.post(
      '${ApiConstants.baseUrl}/research/documents',
      body: {
        'research_id': researchId,
        'title': title,
        'content': content,
        if (folderId != null) 'folder_id': folderId,
      },
    );
    if (response.statusCode != 201) {
      throw Exception(
          _extractError(response.body, fallback: 'Failed to create document'));
    }
    return ResearchDocumentModel.fromJson(_decode(response.body)['data']);
  }

  @override
  Future<void> updateDocument({
    required int documentId,
    required String title,
    required String content,
    int? folderId,
  }) async {
    final response = await apiClient.put(
      '${ApiConstants.baseUrl}/research/documents/$documentId',
      body: {
        'title': title,
        'content': content,
        if (folderId != null) 'folder_id': folderId,
      },
    );
    if (response.statusCode != 200) {
      throw Exception(
          _extractError(response.body, fallback: 'Failed to update document'));
    }
  }

  @override
  Future<void> deleteDocument(int documentId) async {
    final response = await apiClient
        .delete('${ApiConstants.baseUrl}/research/documents/$documentId');
    if (response.statusCode != 200) {
      throw Exception(
          _extractError(response.body, fallback: 'Failed to delete document'));
    }
  }

  // ─── Files ───────────────────────────────────────────────────────────────────

  @override
  Future<List<ResearchFileModel>> getFilesByDocument(int documentId) async {
    final response = await apiClient
        .get('${ApiConstants.baseUrl}/research/files?document_id=$documentId');
    if (response.statusCode != 200) {
      throw Exception(_extractError(response.body,
          fallback: 'Failed to get document files'));
    }
    final data = _decode(response.body);
    return _mapList(data['data'], ResearchFileModel.fromJson);
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

    // Attach auth headers
    request.headers.addAll(apiClient.authHeaders());

    request.fields['research_id'] = researchId.toString();
    if (documentId != null)
      request.fields['document_id'] = documentId.toString();
    if (folderId != null) request.fields['folder_id'] = folderId.toString();

    request.files.add(http.MultipartFile.fromBytes(
      'file',
      bytes,
      filename: fileName,
      contentType: MediaType.parse(mimeType),
    ));

    final streamed = await apiClient.sendMultipart(request);

    // Read the stream ONCE
    final responseBody = await streamed.stream.bytesToString();

    if (streamed.statusCode != 201) {
      throw Exception(
          _extractError(responseBody, fallback: 'Failed to upload file'));
    }
    return ResearchFileModel.fromJson(_decode(responseBody)['data']);
  }

  @override
  Future<void> deleteFile(int fileId) async {
    final response = await apiClient
        .delete('${ApiConstants.baseUrl}/research/files/$fileId');
    if (response.statusCode != 200) {
      throw Exception(
          _extractError(response.body, fallback: 'Failed to delete file'));
    }
  }

  // ─── References ──────────────────────────────────────────────────────────────

  @override
  Future<List<ResearchReferenceModel>> getReferencesByDocument(
      int documentId) async {
    final response = await apiClient.get(
        '${ApiConstants.baseUrl}/research/references?document_id=$documentId');
    if (response.statusCode != 200) {
      throw Exception(_extractError(response.body,
          fallback: 'Failed to get document references'));
    }
    final data = _decode(response.body);
    return _mapList(data['data'], ResearchReferenceModel.fromJson);
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
      '${ApiConstants.baseUrl}/research/references',
      body: {
        'research_id': researchId,
        if (documentId != null) 'document_id': documentId,
        'title': title,
        'url': url,
        if (authors != null) 'authors': authors,
      },
    );
    if (response.statusCode != 201) {
      throw Exception(
          _extractError(response.body, fallback: 'Failed to add reference'));
    }
    return ResearchReferenceModel.fromJson(_decode(response.body)['data']);
  }

  @override
  Future<void> deleteReference(int referenceId) async {
    final response = await apiClient
        .delete('${ApiConstants.baseUrl}/research/references/$referenceId');
    if (response.statusCode != 200) {
      throw Exception(
          _extractError(response.body, fallback: 'Failed to delete reference'));
    }
  }

  // ─── Helpers ─────────────────────────────────────────────────────────────────

  Map<String, dynamic> _decode(String body) =>
      json.decode(body) as Map<String, dynamic>;

  List<T> _mapList<T>(
    dynamic list,
    T Function(Map<String, dynamic>) fromJson,
  ) =>
      (list as List<dynamic>? ?? const [])
          .map((item) => fromJson(item as Map<String, dynamic>))
          .toList();

  String _extractError(String body, {required String fallback}) {
    try {
      final decoded = json.decode(body) as Map<String, dynamic>;
      return decoded['error']?.toString() ?? fallback;
    } catch (_) {
      return fallback;
    }
  }
}
