import 'package:equatable/equatable.dart';

class CollectionField extends Equatable {
  final String key;
  final String label;
  final String type; // text, number, boolean, select, multi-select
  final bool required;
  final List<String> options;

  const CollectionField({
    required this.key,
    required this.label,
    required this.type,
    required this.required,
    required this.options,
  });

  factory CollectionField.fromJson(Map<String, dynamic> json) {
    return CollectionField(
      key: json['key'] as String? ?? '',
      label: json['label'] as String? ?? '',
      type: json['type'] as String? ?? 'text',
      required: json['required'] as bool? ?? false,
      options: (json['options'] as List?)?.map((e) => e.toString()).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'label': label,
      'type': type,
      'required': required,
      'options': options,
    };
  }

  @override
  List<Object?> get props => [key, label, type, required, options];
}

class ResourceCollection extends Equatable {
  final int id;
  final String name;
  final String description;
  final List<CollectionField> fields;
  final int organisationId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ResourceCollection({
    required this.id,
    required this.name,
    required this.description,
    required this.fields,
    required this.organisationId,
    this.createdAt,
    this.updatedAt,
  });

  factory ResourceCollection.fromJson(Map<String, dynamic> json) {
    return ResourceCollection(
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'fields': fields.map((e) => e.toJson()).toList(),
      'organisation_id': organisationId,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [id, name, description, fields, organisationId, createdAt, updatedAt];
}

class ResourceRecord extends Equatable {
  final int id;
  final int collectionId;
  final Map<String, dynamic> data;
  final int organisationId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ResourceRecord({
    required this.id,
    required this.collectionId,
    required this.data,
    required this.organisationId,
    this.createdAt,
    this.updatedAt,
  });

  factory ResourceRecord.fromJson(Map<String, dynamic> json) {
    return ResourceRecord(
      id: json['id'] as int? ?? 0,
      collectionId: json['collection_id'] as int? ?? 0,
      data: Map<String, dynamic>.from(json['data'] as Map? ?? {}),
      organisationId: json['organisation_id'] as int? ?? 0,
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'].toString()) : null,
      updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at'].toString()) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'collection_id': collectionId,
      'data': data,
      'organisation_id': organisationId,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [id, collectionId, data, organisationId, createdAt, updatedAt];
}