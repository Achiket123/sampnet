import 'package:hackathon/features/resources/domain/entities/resource_file_entity.dart';

class ResourceCollectionModel extends ResourceCollection {
  const ResourceCollectionModel({
    required super.id,
    required super.name,
    required super.description,
    required super.fields,
    required super.organisationId,
    super.createdAt,
    super.updatedAt,
  });

  factory ResourceCollectionModel.fromJson(Map<String, dynamic> json) {
    return ResourceCollectionModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      fields: (json['fields'] as List?)
              ?.map((e) => CollectionField.fromJson(Map<String, dynamic>.from(e)))
              .toList() ??
          [],
      organisationId: json['organisation_id'] as int? ?? 0,
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'].toString()) : null,
      updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at'].toString()) : null,
    );
  }
}

class ResourceRecordModel extends ResourceRecord {
  const ResourceRecordModel({
    required super.id,
    required super.collectionId,
    required super.data,
    required super.organisationId,
    super.createdAt,
    super.updatedAt,
  });

  factory ResourceRecordModel.fromJson(Map<String, dynamic> json) {
    return ResourceRecordModel(
      id: json['id'] as int? ?? 0,
      collectionId: json['collection_id'] as int? ?? 0,
      data: Map<String, dynamic>.from(json['data'] as Map? ?? {}),
      organisationId: json['organisation_id'] as int? ?? 0,
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'].toString()) : null,
      updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at'].toString()) : null,
    );
  }
}