import 'dart:convert';
import 'package:hackathon/features/resources/data/models/resource_file_model.dart';
import 'package:hackathon/services/api_client.dart';
import 'package:flutter/foundation.dart';
import 'package:hackathon/globals/constants/api_end_points.dart';
abstract class ResourcesRemoteDataSource {
  Future<ResourceCollectionModel> createCollection({
    required String name,
    required String description,
    required List<Map<String, dynamic>> fields,
  });

  Future<ResourceCollectionModel> getCollection({required int id});

  Future<List<ResourceCollectionModel>> listCollections();

  Future<ResourceCollectionModel> updateCollection({
    required int id,
    required String name,
    required String description,
  });

  Future<void> deleteCollection({required int id});

  Future<ResourceCollectionModel> addField({
    required int collectionId,
    required Map<String, dynamic> field,
  });

  Future<ResourceCollectionModel> updateField({
    required int collectionId,
    required String key,
    required Map<String, dynamic> field,
  });

  Future<ResourceCollectionModel> removeField({
    required int collectionId,
    required String key,
  });

  Future<ResourceRecordModel> createRecord({
    required int collectionId,
    required Map<String, dynamic> data,
  });

  Future<ResourceRecordModel> getRecord({
    required int collectionId,
    required int recordId,
  });

  Future<List<ResourceRecordModel>> listRecords({required int collectionId});

  Future<ResourceRecordModel> updateRecord({
    required int collectionId,
    required int recordId,
    required Map<String, dynamic> data,
  });

  Future<void> deleteRecord({
    required int collectionId,
    required int recordId,
  });

  Future<List<ResourceRecordModel>> bulkCreate({
    required int collectionId,
    required List<Map<String, dynamic>> records,
  });
}

class ResourcesRemoteDataSourceImpl implements ResourcesRemoteDataSource {
  final ApiClient apiClient;

  ResourcesRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<ResourceCollectionModel> createCollection({
    required String name,
    required String description,
    required List<Map<String, dynamic>> fields,
  }) async {
    final response = await apiClient.post(
      '${ApiConstants.baseUrl}/resources/collections',
      body: {
        'name': name,
        'description': description,
        'fields': fields,
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return ResourceCollectionModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create collection: ${response.body}');
    }
  }

  @override
  Future<ResourceCollectionModel> getCollection({required int id}) async {
    final response = await apiClient.get('${ApiConstants.baseUrl}/resources/collections/$id');

    if (response.statusCode == 200) {
      return ResourceCollectionModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to get collection: ${response.body}');
    }
  }

  @override
  Future<List<ResourceCollectionModel>> listCollections() async {
    final response = await apiClient.get('${ApiConstants.baseUrl}/resources/collections');

    if (response.statusCode == 200) {
      debugPrint(response.body);
      final List<dynamic> list = json.decode(response.body)["collections"];
      return list
          .map((json) => ResourceCollectionModel.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to list collections: ${response.body}');
    }
  }

  @override
  Future<ResourceCollectionModel> updateCollection({
    required int id,
    required String name,
    required String description,
  }) async {
    final response = await apiClient.put(
      '${ApiConstants.baseUrl}/resources/collections/$id',
      body: {
        'name': name,
        'description': description,
      },
    );

    if (response.statusCode == 200) {
      return ResourceCollectionModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update collection: ${response.body}');
    }
  }

  @override
  Future<void> deleteCollection({required int id}) async {
    final response = await apiClient.delete('${ApiConstants.baseUrl}/resources/collections/$id');

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete collection: ${response.body}');
    }
  }

  @override
  Future<ResourceCollectionModel> addField({
    required int collectionId,
    required Map<String, dynamic> field,
  }) async {
    final response = await apiClient.post(
      '${ApiConstants.baseUrl}/resources/collections/$collectionId/fields',
      body: field,
    );

    if (response.statusCode == 200) {
      return ResourceCollectionModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to add field: ${response.body}');
    }
  }

  @override
  Future<ResourceCollectionModel> updateField({
    required int collectionId,
    required String key,
    required Map<String, dynamic> field,
  }) async {
    final response = await apiClient.put(
      '${ApiConstants.baseUrl}/resources/collections/$collectionId/fields/$key',
      body: field,
    );

    if (response.statusCode == 200) {
      return ResourceCollectionModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update field: ${response.body}');
    }
  }

  @override
  Future<ResourceCollectionModel> removeField({
    required int collectionId,
    required String key,
  }) async {
    final response = await apiClient.delete(
      '${ApiConstants.baseUrl}/resources/collections/$collectionId/fields/$key',
    );

    if (response.statusCode == 200) {
      return ResourceCollectionModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to remove field: ${response.body}');
    }
  }

  @override
  Future<ResourceRecordModel> createRecord({
    required int collectionId,
    required Map<String, dynamic> data,
  }) async {
    final response = await apiClient.post(
      '${ApiConstants.baseUrl}/resources/collections/$collectionId/records',
      body: {
        'data': data,
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return ResourceRecordModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create record: ${response.body}');
    }
  }

  @override
  Future<ResourceRecordModel> getRecord({
    required int collectionId,
    required int recordId,
  }) async {
    final response = await apiClient.get(
      '${ApiConstants.baseUrl}/resources/collections/$collectionId/records/$recordId',
    );

    if (response.statusCode == 200) {
      return ResourceRecordModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to get record: ${response.body}');
    }
  }

  @override
  Future<List<ResourceRecordModel>> listRecords(
      {required int collectionId}) async {
    final response = await apiClient.get(
      '${ApiConstants.baseUrl}/resources/collections/$collectionId/records',
    );

    if (response.statusCode == 200) {
      final List<dynamic> list = json.decode(response.body)["records"];
      return list.map((json) => ResourceRecordModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to list records: ${response.body}');
    }
  }

  @override
  Future<ResourceRecordModel> updateRecord({
    required int collectionId,
    required int recordId,
    required Map<String, dynamic> data,
  }) async {
    final response = await apiClient.put(
      '${ApiConstants.baseUrl}/resources/collections/$collectionId/records/$recordId',
      body: {
        'data': data,
      },
    );

    if (response.statusCode == 200) {
      return ResourceRecordModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update record: ${response.body}');
    }
  }

  @override
  Future<void> deleteRecord({
    required int collectionId,
    required int recordId,
  }) async {
    final response = await apiClient.delete(
      '${ApiConstants.baseUrl}/resources/collections/$collectionId/records/$recordId',
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete record: ${response.body}');
    }
  }

  @override
  Future<List<ResourceRecordModel>> bulkCreate({
    required int collectionId,
    required List<Map<String, dynamic>> records,
  }) async {
    final response = await apiClient.post(
      '${ApiConstants.baseUrl}/resources/collections/$collectionId/bulk',
      body: {
        'records': records,
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final List<dynamic> list = json.decode(response.body);
      return list.map((json) => ResourceRecordModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to bulk create records: ${response.body}');
    }
  }
}
