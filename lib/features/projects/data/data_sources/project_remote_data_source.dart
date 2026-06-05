import 'dart:convert';
import 'package:hackathon/features/projects/data/models/project_model.dart';
import 'package:hackathon/features/projects/data/models/milestone_model.dart';
import 'package:hackathon/globals/constants/api_end_points.dart';
import 'package:hackathon/services/api_client.dart';
import 'package:flutter/foundation.dart';
abstract class ProjectRemoteDataSource {
  Future<List<ProjectModel>> getProjects();
  Future<ProjectModel> getProject(int id);
  Future<ProjectModel> createProject(ProjectModel project);
  Future<ProjectModel> updateProject(ProjectModel project);
  Future<void> deleteProject(int id);

  Future<MilestoneModel> createMilestone(MilestoneModel milestone);
  Future<MilestoneModel> updateMilestone(MilestoneModel milestone);
  Future<void> deleteMilestone(int projectId, int milestoneId);
}

class ProjectRemoteDataSourceImpl implements ProjectRemoteDataSource {
  final ApiClient apiClient;

  ProjectRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<ProjectModel>> getProjects() async {
    debugPrint(ApiConstants.getProjects);
    final response = await apiClient.get(ApiConstants.getProjects);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> projectsJson = data['projects'] ?? [];
      return projectsJson.map((json) => ProjectModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load projects: ${response.body}');
    }
  }

  @override
  Future<ProjectModel> getProject(int id) async {
    final response = await apiClient.get(ApiConstants.getProjectById(id));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return ProjectModel.fromJson(data['project']);
    } else {
      throw Exception('Failed to load project: ${response.body}');
    }
  }

  @override
  Future<ProjectModel> createProject(ProjectModel project) async {
    final response = await apiClient.post(
      ApiConstants.createProject,
      body: project.toJson(),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> data = json.decode(response.body);
      return ProjectModel.fromJson(data['project']);
    } else {
      throw Exception('Failed to create project: ${response.body}');
    }
  }

  @override
  Future<ProjectModel> updateProject(ProjectModel project) async {
    final response = await apiClient.put(
      ApiConstants.updateProject(project.id),
      body: project.toJson(),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return ProjectModel.fromJson(data['project']);
    } else {
      throw Exception('Failed to update project: ${response.body}');
    }
  }

  @override
  Future<void> deleteProject(int id) async {
    final response = await apiClient.delete(ApiConstants.deleteProject(id));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete project: ${response.body}');
    }
  }

  @override
  Future<MilestoneModel> createMilestone(MilestoneModel milestone) async {
    final response = await apiClient.post(
      ApiConstants.createMilestone(milestone.projectId),
      body: milestone.toJson(),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> data = json.decode(response.body);
      return MilestoneModel.fromJson(data['milestone']);
    } else {
      throw Exception('Failed to create milestone: ${response.body}');
    }
  }

  @override
  Future<MilestoneModel> updateMilestone(MilestoneModel milestone) async {
    final response = await apiClient.put(
      ApiConstants.updateMilestone(milestone.projectId, milestone.id),
      body: milestone.toJson(),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return MilestoneModel.fromJson(data['milestone']);
    } else {
      throw Exception('Failed to update milestone: ${response.body}');
    }
  }

  @override
  Future<void> deleteMilestone(int projectId, int milestoneId) async {
    final response = await apiClient.delete(
      ApiConstants.deleteMilestone(projectId, milestoneId),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete milestone: ${response.body}');
    }
  }
}