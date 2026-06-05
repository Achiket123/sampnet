import 'package:equatable/equatable.dart';
import 'research_status.dart';

class ResearchEntryEntity extends Equatable {
  final int id;
  final String title;
  final String description;
  final ResearchStatus status;
  final String authorName;
  final int authorId;
  final int? projectId;
  final String? projectName;
  final int? teamId;
  final String? teamName;
  final List<String> tags;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ResearchEntryEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.authorName,
    required this.authorId,
    this.projectId,
    this.projectName,
    this.teamId,
    this.teamName,
    required this.tags,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        status,
        authorName,
        authorId,
        projectId,
        projectName,
        teamId,
        teamName,
        tags,
        createdAt,
        updatedAt,
      ];
}
