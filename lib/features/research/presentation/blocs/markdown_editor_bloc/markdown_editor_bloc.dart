import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/research_document_entity.dart';
import '../../../domain/entities/research_file_entity.dart';
import '../../../domain/entities/research_reference_entity.dart';
import '../../../domain/use_cases/create_research_document_usecase.dart';
import '../../../domain/use_cases/get_research_document_usecase.dart';
import '../../../domain/use_cases/update_research_document_usecase.dart';
import '../../../domain/use_cases/research_file_usecases.dart';
import '../../../domain/use_cases/research_reference_usecases.dart';

part 'markdown_editor_event.dart';
part 'markdown_editor_state.dart';

class MarkdownEditorBloc
    extends Bloc<MarkdownEditorEvent, MarkdownEditorState> {
  final GetResearchDocumentUsecase getResearchDocumentUsecase;
  final CreateResearchDocumentUsecase createResearchDocumentUsecase;
  final UpdateResearchDocumentUsecase updateResearchDocumentUsecase;
  final GetResearchFilesUsecase getResearchFilesUsecase;
  final UploadResearchFileUsecase uploadResearchFileUsecase;
  final GetResearchReferencesUsecase getResearchReferencesUsecase;
  final AddResearchReferenceUsecase addResearchReferenceUsecase;

  Timer? _autosaveTimer;

  MarkdownEditorBloc({
    required this.getResearchDocumentUsecase,
    required this.createResearchDocumentUsecase,
    required this.updateResearchDocumentUsecase,
    required this.getResearchFilesUsecase,
    required this.uploadResearchFileUsecase,
    required this.getResearchReferencesUsecase,
    required this.addResearchReferenceUsecase,
  }) : super(const MarkdownEditorState()) {
    on<LoadMarkdownDocument>(_onLoadMarkdownDocument);
    on<SaveMarkdownDocument>(_onSaveMarkdownDocument);
    on<AutosaveMarkdownDocument>(_onAutosaveMarkdownDocument);
    on<LoadDocumentArtifacts>(_onLoadDocumentArtifacts);
    on<UploadEditorFile>(_onUploadEditorFile);
    on<AddEditorReference>(_onAddEditorReference);
  }

  Future<void> _onLoadMarkdownDocument(
      LoadMarkdownDocument event, Emitter<MarkdownEditorState> emit) async {
    if (event.documentId == 0) {
      emit(
        state.copyWith(
          isLoading: false,
          documentId: 0,
          title: event.initialTitle ?? 'Untitled Document',
          content: event.initialContent ?? '',
          researchId: event.researchId,
          folderId: event.folderId,
          files: [],
          references: [],
          errorMessage: null,
        ),
      );
      return;
    }

    emit(state.copyWith(isLoading: true, errorMessage: null));
    final result = await getResearchDocumentUsecase(event.documentId);
    result.fold(
      (error) =>
          emit(state.copyWith(isLoading: false, errorMessage: error.message)),
      (document) {
        emit(
          state.copyWith(
            isLoading: false,
            documentId: document.id,
            title: document.title,
            content: document.content,
            researchId: document.researchId,
            folderId: document.folderId,
            errorMessage: null,
          ),
        );
        add(LoadDocumentArtifacts(documentId: document.id));
      },
    );
  }

  Future<void> _onLoadDocumentArtifacts(
      LoadDocumentArtifacts event, Emitter<MarkdownEditorState> emit) async {
    final filesRes = await getResearchFilesUsecase(event.documentId);
    final refsRes = await getResearchReferencesUsecase(event.documentId);

    filesRes.fold(
      (error) => emit(state.copyWith(errorMessage: error.message)),
      (files) => emit(state.copyWith(files: files)),
    );

    refsRes.fold(
      (error) => emit(state.copyWith(errorMessage: error.message)),
      (refs) => emit(state.copyWith(references: refs)),
    );
  }

  Future<void> _onUploadEditorFile(
      UploadEditorFile event, Emitter<MarkdownEditorState> emit) async {
    int docId = event.documentId ?? state.documentId;
    if (docId == 0) {
      emit(state.copyWith(
          errorMessage: 'Please save document before uploading files'));
      return;
    }

    emit(state.copyWith(isSaving: true));
    final result = await uploadResearchFileUsecase(
      researchId: event.researchId,
      documentId: docId,
      fileName: event.fileName,
      bytes: event.bytes,
      mimeType: event.mimeType,
    );

    result.fold(
      (error) =>
          emit(state.copyWith(isSaving: false, errorMessage: error.message)),
      (_) {
        emit(state.copyWith(isSaving: false));
        add(LoadDocumentArtifacts(documentId: docId));
      },
    );
  }

  Future<void> _onAddEditorReference(
      AddEditorReference event, Emitter<MarkdownEditorState> emit) async {
    int docId = event.documentId ?? state.documentId;
    if (docId == 0) {
      emit(state.copyWith(
          errorMessage: 'Please save document before adding links'));
      return;
    }

    emit(state.copyWith(isSaving: true));
    final result = await addResearchReferenceUsecase(
      researchId: event.researchId,
      documentId: docId,
      title: event.title,
      url: event.url,
      authors: event.authors,
    );

    result.fold(
      (error) =>
          emit(state.copyWith(isSaving: false, errorMessage: error.message)),
      (_) {
        emit(state.copyWith(isSaving: false));
        add(LoadDocumentArtifacts(documentId: docId));
      },
    );
  }

  Future<void> _onSaveMarkdownDocument(
      SaveMarkdownDocument event, Emitter<MarkdownEditorState> emit) async {
    emit(state.copyWith(isSaving: true, errorMessage: null));
    if (event.documentId == 0) {
      final response = await createResearchDocumentUsecase(
        researchId: event.researchId,
        title: event.title,
        content: event.content,
        folderId: event.folderId,
      );
      response.fold(
        (error) =>
            emit(state.copyWith(isSaving: false, errorMessage: error.message)),
        (created) => emit(
          state.copyWith(
            isSaving: false,
            documentId: created.id,
            title: event.title,
            content: event.content,
            saveMessage: 'Saved',
            savedDocument: created,
            errorMessage: null,
          ),
        ),
      );
      return;
    }

    final response = await updateResearchDocumentUsecase(
      documentId: event.documentId,
      title: event.title,
      content: event.content,
      folderId: event.folderId,
    );
    response.fold(
      (error) =>
          emit(state.copyWith(isSaving: false, errorMessage: error.message)),
      (_) => emit(
        state.copyWith(
          isSaving: false,
          documentId: event.documentId,
          title: event.title,
          content: event.content,
          saveMessage: 'Saved',
          errorMessage: null,
        ),
      ),
    );
  }

  Future<void> _onAutosaveMarkdownDocument(
      AutosaveMarkdownDocument event, Emitter<MarkdownEditorState> emit) async {
    _autosaveTimer?.cancel();
    _autosaveTimer = Timer(const Duration(milliseconds: 900), () {
      add(
        SaveMarkdownDocument(
          documentId: event.documentId,
          researchId: event.researchId,
          folderId: event.folderId,
          title: event.title,
          content: event.content,
        ),
      );
    });
  }

  @override
  Future<void> close() {
    _autosaveTimer?.cancel();
    return super.close();
  }
}
