import 'package:equatable/equatable.dart';

class PeopleContactEntity extends Equatable {
  final int id;
  final int organisationId;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String? company;
  final String? jobTitle;
  final int? stageId;
  final String? stageName;
  final int? assignedToId;
  final String? assignedToName;
  final String? assignedToAvatar;
  final List<String> tags;
  final Map<String, dynamic> customFields;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  const PeopleContactEntity({
    required this.id,
    required this.organisationId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    this.company,
    this.jobTitle,
    this.stageId,
    this.stageName,
    this.assignedToId,
    this.assignedToName,
    this.assignedToAvatar,
    required this.tags,
    required this.customFields,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        organisationId,
        firstName,
        lastName,
        email,
        phone,
        company,
        jobTitle,
        stageId,
        stageName,
        assignedToId,
        assignedToName,
        assignedToAvatar,
        tags,
        customFields,
        status,
        createdAt,
        updatedAt,
      ];
}

class PeopleInteractionEntity extends Equatable {
  final int id;
  final int contactId;
  final int createdById;
  final String createdByName;
  final String? createdByAvatarUrl;
  final String type;
  final String content;
  final String? outcome;
  final int? linkedTaskId;
  final DateTime occurredAt;
  final DateTime createdAt;

  const PeopleInteractionEntity({
    required this.id,
    required this.contactId,
    required this.createdById,
    required this.createdByName,
    this.createdByAvatarUrl,
    required this.type,
    required this.content,
    this.outcome,
    this.linkedTaskId,
    required this.occurredAt,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        contactId,
        createdById,
        createdByName,
        createdByAvatarUrl,
        type,
        content,
        outcome,
        linkedTaskId,
        occurredAt,
        createdAt,
      ];
}

class PipelineStageEntity extends Equatable {
  final int id;
  final int organisationId;
  final String name;
  final String? color;
  final int orderIndex;
  final String? description;

  const PipelineStageEntity({
    required this.id,
    required this.organisationId,
    required this.name,
    this.color,
    required this.orderIndex,
    this.description,
  });

  @override
  List<Object?> get props => [id, organisationId, name, color, orderIndex, description];
}

class PeopleListEntity extends Equatable {
  final int id;
  final int organisationId;
  final String name;
  final String? description;
  final bool isShared;

  const PeopleListEntity({
    required this.id,
    required this.organisationId,
    required this.name,
    this.description,
    required this.isShared,
  });

  @override
  List<Object?> get props => [id, organisationId, name, description, isShared];
}
