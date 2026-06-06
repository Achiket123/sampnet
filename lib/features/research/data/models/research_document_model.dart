import '../../domain/entities/research_document_entity.dart';

class ResearchDocumentModel extends ResearchDocumentEntity {
  const ResearchDocumentModel({
    required super.id,
    required super.researchId,
    required super.folderId,
    required super.title,
    required super.content,
    required super.isPinned,
    required super.status,
    required super.createdBy,
    required super.updatedAt,
  });

  factory ResearchDocumentModel.fromJson(Map<String, dynamic> json) {
    return ResearchDocumentModel(
      id: json['id'] ?? 0,
      researchId: json['research_id'] ?? 0,
      folderId: json['folder_id'],
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      isPinned: json['is_pinned'] ?? false,
      status: json['status'] ?? 'active',
      createdBy: json['created_by'] ?? 0,
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '')?.toLocal() ??
          DateTime.now(),
    );
  }
}
