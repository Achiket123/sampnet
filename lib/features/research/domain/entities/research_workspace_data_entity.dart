import 'package:equatable/equatable.dart';

import 'research_document_entity.dart';
import 'research_folder_entity.dart';

class ResearchWorkspaceDataEntity extends Equatable {
  final List<ResearchFolderEntity> folders;
  final List<ResearchDocumentEntity> documents;

  const ResearchWorkspaceDataEntity({
    required this.folders,
    required this.documents,
  });

  @override
  List<Object?> get props => [folders, documents];
}
