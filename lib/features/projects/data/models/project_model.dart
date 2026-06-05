import 'package:hackathon/features/projects/data/models/milestone_model.dart';
import 'package:hackathon/features/projects/domain/entities/project_entity.dart';

class ProjectModel extends Project {
  const ProjectModel({
    required super.id,
    required super.name,
    required super.description,
    required super.startDate,
    required super.endDate,
    required super.organisationId,
    required super.teamId,
    required super.createdBy,
    required super.status,
    required super.priority,
    required super.completionStatus,
    required super.milestones,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    var milestonesJson = json['milestones'] as List?;
    var milestonesList = milestonesJson != null
        ? milestonesJson.map((m) => MilestoneModel.fromJson(m)).toList()
        : <MilestoneModel>[];

    return ProjectModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      startDate: json['start_date'] != null ? DateTime.parse(json['start_date']) : DateTime.now(),
      endDate: json['end_date'] != null ? DateTime.parse(json['end_date']) : DateTime.now(),
      organisationId: json['organisation_id'] ?? 0,
      teamId: json['team_id'] ?? 0,
      createdBy: json['created_by'] ?? 0,
      status: json['status'] ?? 'Planning',
      priority: json['priority'] ?? 'Medium',
      completionStatus: json['completion_status'] ?? '',
      milestones: milestonesList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'organisation_id': organisationId,
      'team_id': teamId,
      'created_by': createdBy,
      'status': status,
      'priority': priority,
      'completion_status': completionStatus,
    };
  }
}