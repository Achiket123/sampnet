part of 'markdown_editor_bloc.dart';

class MarkdownEditorState extends Equatable {
  final bool isLoading;
  final bool isSaving;
  final int documentId;
  final int researchId;
  final int? folderId;
  final String title;
  final String content;
  final List<ResearchFileEntity> files;
  final List<ResearchReferenceEntity> references;
  final String? saveMessage;
  final String? errorMessage;
  final ResearchDocumentEntity? savedDocument;

  const MarkdownEditorState({
    this.isLoading = false,
    this.isSaving = false,
    this.documentId = 0,
    this.researchId = 0,
    this.folderId,
    this.title = 'Untitled Document',
    this.content = '',
    this.files = const [],
    this.references = const [],
    this.saveMessage,
    this.errorMessage,
    this.savedDocument,
  });

  MarkdownEditorState copyWith({
    bool? isLoading,
    bool? isSaving,
    int? documentId,
    int? researchId,
    int? folderId,
    String? title,
    String? content,
    List<ResearchFileEntity>? files,
    List<ResearchReferenceEntity>? references,
    String? saveMessage,
    String? errorMessage,
    ResearchDocumentEntity? savedDocument,
  }) {
    return MarkdownEditorState(
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      documentId: documentId ?? this.documentId,
      researchId: researchId ?? this.researchId,
      folderId: folderId ?? this.folderId,
      title: title ?? this.title,
      content: content ?? this.content,
      files: files ?? this.files,
      references: references ?? this.references,
      saveMessage: saveMessage,
      errorMessage: errorMessage,
      savedDocument: savedDocument,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        isSaving,
        documentId,
        researchId,
        folderId,
        title,
        content,
        files,
        references,
        saveMessage,
        errorMessage,
        savedDocument,
      ];
}
