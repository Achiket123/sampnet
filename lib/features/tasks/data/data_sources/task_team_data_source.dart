import 'dart:convert';

import 'package:fpdart/fpdart.dart';
import 'package:hackathon/features/tasks/data/models/team_model.dart';
import 'package:hackathon/globals/constants/api_end_points.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';
import 'package:hackathon/globals/models/team_model.dart';
import 'package:http/http.dart' as http;

abstract class TaskTeamDataSource {
  Future<Either<ErrorModel, List<TeamModel >>> getTeams(String token);
}

class TaskTeamDataSourceImpl implements TaskTeamDataSource {
  final http.Client client;
  TaskTeamDataSourceImpl({required this.client});
  @override
  Future<Either<ErrorModel, List<TeamModel>>> getTeams(String token) async {
    try {
      final url = Uri.parse(ApiConstants.getTeams);
      final response = await client.get(url, headers: {
        'Authorization': token,
      });
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['teams'];
        return right(data.map<Team >((e) => Team.fromJson(e)).toList());
      }
      return left(ErrorModel(message: response.body));
    } catch (e) {
      return left(ErrorModel(message: e.toString()));
    }
  }
}
