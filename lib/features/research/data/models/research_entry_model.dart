import '../../domain/entities/research_entry_entity.dart';
import '../../domain/entities/research_status.dart';

class ResearchEntryModel extends ResearchEntryEntity {
  const ResearchEntryModel({
    required super.id,
    required super.title,
    required super.description,
    required super.status,
    required super.authorName,
    required super.authorId,
    super.projectId,
    super.projectName,
    super.teamId,
    super.teamName,
    required super.tags,
    required super.createdAt,
    required super.updatedAt,
  });

  factory ResearchEntryModel.fromJson(Map<String, dynamic> json) {
    return ResearchEntryModel(
      id: json['id'],
      title: json['title'],
      description: json['description'] ?? '',
      authorId: json['author_id'],
      status: ResearchStatusX.fromString(json['status']),
      authorName: json['author_name'] ?? 'Unknown',
      projectId: json['project_id'],
      projectName: json['project_name'],
      teamId: json['team_id'],
      teamName: json['team_name'],
      tags: List<String>.from(json['tags'] ?? []),
      createdAt: DateTime.parse(json['created_at']).toLocal(),
      updatedAt: DateTime.parse(json['updated_at']).toLocal(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'status': status.value,
      'project_id': projectId,
      'team_id': teamId,
      'tags': tags,
    };
  }

  static ResearchEntryModel fromEntity(ResearchEntryEntity entity) {
    return ResearchEntryModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      status: entity.status,
      authorId: entity.authorId,
      authorName: entity.authorName,
      projectId: entity.projectId,
      projectName: entity.projectName,
      teamId: entity.teamId,
      teamName: entity.teamName,
      tags: entity.tags,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
