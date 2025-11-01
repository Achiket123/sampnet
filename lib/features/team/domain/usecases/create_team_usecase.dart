import 'package:fpdart/src/either.dart';
import 'package:hackathon/features/team/domain/repo/team_repository.dart';
import 'package:hackathon/globals/constants/usecase.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';
import 'package:hackathon/globals/models/team_model.dart';

class CreateTeamUsecase extends Usecase<List<Team>, CreateTeamParam> {
  final TeamRepository _teamRepository;

  CreateTeamUsecase(this._teamRepository);
  @override
  Future<Either<ErrorModel, List<Team>>> call(CreateTeamParam params) {
    return _teamRepository.createTeam(params);
  }
}

class CreateTeamParam {
  final String name;
  final String description;
  final int organisationId;
  final int createdBy;
  final bool isActive;
  final int? teamLead;
  final int? projectId;
  final List<int>? members;

  CreateTeamParam({
    required this.name,
    required this.description,
    required this.organisationId,
    required this.createdBy,
    required this.isActive,
    this.teamLead,
    this.projectId,
    this.members,
  });

  // Convert instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'organisation_id': organisationId,
      'created_by': createdBy,
      'is_active': isActive,
      'team_lead': teamLead,
      'project_id': projectId,
      'members': members,
    };
  }

  // Create instance from JSON
  factory CreateTeamParam.fromJson(Map<String, dynamic> json) {
    return CreateTeamParam(
      name: json['name'] as String,
      description: json['description'] as String,
      organisationId: json['organisation_id'] as int,
      createdBy: json['created_by'] as int,
      isActive: json['is_active'] as bool,
      teamLead: json['team_lead'] as int?,
      projectId: json['project_id'] as int?,
      members: (json['members'] as List<dynamic>?)
          ?.map((member) => member as int)
          .toList(),
    );
  }
}

