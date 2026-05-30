import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:hackathon/globals/models/organisation_model.dart';
import 'package:hackathon/globals/models/project_model.dart';
import 'package:hackathon/globals/models/team_model.dart';
import 'package:hackathon/globals/models/user_model.dart';

class TaskEntity extends Equatable {
  final int? id;
  final String title;
  final String? description;
  final DateTime dueDate;
  final int assignedTo;
  final UserModel? assignedUser; // Dart equivalent for assigned user relation
  final int assignedBy;
  final UserModel?
      assignedByUser; // Dart equivalent for assigned by user relation
  final String type; // e.g., "Bug", "Feature"
  final String priority; // e.g., "High", "Medium", "Low"
  String status; // e.g., "Not Started", "Pending", "Done", "Blocked"
  final String completionStatus;
  final int organisationId;
  final Organisation? organisation;
  final DateTime? createdAt;
  final bool isPersonal;
  final int? teamId;
  final Team? team;
  final int? projectId;
  final Project? project;

  TaskEntity(
      {this.id,
      required this.title,
      this.description,
      required this.dueDate,
      required this.assignedTo,
      this.assignedUser,
      required this.assignedBy,
      this.assignedByUser,
      required this.type,
      required this.priority,
      this.status = "Pending",
      this.completionStatus = "Not Started",
      required this.organisationId,
      this.organisation,
      this.createdAt,
      required this.isPersonal,
      this.project,
      this.projectId,
      this.teamId,
      this.team});
  String toJson() {
    return jsonEncode({
      'id': id,
      'title': title,
      'description': description,
      'due_date': dueDate.toUtc().toIso8601String(),
      'assigned_to': assignedTo,
      'assigned_by': assignedBy,
      'type': type,
      'priority': priority,
      'status': status,
      'completion_status': completionStatus,
      'organisation_id': organisationId,
      'organisation': organisation,
      'created_at': createdAt?.toUtc().toIso8601String(),
      'is_personal': isPersonal,
      'team_id': teamId,
      'project_id': projectId
    });
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'due_date': dueDate.toUtc().toIso8601String(),
      'assigned_to': assignedTo,
      'assigned_by': assignedBy,
      'is_personal': isPersonal,
      'type': type,
      'priority': priority,
      'status': status,
      'completion_status': completionStatus,
      'organisation_id': organisationId,
      'organisation': organisation,
      'createdAt': createdAt?.toUtc().toIso8601String(),
      'team_id': team?.id,
      'project_id': project?.id
    };
  }

  static TaskEntity empty() => TaskEntity(
        isPersonal: false,
        title:
            'Task 1 Lorem ipsum dolor sit amet consectetur adipisicing elit. Quisquam, quos.',
        dueDate: DateTime.now(),
        createdAt: DateTime.now(),
        assignedTo: 1,
        assignedBy: 1,
        type: 'Bug',
        priority: 'High',
        status: 'Pending',
        completionStatus: 'Not Started',
        organisationId: 1,
        assignedByUser: UserModel(
          city: 'New York',
          country: 'USA',
          lastLoginAt: DateTime.now(),
          id: 1,
          firstName: 'John',
          lastName: 'Doe',
          email: 'john@doe.com',
          phoneNumber: '1234567890',
          isVerified: true,
          hashedPassword: '1234567890',
          profilePic: 'https://example.com/profile.jpg',
        ),
        assignedUser: UserModel(
          city: 'New York',
          country: 'USA',
          lastLoginAt: DateTime.now(),
          id: 1,
          firstName: 'Jhonson',
          lastName: 'Doe',
          email: 'jhonson@doe.com',
          phoneNumber: '1234567890',
          isVerified: true,
          hashedPassword: '1234567890',
          profilePic: 'https://example.com/profile.jpg',
        ),
      );

  // TaskEntity copyWith({
  //   int? id,
  //   String? title,
  //   String? description,
  //   DateTime? dueDate,
  //   int? assignedTo,
  //   int? assignedBy,
  //   String? type,
  //   String? priority,
  //   String? status,
  //   String? completionStatus,
  //   int? organisationId,
  //   Organisation? organisation,
  //   DateTime? createdAt,
  //   bool? isPersonal,
  // }) => TaskEntity(
  //   id: id ?? this.id,
  //   title: title ?? this.title,
  //   description: description ?? this.description,
  //   dueDate: dueDate ?? this.dueDate,
  //   assignedTo: assignedTo ?? this.assignedTo,
  //   assignedBy: assignedBy ?? this.assignedBy,
  //   type: type ?? this.type,
  //   priority: priority ?? this.priority,
  //   organisationId: organisationId ?? this.organisationId,
  //   isPersonal: isPersonal ?? this.isPersonal,
  //   organisation: organisation ?? this.organisation,
  //   createdAt: createdAt ?? this.createdAt,
  //   status: status ?? this.status,
  //   completionStatus: completionStatus ?? this.completionStatus,

  // );

  @override
  List<Object?> get props => [
        id,
      ];
}
