part of 'research_workspace_bloc.dart';

class ResearchWorkspaceState extends Equatable {
  final bool isLoading;
  final int? researchId;
  final int? currentFolderId;
  final List<ResearchFolderEntity> folders;
  final List<ResearchDocumentEntity> documents;
  final ResearchDocumentEntity? createdDocument;
  final String? errorMessage;

  const ResearchWorkspaceState({
    this.isLoading = false,
    this.researchId,
    this.currentFolderId,
    this.folders = const [],
    this.documents = const [],
    this.createdDocument,
    this.errorMessage,
  });

  ResearchWorkspaceState copyWith({
    bool? isLoading,
    int? researchId,
    int? currentFolderId,
    List<ResearchFolderEntity>? folders,
    List<ResearchDocumentEntity>? documents,
    ResearchDocumentEntity? createdDocument,
    String? errorMessage,
  }) {
    return ResearchWorkspaceState(
      isLoading: isLoading ?? this.isLoading,
      researchId: researchId ?? this.researchId,
      currentFolderId: currentFolderId ?? this.currentFolderId,
      folders: folders ?? this.folders,
      documents: documents ?? this.documents,
      createdDocument: createdDocument,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        researchId,
        currentFolderId,
        folders,
        documents,
        createdDocument,
        errorMessage,
      ];
}
