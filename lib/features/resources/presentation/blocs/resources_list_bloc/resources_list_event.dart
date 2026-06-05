import 'package:equatable/equatable.dart';
import 'package:hackathon/features/resources/domain/entities/resource_file_entity.dart';

abstract class ResourcesListEvent extends Equatable {
  const ResourcesListEvent();

  @override
  List<Object?> get props => [];
}

class FetchCollectionsEvent extends ResourcesListEvent {
  final String token;
  const FetchCollectionsEvent({required this.token});

  @override
  List<Object?> get props => [token];
}

class SelectCollectionEvent extends ResourcesListEvent {
  final ResourceCollection collection;
  final String token;
  const SelectCollectionEvent({required this.collection, required this.token});

  @override
  List<Object?> get props => [collection, token];
}

class CreateCollectionEvent extends ResourcesListEvent {
  final String name;
  final String description;
  final List<CollectionField> fields;
  final String token;

  const CreateCollectionEvent({
    required this.name,
    required this.description,
    required this.fields,
    required this.token,
  });

  @override
  List<Object?> get props => [name, description, fields, token];
}

class UpdateCollectionEvent extends ResourcesListEvent {
  final int id;
  final String name;
  final String description;
  final String token;

  const UpdateCollectionEvent({
    required this.id,
    required this.name,
    required this.description,
    required this.token,
  });

  @override
  List<Object?> get props => [id, name, description, token];
}

class DeleteCollectionEvent extends ResourcesListEvent {
  final int id;
  final String token;
  const DeleteCollectionEvent({required this.id, required this.token});

  @override
  List<Object?> get props => [id, token];
}

class CreateRecordEvent extends ResourcesListEvent {
  final int collectionId;
  final Map<String, dynamic> data;
  final String token;

  const CreateRecordEvent({
    required this.collectionId,
    required this.data,
    required this.token,
  });

  @override
  List<Object?> get props => [collectionId, data, token];
}

class UpdateRecordEvent extends ResourcesListEvent {
  final int collectionId;
  final int recordId;
  final Map<String, dynamic> data;
  final String token;

  const UpdateRecordEvent({
    required this.collectionId,
    required this.recordId,
    required this.data,
    required this.token,
  });

  @override
  List<Object?> get props => [collectionId, recordId, data, token];
}

class DeleteRecordEvent extends ResourcesListEvent {
  final int collectionId;
  final int recordId;
  final String token;

  const DeleteRecordEvent({
    required this.collectionId,
    required this.recordId,
    required this.token,
  });

  @override
  List<Object?> get props => [collectionId, recordId, token];
}