import 'package:hackathon/features/tasks/domain/entities/task_entity.dart';
import 'package:hackathon/globals/models/organisation_model.dart';
import 'package:hackathon/globals/models/project_model.dart';
import 'package:hackathon/globals/models/team_model.dart';
import 'package:hackathon/globals/models/user_model.dart';

class TaskModel extends TaskEntity {
  TaskModel(
      {required super.id,
      required super.title,
      required super.description,
      required super.dueDate,
      required super.assignedTo,
      required super.assignedBy,
      required super.isPersonal,
      required super.type,
      required super.priority,
      super.status,
      super.completionStatus,
      required super.organisationId,
      super.organisation,
      super.assignedUser,
      super.assignedByUser,
      super.project,
      super.team,
      super.createdAt});

  @override
  toMap() {
    return {
      'ID': id,
      'title': title,
      'description': description,
      'due_date': dueDate,
      'assigned_to': assignedTo,
      'assigned_by': assignedBy,
      'is_personal': isPersonal,
      'type': type,
      'priority': priority,
      'status': status,
      'completion_status': completionStatus,
      'organisation_id': organisationId,
      'organisation': organisation,
      'createdAt': createdAt,
      'team_id': team?.id,
      'project_id': project?.id
    };
  }

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
        id: json['ID'],
        title: json['title'],
        description: json['description'],
        dueDate: DateTime.parse(json['due_date']),
        assignedTo: json['assigned_to'],
        assignedBy: json['assigned_by'],
        isPersonal: json['is_personal'],
        type: json['type'],
        priority: json['priority'],
        status: json['status'],
        // completionStatus: json['completion_status'],
        organisationId: json['organisation_id'],
        organisation: json['organisation'] != null
            ? Organisation.fromJson(json['organisation'])
            : null,
        createdAt: DateTime.parse(json['CreatedAt']),
        assignedUser: json['assigned_user'] != null
            ? UserModel.fromJson(json['assigned_user'])
            : null,
        assignedByUser: json['assigned_by_user'] != null
            ? UserModel.fromJson(json['assigned_by_user'])
            : null,
        project:
            json['project'] != null ? Project.fromJson(json['project']) : null,
        team: json['team'] != null ? Team.fromJson(json['team']) : null);
  }
}
