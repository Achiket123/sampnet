import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/research_document_entity.dart';
import '../../../domain/entities/research_folder_entity.dart';
import '../../../domain/use_cases/create_research_document_usecase.dart';
import '../../../domain/use_cases/create_research_folder_usecase.dart';
import '../../../domain/use_cases/delete_research_document_usecase.dart';
import '../../../domain/use_cases/delete_research_folder_usecase.dart';
import '../../../domain/use_cases/get_research_workspace_usecase.dart';

part 'research_workspace_event.dart';
part 'research_workspace_state.dart';

class ResearchWorkspaceBloc
    extends Bloc<ResearchWorkspaceEvent, ResearchWorkspaceState> {
  final GetResearchWorkspaceUsecase getResearchWorkspaceUsecase;
  final CreateResearchFolderUsecase createResearchFolderUsecase;
  final CreateResearchDocumentUsecase createResearchDocumentUsecase;
  final DeleteResearchFolderUsecase deleteResearchFolderUsecase;
  final DeleteResearchDocumentUsecase deleteResearchDocumentUsecase;

  ResearchWorkspaceBloc({
    required this.getResearchWorkspaceUsecase,
    required this.createResearchFolderUsecase,
    required this.createResearchDocumentUsecase,
    required this.deleteResearchFolderUsecase,
    required this.deleteResearchDocumentUsecase,
  }) : super(const ResearchWorkspaceState()) {
    on<LoadWorkspace>(_onLoadWorkspace);
    on<CreateWorkspaceFolder>(_onCreateWorkspaceFolder);
    on<CreateWorkspaceDocument>(_onCreateWorkspaceDocument);
    on<DeleteWorkspaceFolder>(_onDeleteWorkspaceFolder);
    on<DeleteWorkspaceDocument>(_onDeleteWorkspaceDocument);
  }

  Future<void> _onLoadWorkspace(
      LoadWorkspace event, Emitter<ResearchWorkspaceState> emit) async {
    emit(state.copyWith(
        isLoading: true,
        errorMessage: null,
        currentFolderId: event.parentFolderId));
    final result = await getResearchWorkspaceUsecase(
      researchId: event.researchId,
      parentFolderId: event.parentFolderId,
    );
    result.fold(
      (error) =>
          emit(state.copyWith(isLoading: false, errorMessage: error.message)),
      (data) => emit(
        state.copyWith(
          isLoading: false,
          folders: data.folders,
          documents: data.documents,
          researchId: event.researchId,
          currentFolderId: event.parentFolderId,
          errorMessage: null,
        ),
      ),
    );
  }

  Future<void> _onCreateWorkspaceFolder(
      CreateWorkspaceFolder event, Emitter<ResearchWorkspaceState> emit) async {
    final result = await createResearchFolderUsecase(
      researchId: event.researchId,
      name: event.name,
      parentFolderId: event.parentFolderId,
    );
    result.fold(
      (error) => emit(state.copyWith(errorMessage: error.message)),
      (_) => add(LoadWorkspace(
          researchId: event.researchId, parentFolderId: event.parentFolderId)),
    );
  }

  Future<void> _onCreateWorkspaceDocument(CreateWorkspaceDocument event,
      Emitter<ResearchWorkspaceState> emit) async {
    final result = await createResearchDocumentUsecase(
      researchId: event.researchId,
      title: event.title,
      content: event.content,
      folderId: event.folderId,
    );
    result.fold(
      (error) => emit(state.copyWith(errorMessage: error.message)),
      (document) =>
          emit(state.copyWith(createdDocument: document, errorMessage: null)),
    );
  }

  Future<void> _onDeleteWorkspaceFolder(
      DeleteWorkspaceFolder event, Emitter<ResearchWorkspaceState> emit) async {
    final result = await deleteResearchFolderUsecase(event.folderId);
    result.fold(
      (error) => emit(state.copyWith(errorMessage: error.message)),
      (_) => add(LoadWorkspace(
          researchId: event.researchId, parentFolderId: event.parentFolderId)),
    );
  }

  Future<void> _onDeleteWorkspaceDocument(DeleteWorkspaceDocument event,
      Emitter<ResearchWorkspaceState> emit) async {
    final result = await deleteResearchDocumentUsecase(event.documentId);
    result.fold(
      (error) => emit(state.copyWith(errorMessage: error.message)),
      (_) => add(LoadWorkspace(
          researchId: event.researchId, parentFolderId: event.parentFolderId)),
    );
  }
}
