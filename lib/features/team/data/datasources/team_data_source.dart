import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hackathon/dependency_injection.g.dart';
import 'package:hackathon/features/tasks/data/models/team_model.dart';
import 'package:hackathon/features/team/data/models/team_member.dart';
import 'package:hackathon/features/team/data/models/team_memory.dart';
import 'package:hackathon/features/team/domain/usecases/create_team_usecase.dart';
import 'package:hackathon/globals/constants/api_end_points.dart';
import 'package:hackathon/globals/constants/user.dart';
import 'package:hackathon/globals/data/team_data.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';
import 'package:hackathon/globals/models/team_model.dart';
import 'package:http/http.dart' as http;

abstract class TeamDataSource {
  Future<Either<ErrorModel, List<Team>>> getTeams(String token);
  Future<Either<ErrorModel, TeamMemory>> getTeamById(String token);
  Future<Either<ErrorModel, List<Team>>> createTeam(CreateTeamParam params);
  Future<Either<ErrorModel, int>> deleteTeam(int id);
  Future<Either<ErrorModel, Team>> updateTeam(int id, Team team);
}

class TeamDataSourceImpl implements TeamDataSource {
  final http.Client client;
  TeamDataSourceImpl({required this.client});
  @override
  Future<Either<ErrorModel, List<Team>>> getTeams(String token) async {
    try {
      debugPrint(getIt<User>().organisation.toString());
      final url = Uri.parse(ApiConstants.getTeamsByOrganisation);
      final response = await client.get(url, headers: {
        'Authorization': token,
      });
      if (response.statusCode == 200) {
        debugPrint("TEAM RESP: ${response.toString()}");
        final data = jsonDecode(response.body)['teams'];
        TeamData.teams = data.map<Team>((e) => Team.fromJson(e)).toList();
        debugPrint("TEAM-DEBUG: ${TeamData.teams.toString()}");
        return right(TeamData.teams);
      }
      return left(ErrorModel(message: response.body));
    } catch (e) {
      debugPrint(e.toString());
      return left(ErrorModel(message: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, List<Team>>> createTeam(
      CreateTeamParam params) async {
    try {
      final response = await client.post(
        Uri.parse(ApiConstants.createTeam),
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
          "Authorization": getIt<User>().token!
        },
        body: jsonEncode(params.toJson()),
      );
      debugPrint(params.members.toString());
      if (response.statusCode == 200) {
        print("Response ${response.body}");
        final team = Team.fromJson(jsonDecode(response.body)['team']);
        TeamData.teams.add(team);
        return right(TeamData.teams);
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      print("Error");
      print(e);
      return left(ErrorModel(message: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, TeamMemory>> getTeamById(String id) async {
    try {
      final url = Uri.parse("${ApiConstants.getTeamById}/$id");
      final response = await client.get(url, headers: {
        'Authorization': getIt<User>().token!,
      });
      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);

        final data = decodedData['team'];
        final teamMember = decodedData['team_members']
            .map<TeamMember>((e) => TeamMember.fromJson(e))
            .toList();
        final teamMemory =
            TeamMemory(team: Team.fromJson(data), teamMember: teamMember);
        return right(teamMemory);
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      print(e);
      return left(ErrorModel(message: "Something went wrong"));
    }
  }

  @override
  Future<Either<ErrorModel, int>> deleteTeam(int id) async {
    try {
      final url = Uri.parse("${ApiConstants.deleteTeam}/$id");
      final response = await client.delete(url, headers: {
        'Authorization': getIt<User>().token!,
      });
      if (response.statusCode == 200) {
        return right(response.statusCode);
      } else {
        throw Exception("Error Deleting Team");
      }
    } catch (e) {
      print(e);
      return left(ErrorModel(message: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, Team>> updateTeam(int id, Team team) async {
    try {
      final url = Uri.parse("${ApiConstants.updateTeam}/$id");
      final response = await client.put(
        url,
        headers: {
          'Authorization': getIt<User>().token!,
        },
      );
      if (response.statusCode < 400) {
        return right(team);
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      print(e);
      return left(ErrorModel(message: e.toString()));
    }
  }
}
