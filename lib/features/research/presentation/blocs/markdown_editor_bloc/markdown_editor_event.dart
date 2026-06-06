part of 'markdown_editor_bloc.dart';

abstract class MarkdownEditorEvent extends Equatable {
  const MarkdownEditorEvent();

  @override
  List<Object?> get props => [];
}

class LoadMarkdownDocument extends MarkdownEditorEvent {
  final int documentId;
  final int researchId;
  final int? folderId;
  final String? initialTitle;
  final String? initialContent;

  const LoadMarkdownDocument({
    required this.documentId,
    required this.researchId,
    required this.folderId,
    this.initialTitle,
    this.initialContent,
  });

  @override
  List<Object?> get props =>
      [documentId, researchId, folderId, initialTitle, initialContent];
}

class SaveMarkdownDocument extends MarkdownEditorEvent {
  final int documentId;
  final int researchId;
  final int? folderId;
  final String title;
  final String content;

  const SaveMarkdownDocument({
    required this.documentId,
    required this.researchId,
    required this.folderId,
    required this.title,
    required this.content,
  });

  @override
  List<Object?> get props => [documentId, researchId, folderId, title, content];
}

class AutosaveMarkdownDocument extends MarkdownEditorEvent {
  final int documentId;
  final int researchId;
  final int? folderId;
  final String title;
  final String content;

  const AutosaveMarkdownDocument({
    required this.documentId,
    required this.researchId,
    required this.folderId,
    required this.title,
    required this.content,
  });

  @override
  List<Object?> get props => [documentId, researchId, folderId, title, content];
}

class LoadDocumentArtifacts extends MarkdownEditorEvent {
  final int documentId;
  const LoadDocumentArtifacts({required this.documentId});

  @override
  List<Object?> get props => [documentId];
}

class UploadEditorFile extends MarkdownEditorEvent {
  final int researchId;
  final int? documentId;
  final String fileName;
  final List<int> bytes;
  final String mimeType;

  const UploadEditorFile({
    required this.researchId,
    this.documentId,
    required this.fileName,
    required this.bytes,
    required this.mimeType,
  });

  @override
  List<Object?> get props => [researchId, documentId, fileName, bytes, mimeType];
}

class AddEditorReference extends MarkdownEditorEvent {
  final int researchId;
  final int? documentId;
  final String title;
  final String url;
  final String? authors;

  const AddEditorReference({
    required this.researchId,
    this.documentId,
    required this.title,
    required this.url,
    this.authors,
  });

  @override
  List<Object?> get props => [researchId, documentId, title, url, authors];
}
