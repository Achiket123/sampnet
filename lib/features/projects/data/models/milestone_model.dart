import 'package:hackathon/features/projects/domain/entities/milestone_entity.dart';

class MilestoneModel extends Milestone {
  const MilestoneModel({
    required super.id,
    required super.projectId,
    required super.title,
    required super.description,
    required super.dueDate,
    required super.status,
    required super.isOverdue,
    required super.organisationId,
  });

  factory MilestoneModel.fromJson(Map<String, dynamic> json) {
    return MilestoneModel(
      id: json['id'] ?? 0,
      projectId: json['project_id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      dueDate: json['due_date'] != null ? DateTime.parse(json['due_date']) : DateTime.now(),
      status: json['status'] ?? 'Pending',
      isOverdue: json['is_overdue'] ?? false,
      organisationId: json['organisation_id'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'project_id': projectId,
      'title': title,
      'description': description,
      'due_date': dueDate.toIso8601String(),
      'status': status,
      'organisation_id': organisationId,
    };
  }
}