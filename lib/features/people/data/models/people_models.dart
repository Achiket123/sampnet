import '../../domain/entities/people_entities.dart';

class PeopleContactModel extends PeopleContactEntity {
  const PeopleContactModel({
    required super.id,
    required super.organisationId,
    required super.firstName,
    required super.lastName,
    required super.email,
    required super.phone,
    super.company,
    super.jobTitle,
    super.stageId,
    super.stageName,
    super.assignedToId,
    super.assignedToName,
    super.assignedToAvatar,
    required super.tags,
    required super.customFields,
    required super.status,
    required super.createdAt,
    required super.updatedAt,
  });

  factory PeopleContactModel.fromJson(Map<String, dynamic> json) {
    return PeopleContactModel(
      id: json['id'] ?? 0,
      organisationId: json['organisation_id'] ?? 0,
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      company: json['company'],
      jobTitle: json['job_title'],
      stageId: json['stage_id'],
      stageName: json['stage_name'],
      assignedToId: json['assigned_to_id'],
      assignedToName: json['assigned_to_name'],
      assignedToAvatar: json['assigned_to_avatar'],
      tags: List<String>.from(json['tags'] ?? []),
      customFields: Map<String, dynamic>.from(json['custom_fields'] ?? {}),
      status: json['status'] ?? 'active',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'organisation_id': organisationId,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone': phone,
      'company': company,
      'job_title': jobTitle,
      'stage_id': stageId,
      'assigned_to_id': assignedToId,
      'tags': tags,
      'custom_fields': customFields,
      'status': status,
    };
  }
}

class PeopleInteractionModel extends PeopleInteractionEntity {
  const PeopleInteractionModel({
    required super.id,
    required super.contactId,
    required super.createdById,
    required super.createdByName,
    super.createdByAvatarUrl,
    required super.type,
    required super.content,
    super.outcome,
    super.linkedTaskId,
    required super.occurredAt,
    required super.createdAt,
  });

  factory PeopleInteractionModel.fromJson(Map<String, dynamic> json) {
    return PeopleInteractionModel(
      id: json['id'] ?? 0,
      contactId: json['contact_id'] ?? 0,
      createdById: json['created_by_id'] ?? 0,
      createdByName: json['created_by_name'] ?? '',
      createdByAvatarUrl: json['created_by_avatar'],
      type: json['type'] ?? '',
      content: json['content'] ?? '',
      outcome: json['outcome'],
      linkedTaskId: json['linked_task_id'],
      occurredAt: json['occurred_at'] != null
          ? DateTime.parse(json['occurred_at'])
          : DateTime.now(),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'contact_id': contactId,
      'type': type,
      'content': content,
      'outcome': outcome,
      'linked_task_id': linkedTaskId,
      'occurred_at': occurredAt.toIso8601String(),
    };
  }
}

class PipelineStageModel extends PipelineStageEntity {
  const PipelineStageModel({
    required super.id,
    required super.organisationId,
    required super.name,
    super.color,
    required super.orderIndex,
    super.description,
  });

  factory PipelineStageModel.fromJson(Map<String, dynamic> json) {
    return PipelineStageModel(
      id: json['id'] ?? 0,
      organisationId: json['organisation_id'] ?? 0,
      name: json['name'] ?? '',
      color: json['color'],
      orderIndex: json['order_index'] ?? 0,
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'organisation_id': organisationId,
      'name': name,
      'color': color,
      'order_index': orderIndex,
      'description': description,
    };
  }
}

class PeopleListModel extends PeopleListEntity {
  const PeopleListModel({
    required super.id,
    required super.organisationId,
    required super.name,
    super.description,
    required super.isShared,
  });

  factory PeopleListModel.fromJson(Map<String, dynamic> json) {
    return PeopleListModel(
      id: json['id'] ?? 0,
      organisationId: json['organisation_id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'],
      isShared: json['is_shared'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'organisation_id': organisationId,
      'name': name,
      'description': description,
      'is_shared': isShared,
    };
  }
}
