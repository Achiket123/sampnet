import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hackathon/features/tasks/data/models/task_model.dart';
import 'package:hackathon/features/tasks/domain/entities/task_entity.dart';
import 'package:hackathon/features/tasks/domain/use_cases/create_task_usecase.dart';
import 'package:hackathon/features/tasks/domain/use_cases/update_task_usecase.dart';
import 'package:hackathon/globals/constants/api_end_points.dart';
import 'package:hackathon/globals/constants/user.dart';
import 'package:hackathon/globals/data/task_data.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';
import 'package:http/http.dart' as http;

abstract class TaskRemoteDataSource {
  Future<Either<ErrorModel, TaskModel>> createTask(CreateTaskParams params);
  Future<Either<ErrorModel, TaskEntity>> fetchTaskById(String token, String id);
  Future<Either<ErrorModel, List<TaskEntity>>> fetchTasks(String token);
  Future<Either<ErrorModel, List<TaskEntity>>> fetchTasksByOrganisationId(
      String token, String organisationId);
}

abstract class UpdateTaskRemoteDataSource {
  Future<Either<ErrorModel, List<TaskEntity>>> updateTask(
      UpdateTaskParams params);
}

class TaskRemoteDataSourceImpl extends TaskRemoteDataSource {
  final http.Client client;
  TaskRemoteDataSourceImpl({required this.client});
  @override
  Future<Either<ErrorModel, TaskModel>> createTask(
      CreateTaskParams params) async {
    try {
      final url = Uri.parse(ApiConstants.createTask);
      final response = await client.post(url,
          body: params.task.toJson(), headers: {'Authorization': params.token});
      if (response.statusCode >= 200 && response.statusCode < 300) {
        debugPrint(
          response.body,
        );
        return right(TaskModel.fromJson(jsonDecode(response.body)["task"]));
      }
      throw Exception(response.body);
    } catch (e) {
      debugPrint(
        e.toString(),
        
      );
      return left(ErrorModel(message: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, TaskModel>> fetchTaskById(String token, String id) {
    // TODO: implement fetchTaskById
    throw UnimplementedError();
  }

  @override
  Future<Either<ErrorModel, List<TaskModel>>> fetchTasks(String token) async {
    try {
      final url = Uri.parse(ApiConstants.getOrganisationTasks);
      final response = await client.get(url, headers: {'Authorization': token});
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final tasksData = jsonDecode(response.body)["tasks"];
        final tasks = tasksData
            .map<TaskModel>((task) => TaskModel.fromJson(task))
            .toList();
        TaskData.tasks = tasks;
        // debugPrint(tasks.toString(), );
        return right(tasks);
      }
      throw Exception(response.body);
    } catch (e) {
      debugPrint(
        e.toString(),
        
      );
      return left(ErrorModel(message: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, List<TaskModel>>> fetchTasksByOrganisationId(
      String token, String organisationId) {
    // TODO: implement fetchTasksByOrganisationId
    throw UnimplementedError();
  }
}

class UpdateTaskRemoteDataSourceImpl implements UpdateTaskRemoteDataSource {
  final http.Client client;

  UpdateTaskRemoteDataSourceImpl({required this.client});
  @override
  Future<Either<ErrorModel, List<TaskEntity>>> updateTask(
      UpdateTaskParams params) async {
    try {
      final url = "${ApiConstants.updateTask}/${params.id}";
      final response = await client.put(Uri.parse(url),
          headers: {"Authorization": User.token}, body: params.toJson());
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = jsonDecode(response.body)['task'];
        final task = TaskModel.fromJson(data);
        TaskData.tasks =
            TaskData.tasks.map((t) => t.id == task.id ? task : t).toList();
        return right(TaskData.tasks);
      }
      throw Exception(response.body);
    } catch (e) {
      print(e);
      return left(ErrorModel(message: e.toString()));
    }
  }
}
