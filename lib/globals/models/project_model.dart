import 'package:equatable/equatable.dart';
import 'package:hackathon/features/auth/domain/entity/user_entity.dart';
import 'package:hackathon/globals/constants/user.dart';
import 'package:hackathon/globals/models/organisation_model.dart';
import 'package:hackathon/globals/models/team_model.dart';
import 'package:hackathon/globals/models/user_model.dart';

class Project extends Equatable {
  final int? id; // Equivalent to gorm.Model's ID
  final String name;
  final String? description;
  final DateTime startDate;
  final DateTime endDate;
  final int organisationId;
  final int teamId;
  final List<Team>? teams;
  final int createdBy;
  final UserEntity createdByUser;
  final String status;
  final String priority;
  final String completionStatus;
  final Organisation organisation;

  const Project({
    this.id,
    required this.name,
    this.description,
    required this.startDate,
    required this.endDate,
    required this.organisationId,
    required this.teamId,
    this.teams,
    required this.createdBy,
    required this.createdByUser,
    required this.status,
    required this.priority,
    required this.completionStatus,
    required this.organisation,
  });
  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
        id: json['ID'],
        name: json['name'],
        description: json['description'],
        startDate: DateTime.parse(json['start_date']),
        endDate: DateTime.parse(json['end_date']),
        organisationId: json['organisation_id'],
        teamId: json['team_id'],
        teams: (json['teams'].map((x) => Team.fromJson(x))).toList(),
        createdBy: json['created_by'],
        createdByUser: UserModel.fromJson(json['created_by_user']),
        status: json['status'],
        priority: json['priority'],
        completionStatus: json['completion_status'],
        organisation: Organisation.fromJson(json['organisation']));
  }

  static Project empty = Project(
      name: "New Project",
      startDate: DateTime.now(),
      endDate: DateTime.now(),
      organisationId: 3,
      teamId: 2,
      createdBy: User.user.id,
      createdByUser: User.user,
      status: "Pending",
      priority: "Low",
      completionStatus: "Working",
      organisation: User.organisation);

  @override
  // TODO: implement props
  List<Object?> get props => [
        id,
      ];
}
