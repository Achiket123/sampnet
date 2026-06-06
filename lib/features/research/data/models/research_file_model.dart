import '../../domain/entities/research_file_entity.dart';

class ResearchFileModel extends ResearchFileEntity {
  const ResearchFileModel({
    required super.id,
    required super.researchId,
    super.documentId,
    super.folderId,
    required super.fileName,
    required super.mimeType,
    required super.size,
    required super.storagePath,
    super.previewPath,
    super.thumbnailPath,
    required super.isPinned,
    required super.updatedAt,
  });

  factory ResearchFileModel.fromJson(Map<String, dynamic> json) {
    return ResearchFileModel(
      id: json['id'],
      researchId: json['research_id'],
      documentId: json['document_id'],
      folderId: json['folder_id'],
      fileName: json['file_name'],
      mimeType: json['mime_type'],
      size: json['size'],
      storagePath: json['storage_path'],
      previewPath: json['preview_path'],
      thumbnailPath: json['thumbnail_path'],
      isPinned: json['is_pinned'] ?? false,
      updatedAt: DateTime.parse(json['updated_at']).toLocal(),
    );
  }
}
