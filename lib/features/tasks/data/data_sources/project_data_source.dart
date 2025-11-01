import 'dart:convert';

import 'package:fpdart/fpdart.dart';
import 'package:hackathon/features/tasks/data/models/project_model.dart';
import 'package:hackathon/globals/constants/api_end_points.dart';
import 'package:hackathon/globals/constants/user.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';
import 'package:http/http.dart' as http;

abstract class ProjectDataSource {
  Future<Either<ErrorModel, List<ProjectModel>>> getProjects(String token);
}

class ProjectDataSourceImpl implements ProjectDataSource {
  final http.Client client;
  ProjectDataSourceImpl({required this.client});
  @override
  Future<Either<ErrorModel, List<ProjectModel>>> getProjects(
      String token) async {
    try {
      final response = await client.get(
          Uri.parse("${ApiConstants.getProjects}/${User.employee.organisationId}"),
          headers: {
            'Authorization': token,
          });
      if (response.statusCode == 200) {
        final List<ProjectModel> projects = List<ProjectModel>.from(
            jsonDecode(response.body)['projects']
                .map((project) => ProjectModel.fromJson(project)));
        return right(projects);
      } else {
        print(response.body);
        return left(ErrorModel(message: response.body));
      }
    } catch (e) {
      print(e);
      return left(ErrorModel(message: e.toString()));
    }
  }
}
