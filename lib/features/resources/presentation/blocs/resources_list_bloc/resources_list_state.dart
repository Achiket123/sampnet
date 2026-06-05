import 'package:equatable/equatable.dart';
import 'package:hackathon/features/resources/domain/entities/resource_file_entity.dart';

abstract class ResourcesListState extends Equatable {
  const ResourcesListState();

  @override
  List<Object?> get props => [];
}

class ResourcesListInitial extends ResourcesListState {}

class ResourcesListLoading extends ResourcesListState {}

class CollectionsLoaded extends ResourcesListState {
  final List<ResourceCollection> collections;
  const CollectionsLoaded(this.collections);

  @override
  List<Object?> get props => [collections];
}

class CollectionRecordsLoaded extends ResourcesListState {
  final ResourceCollection collection;
  final List<ResourceRecord> records;
  const CollectionRecordsLoaded({required this.collection, required this.records});

  @override
  List<Object?> get props => [collection, records];
}

class ResourcesActionSuccess extends ResourcesListState {
  final String message;
  const ResourcesActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class ResourcesListError extends ResourcesListState {
  final String message;
  const ResourcesListError(this.message);

  @override
  List<Object?> get props => [message];
}