import '../../domain/entities/research_folder_entity.dart';

class ResearchFolderModel extends ResearchFolderEntity {
  const ResearchFolderModel({
    required super.id,
    required super.researchId,
    required super.parentId,
    required super.name,
    required super.createdBy,
    required super.updatedAt,
  });

  factory ResearchFolderModel.fromJson(Map<String, dynamic> json) {
    return ResearchFolderModel(
      id: json['id'] ?? 0,
      researchId: json['research_id'] ?? 0,
      parentId: json['parent_id'],
      name: json['name'] ?? '',
      createdBy: json['created_by'] ?? 0,
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '')?.toLocal() ??
          DateTime.now(),
    );
  }
}
