import 'dart:convert';

import 'package:fpdart/fpdart.dart';
import 'package:hackathon/features/team/data/models/project_model.dart';
import 'package:hackathon/globals/constants/api_end_points.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';
import 'package:hackathon/services/api_client.dart';
import 'package:http/http.dart' as http;

abstract class TeamProjectDataSource {
  Future<Either<ErrorModel, List<ProjectModel>>> getProject(String token);
}

class TeamProjectDataSourceImpl implements TeamProjectDataSource {
  final ApiClient client;
  TeamProjectDataSourceImpl({required this.client});
  @override
  Future<Either<ErrorModel, List<ProjectModel>>> getProject(
      String token) async {
    try {
      final response = await client.get(
        ApiConstants.projectLessData,
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data);
        return right(data["projects"]
            .map<ProjectModel>((e) => ProjectModel.fromJson(e))
            .toList());
      }
      return left(ErrorModel(message: response.body));
    } catch (e) {
      print(e);
      return left(ErrorModel(message: e.toString()));
    }
  }
}
