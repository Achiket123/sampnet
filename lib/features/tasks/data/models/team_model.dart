import 'package:hackathon/features/tasks/domain/entities/team_entity.dart';

class TeamModel extends TeamEntity {
  TeamModel({required super.id, required super.title});

  factory TeamModel.fromJson(Map<String, dynamic> json) => TeamModel(
        id: json['ID'],
        title: json['title'],
      );
}
