part of 'research_workspace_bloc.dart';

abstract class ResearchWorkspaceEvent extends Equatable {
  const ResearchWorkspaceEvent();

  @override
  List<Object?> get props => [];
}

class LoadWorkspace extends ResearchWorkspaceEvent {
  final int researchId;
  final int? parentFolderId;

  const LoadWorkspace({required this.researchId, this.parentFolderId});

  @override
  List<Object?> get props => [researchId, parentFolderId];
}

class CreateWorkspaceFolder extends ResearchWorkspaceEvent {
  final int researchId;
  final int? parentFolderId;
  final String name;

  const CreateWorkspaceFolder({
    required this.researchId,
    required this.parentFolderId,
    required this.name,
  });

  @override
  List<Object?> get props => [researchId, parentFolderId, name];
}

class CreateWorkspaceDocument extends ResearchWorkspaceEvent {
  final int researchId;
  final int? folderId;
  final String title;
  final String content;

  const CreateWorkspaceDocument({
    required this.researchId,
    required this.folderId,
    required this.title,
    required this.content,
  });

  @override
  List<Object?> get props => [researchId, folderId, title, content];
}

class DeleteWorkspaceFolder extends ResearchWorkspaceEvent {
  final int researchId;
  final int? parentFolderId;
  final int folderId;

  const DeleteWorkspaceFolder({
    required this.researchId,
    required this.parentFolderId,
    required this.folderId,
  });

  @override
  List<Object?> get props => [researchId, parentFolderId, folderId];
}

class DeleteWorkspaceDocument extends ResearchWorkspaceEvent {
  final int researchId;
  final int? parentFolderId;
  final int documentId;

  const DeleteWorkspaceDocument({
    required this.researchId,
    required this.parentFolderId,
    required this.documentId,
  });

  @override
  List<Object?> get props => [researchId, parentFolderId, documentId];
}
