import 'package:hackathon/features/team/domain/entities/project_entity.dart';

class ProjectModel extends ProjectEntity{
  ProjectModel({required super.id, required super.name,required super.description});

  factory ProjectModel.fromJson(Map<String, dynamic> json) => ProjectModel(id: json['id'], name: json['name'], description: json['description']);
}