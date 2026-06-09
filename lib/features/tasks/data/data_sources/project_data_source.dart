import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hackathon/features/tasks/data/models/project_model.dart';
import 'package:hackathon/globals/constants/api_end_points.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';
import 'package:hackathon/services/api_client.dart';
import 'package:http/http.dart' as http;

import 'package:hackathon/dependency_injection.g.dart';
import 'package:hackathon/globals/constants/user.dart';

abstract class ProjectDataSource {
  Future<Either<ErrorModel, List<ProjectModel>>> getProjects(String token);
}

class ProjectDataSourceImpl implements ProjectDataSource {
  final ApiClient client;
  ProjectDataSourceImpl({required this.client});
  @override
  Future<Either<ErrorModel, List<ProjectModel>>> getProjects(
      String token) async {
    try {
      final response = await client.get(
        "${ApiConstants.baseUrl}${ApiConstants.getProjects}",
      );
      if (response.statusCode == 200) {
        final List<ProjectModel> projects = List<ProjectModel>.from(
            jsonDecode(response.body)['projects']
                .map((project) => ProjectModel.fromJson(project)));
        return right(projects);
      } else {
        debugPrint(response.body);
        return left(ErrorModel(message: response.body));
      }
    } catch (e) {
      debugPrint(e.toString());
      return left(ErrorModel(message: e.toString()));
    }
  }
}
