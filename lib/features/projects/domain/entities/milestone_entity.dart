import 'package:equatable/equatable.dart';

class Milestone extends Equatable {
  final int id;
  final int projectId;
  final String title;
  final String description;
  final DateTime dueDate;
  final String status;
  final bool isOverdue;
  final int organisationId;

  const Milestone({
    required this.id,
    required this.projectId,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.status,
    required this.isOverdue,
    required this.organisationId,
  });

  @override
  List<Object?> get props => [
        id,
        projectId,
        title,
        description,
        dueDate,
        status,
        isOverdue,
        organisationId,
      ];
}