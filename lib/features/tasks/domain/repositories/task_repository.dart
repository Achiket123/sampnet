import 'dart:convert';
import 'package:fpdart/fpdart.dart';
import 'package:hackathon/features/tasks/domain/entities/task_activity_entity.dart';
import 'package:hackathon/features/tasks/domain/entities/task_entity.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';

class CreateTaskParams {
  final String token;
  final TaskEntity task;
  CreateTaskParams({required this.token, required this.task});
  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'task': task.toMap(),
    };
  }
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

  Map<String, dynamic> toMap() {
    return {
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
    };
  }
}

abstract class TaskRepository {
  Future<Either<ErrorModel, TaskEntity>> createTask(CreateTaskParams params);
}

abstract class FetchTaskRepository {
  Future<Either<ErrorModel, List<TaskEntity>>> fetchTasks(String token);
  Future<Either<ErrorModel, TaskEntity>> fetchTaskById(String token, String id);
  Future<Either<ErrorModel, List<TaskEntity>>> fetchTasksByOrganisationId(
      String token, String organisationId);
  Future<Either<ErrorModel, List<TaskActivityEntity>>> fetchTaskActivity(
      String token, String taskId);
}

abstract class UpdateTaskRepository {
  Future<Either<ErrorModel, List<TaskEntity>>> updateTask(
      UpdateTaskParams params);
  Future<Either<ErrorModel, Unit>> deleteTask(String token, String id);
}

abstract class EmpRepository {
  Future<Either<ErrorModel, List<TaskEntity>>> fetchTasksByEmpId(
      String token, String empId);
}
