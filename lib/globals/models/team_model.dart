import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hackathon/dependency_injection.g.dart';
import 'package:hackathon/features/auth/domain/entity/user_entity.dart';
import 'package:hackathon/globals/constants/user.dart';
import 'package:hackathon/globals/models/organisation_model.dart';
import 'package:hackathon/globals/models/user_model.dart';

class Team extends Equatable {
  final int? id;
  final String name;
  final String? description;
  final int organisationId;
  final Organisation organisation;
  final int createdBy;
  final UserEntity? teamLeader;
  final UserEntity createdByUser;

  final bool isActive;
  final DateTime? createdAt;
  const Team({
    this.id,
    this.teamLeader,
    required this.name,
    this.description,
    required this.organisationId,
    required this.organisation,
    required this.createdBy,
    required this.createdByUser,
    this.createdAt,
    this.isActive = true,
  });
  factory Team.fromJson(Map<String, dynamic> json) {
    debugPrint("TEAM: ${json.toString()}");
    return Team(
      id: json['id'],
      name: json['name'],
      teamLeader: json['team_lead_user'] != null
          ? UserModel.fromJson(json['team_lead_user'])
          : null,
      description: json['description'],
      organisationId: json['organisation_id'],
      organisation: Organisation.fromJson(json['organisation']),
      createdBy: json['created_by'],
      createdByUser: UserModel.fromJson(json['created_by_user']),
      isActive: json['is_active'] ?? true,
      createdAt:
          json['CreatedAt'] != null ? DateTime.parse(json['CreatedAt']) : null,
    );
  }

  @override
  List<Object?> get props => [
        id,
      ];

  static final empty = Team(
    name: "New Team",
    organisationId: 0,
    organisation: getIt<User>().organisation!,
    createdBy: 0,
    createdByUser: getIt<User>().user!,
  );
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'organisation_id': organisationId,
      'organisation': organisation.toJson(),
      'created_by': createdBy,
      'is_active': isActive,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
