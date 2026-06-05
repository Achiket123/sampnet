import 'package:equatable/equatable.dart';
import 'package:hackathon/features/projects/domain/entities/milestone_entity.dart';

class Project extends Equatable {
  final int id;
  final String name;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final int organisationId;
  final int teamId;
  final int createdBy;
  final String status;
  final String priority;
  final String completionStatus;
  final List<Milestone> milestones;

  const Project({
    required this.id,
    required this.name,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.organisationId,
    required this.teamId,
    required this.createdBy,
    required this.status,
    required this.priority,
    required this.completionStatus,
    required this.milestones,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        startDate,
        endDate,
        organisationId,
        teamId,
        createdBy,
        status,
        priority,
        completionStatus,
        milestones,
      ];
}