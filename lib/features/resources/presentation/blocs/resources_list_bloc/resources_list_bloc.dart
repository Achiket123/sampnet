import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hackathon/features/resources/domain/use_cases/delete_file_usecase.dart';
import 'package:hackathon/features/resources/domain/use_cases/get_file_detail_usecase.dart';
import 'package:hackathon/features/resources/domain/use_cases/get_files_usecase.dart';
import 'package:hackathon/features/resources/domain/use_cases/update_file_access_usecase.dart';
import 'package:hackathon/features/resources/domain/use_cases/upload_file_usecase.dart';
import 'package:hackathon/features/resources/presentation/blocs/resources_list_bloc/resources_list_event.dart';
import 'package:hackathon/features/resources/presentation/blocs/resources_list_bloc/resources_list_state.dart';

class ResourcesListBloc extends Bloc<ResourcesListEvent, ResourcesListState> {
  final GetFilesUsecase getFilesUsecase;
  final GetFileDetailUsecase getFileDetailUsecase;
  final CreateCollectionUsecase uploadFileUsecase;
  final UpdateFileAccessUsecase updateFileAccessUsecase;
  final DeleteFileUsecase deleteFileUsecase;

  ResourcesListBloc({
    required this.getFilesUsecase,
    required this.getFileDetailUsecase,
    required this.uploadFileUsecase,
    required this.updateFileAccessUsecase,
    required this.deleteFileUsecase,
  }) : super(ResourcesListInitial()) {
    on<FetchCollectionsEvent>(_onFetchCollections);
    on<SelectCollectionEvent>(_onSelectCollection);
    on<CreateCollectionEvent>(_onCreateCollection);
    on<UpdateCollectionEvent>(_onUpdateCollection);
    on<DeleteCollectionEvent>(_onDeleteCollection);
    on<CreateRecordEvent>(_onCreateRecord);
    on<UpdateRecordEvent>(_onUpdateRecord);
    on<DeleteRecordEvent>(_onDeleteRecord);
  }

  Future<void> _onFetchCollections(FetchCollectionsEvent event, Emitter<ResourcesListState> emit) async {
    emit(ResourcesListLoading());
    final result = await getFilesUsecase(token: event.token);
    result.fold(
      (failure) => emit(ResourcesListError(failure.message)),
      (collections) => emit(CollectionsLoaded(collections)),
    );
  }

  Future<void> _onSelectCollection(SelectCollectionEvent event, Emitter<ResourcesListState> emit) async {
    emit(ResourcesListLoading());
    final result = await getFileDetailUsecase(collectionId: event.collection.id, token: event.token);
    result.fold(
      (failure) => emit(ResourcesListError(failure.message)),
      (records) => emit(CollectionRecordsLoaded(collection: event.collection, records: records)),
    );
  }

  Future<void> _onCreateCollection(CreateCollectionEvent event, Emitter<ResourcesListState> emit) async {
    emit(ResourcesListLoading());
    final result = await uploadFileUsecase(
      name: event.name,
      description: event.description,
      fields: event.fields,
      token: event.token,
    );
    result.fold(
      (failure) => emit(ResourcesListError(failure.message)),
      (collection) => emit(const ResourcesActionSuccess("Collection created successfully")),
    );
  }

  Future<void> _onUpdateCollection(UpdateCollectionEvent event, Emitter<ResourcesListState> emit) async {
    emit(ResourcesListLoading());
    final result = await updateFileAccessUsecase.updateCollection(
      id: event.id,
      name: event.name,
      description: event.description,
      token: event.token,
    );
    result.fold(
      (failure) => emit(ResourcesListError(failure.message)),
      (collection) => emit(const ResourcesActionSuccess("Collection updated successfully")),
    );
  }

  Future<void> _onDeleteCollection(DeleteCollectionEvent event, Emitter<ResourcesListState> emit) async {
    emit(ResourcesListLoading());
    final result = await deleteFileUsecase.deleteCollection(
      id: event.id,
      token: event.token,
    );
    result.fold(
      (failure) => emit(ResourcesListError(failure.message)),
      (_) => emit(const ResourcesActionSuccess("Collection deleted successfully")),
    );
  }

  Future<void> _onCreateRecord(CreateRecordEvent event, Emitter<ResourcesListState> emit) async {
    emit(ResourcesListLoading());
    final result = await updateFileAccessUsecase.createRecord(
      collectionId: event.collectionId,
      data: event.data,
      token: event.token,
    );
    result.fold(
      (failure) => emit(ResourcesListError(failure.message)),
      (record) => emit(const ResourcesActionSuccess("Record created successfully")),
    );
  }

  Future<void> _onUpdateRecord(UpdateRecordEvent event, Emitter<ResourcesListState> emit) async {
    emit(ResourcesListLoading());
    final result = await updateFileAccessUsecase.updateRecord(
      collectionId: event.collectionId,
      recordId: event.recordId,
      data: event.data,
      token: event.token,
    );
    result.fold(
      (failure) => emit(ResourcesListError(failure.message)),
      (record) => emit(const ResourcesActionSuccess("Record updated successfully")),
    );
  }

  Future<void> _onDeleteRecord(DeleteRecordEvent event, Emitter<ResourcesListState> emit) async {
    emit(ResourcesListLoading());
    final result = await deleteFileUsecase.deleteRecord(
      collectionId: event.collectionId,
      recordId: event.recordId,
      token: event.token,
    );
    result.fold(
      (failure) => emit(ResourcesListError(failure.message)),
      (_) => emit(const ResourcesActionSuccess("Record deleted successfully")),
    );
  }
}
