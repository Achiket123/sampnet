import 'dart:convert';
import '../../../../services/api_client.dart';
import '../models/research_entry_model.dart';

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
}
