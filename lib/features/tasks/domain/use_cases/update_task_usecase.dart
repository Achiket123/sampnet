import 'dart:convert';

import 'package:fpdart/src/either.dart';
import 'package:hackathon/features/tasks/domain/entities/task_entity.dart';
import 'package:hackathon/features/tasks/domain/repositories/task_repository.dart';
import 'package:hackathon/globals/constants/usecase.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';

class UpdateTaskUsecase implements Usecase<List<TaskEntity>, UpdateTaskParams> {
  final UpdateTaskRepository repository;

  UpdateTaskUsecase({required this.repository});
  @override
  Future<Either<ErrorModel, List<TaskEntity>>> call(UpdateTaskParams params) =>
      repository.updateTask(params);
}

class UpdateTaskParams {
  final int id;
  final String? title;
  final DateTime? dueDate;
  final String? assignedTo;
  final String? assignedBy;
  final String? type;
  final String? priority;
  final String? organisationId;
  final bool? isPersonal;
  final String? assignedByUser;
  final String? assignedUser;
  final String? completionStatus;
  final DateTime? createdAt;
  final String? description;
  final String? organisation;
  final String? status;

  UpdateTaskParams(
      {required this.id,
      this.title,
      this.dueDate,
      this.assignedTo,
      this.assignedBy,
      this.type,
      this.priority,
      this.organisationId,
      this.isPersonal,
      this.assignedByUser,
      this.assignedUser,
      this.completionStatus,
      this.createdAt,
      this.description,
      this.organisation,
      this.status});

  String toJson() {
    return jsonEncode({
      'id': id,
      if (title != null) 'title': title,
      if (dueDate != null) 'due_date': dueDate?.toUtc().toIso8601String(),
      if (assignedTo != null) 'assigned_to': assignedTo,
      if (assignedBy != null) 'assigned_by': assignedBy,
      if (type != null) 'type': type,
      if (priority != null) 'priority': priority,
      if (organisationId != null) 'organisation_id': organisationId,
      if (isPersonal != null) 'is_personal': isPersonal,
      if (assignedByUser != null) 'assigned_by_user': assignedByUser,
      if (assignedUser != null) 'assigned_user': assignedUser,
      if (completionStatus != null) 'completion_status': completionStatus,
      if (createdAt != null) 'created_at': createdAt?.toUtc().toIso8601String(),
      if (description != null) 'description': description,
      if (organisation != null) 'organisation': organisation,
      if (status != null) 'status': status
    });
  }
}
