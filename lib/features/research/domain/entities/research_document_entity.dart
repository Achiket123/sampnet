import 'package:equatable/equatable.dart';

class ResearchDocumentEntity extends Equatable {
  final int id;
  final int researchId;
  final int? folderId;
  final String title;
  final String content;
  final bool isPinned;
  final String status;
  final int createdBy;
  final DateTime updatedAt;

  const ResearchDocumentEntity({
    required this.id,
    required this.researchId,
    required this.folderId,
    required this.title,
    required this.content,
    required this.isPinned,
    required this.status,
    required this.createdBy,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        researchId,
        folderId,
        title,
        content,
        isPinned,
        status,
        createdBy,
        updatedAt
      ];
}
