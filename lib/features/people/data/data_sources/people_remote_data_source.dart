import 'dart:convert';
import '../../../../services/api_client.dart';
import '../models/people_models.dart';

abstract class PeopleRemoteDataSource {
  Future<List<PeopleContactModel>> getContacts({int? stageId, int? listId, String? search});
  Future<PeopleContactModel> getContactDetails(int id);
  Future<PeopleContactModel> createContact(PeopleContactModel contact);
  Future<PeopleContactModel> updateContact(PeopleContactModel contact);
  Future<void> deleteContact(int id);

  Future<List<PeopleInteractionModel>> getInteractions(int contactId);
  Future<PeopleInteractionModel> createInteraction(PeopleInteractionModel interaction);

  Future<List<PipelineStageModel>> getPipelineStages();
  Future<PipelineStageModel> createPipelineStage(PipelineStageModel stage);
  Future<PipelineStageModel> updatePipelineStage(PipelineStageModel stage);

  Future<List<PeopleListModel>> getLists();
  Future<PeopleListModel> createList(PeopleListModel list);
}

class PeopleRemoteDataSourceImpl implements PeopleRemoteDataSource {
  final ApiClient apiClient;

  PeopleRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<PeopleContactModel>> getContacts({int? stageId, int? listId, String? search}) async {
    final queryParams = <String, String>{};
    if (stageId != null) queryParams['stage_id'] = stageId.toString();
    if (listId != null) queryParams['list_id'] = listId.toString();
    if (search != null && search.isNotEmpty) queryParams['search'] = search;

    String queryString = '';
    if (queryParams.isNotEmpty) {
      queryString = '?' + queryParams.entries.map((e) => '${e.key}=${Uri.encodeComponent(e.value)}').join('&');
    }

    final response = await apiClient.get('/people/contacts$queryString');
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final List<dynamic> data = jsonDecode(response.body)["contacts"];
      return data.map((json) => PeopleContactModel.fromJson(json)).toList();
    }
    throw Exception('Failed to load contacts');
  }

  @override
  Future<PeopleContactModel> getContactDetails(int id) async {
    final response = await apiClient.get('/people/contacts/$id');
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return PeopleContactModel.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to load contact details');
  }

  @override
  Future<PeopleContactModel> createContact(PeopleContactModel contact) async {
    final response = await apiClient.post('/people/contacts', body: contact.toJson());
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return PeopleContactModel.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to create contact');
  }

  @override
  Future<PeopleContactModel> updateContact(PeopleContactModel contact) async {
    final response = await apiClient.put('/people/contacts/${contact.id}', body: contact.toJson());
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return PeopleContactModel.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to update contact');
  }

  @override
  Future<void> deleteContact(int id) async {
    final response = await apiClient.delete('/people/contacts/$id');
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to delete contact');
    }
  }

  @override
  Future<List<PeopleInteractionModel>> getInteractions(int contactId) async {
    final response = await apiClient.get('/people/contacts/$contactId/interactions');
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => PeopleInteractionModel.fromJson(json)).toList();
    }
    throw Exception('Failed to load interactions');
  }

  @override
  Future<PeopleInteractionModel> createInteraction(PeopleInteractionModel interaction) async {
    final response = await apiClient.post('/people/contacts/${interaction.contactId}/interactions', body: interaction.toJson());
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return PeopleInteractionModel.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to create interaction');
  }

  @override
  Future<List<PipelineStageModel>> getPipelineStages() async {
    final response = await apiClient.get('/people/pipeline/stages');
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => PipelineStageModel.fromJson(json)).toList();
    }
    throw Exception('Failed to load pipeline stages');
  }

  @override
  Future<PipelineStageModel> createPipelineStage(PipelineStageModel stage) async {
    final response = await apiClient.post('/people/pipeline/stages', body: stage.toJson());
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return PipelineStageModel.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to create pipeline stage');
  }

  @override
  Future<PipelineStageModel> updatePipelineStage(PipelineStageModel stage) async {
    final response = await apiClient.put('/people/pipeline/stages/${stage.id}', body: stage.toJson());
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return PipelineStageModel.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to update pipeline stage');
  }

  @override
  Future<List<PeopleListModel>> getLists() async {
    final response = await apiClient.get('/people/lists');
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => PeopleListModel.fromJson(json)).toList();
    }
    throw Exception('Failed to load lists');
  }

  @override
  Future<PeopleListModel> createList(PeopleListModel list) async {
    final response = await apiClient.post('/people/lists', body: list.toJson());
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return PeopleListModel.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to create list');
  }
}