import 'package:hive/hive.dart';
import 'package:hackathon/features/chats/domain/entities/chat_entity.dart';
import 'package:hackathon/features/chats/data/models/chat_participant_hive_model.dart';

part 'chat_hive_model.g.dart';

@HiveType(typeId: 1)
class ChatHiveModel extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String roomId;

  @HiveField(2)
  final int organisationId;

  @HiveField(3)
  final String? name;

  @HiveField(4)
  final bool isGroup;

  @HiveField(5)
  final int createdBy;

  @HiveField(6)
  final String? lastMessage;

  @HiveField(7)
  final int? lastMessageAt;

  @HiveField(8)
  final int messageCount;

  @HiveField(9)
  final List<ChatParticipantHiveModel> participants;

  @HiveField(10)
  final int createdAt;

  @HiveField(11)
  final int updatedAt;

  ChatHiveModel({
    required this.id,
    required this.roomId,
    required this.organisationId,
    this.name,
    required this.isGroup,
    required this.createdBy,
    this.lastMessage,
    this.lastMessageAt,
    required this.messageCount,
    required this.participants,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ChatHiveModel.fromEntity(ChatEntity e) {
    return ChatHiveModel(
      id: e.id,
      roomId: e.roomId,
      organisationId: e.organisationId,
      name: e.name,
      isGroup: e.isGroup,
      createdBy: e.createdBy,
      lastMessage: e.lastMessage,
      lastMessageAt: e.lastMessageAt?.millisecondsSinceEpoch,
      messageCount: e.messageCount,
      participants: e.participants.map((p) => ChatParticipantHiveModel.fromEntity(p)).toList(),
      createdAt: e.createdAt.millisecondsSinceEpoch,
      updatedAt: e.updatedAt.millisecondsSinceEpoch,
    );
  }

  ChatEntity toEntity() {
    return ChatEntity(
      id: id,
      roomId: roomId,
      organisationId: organisationId,
      name: name,
      isGroup: isGroup,
      createdBy: createdBy,
      lastMessage: lastMessage,
      lastMessageAt: lastMessageAt != null ? DateTime.fromMillisecondsSinceEpoch(lastMessageAt!) : null,
      messageCount: messageCount,
      participants: participants.map((p) => p.toEntity()).toList(),
      createdAt: DateTime.fromMillisecondsSinceEpoch(createdAt),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(updatedAt),
    );
  }

  factory ChatHiveModel.fromJson(Map<String, dynamic> json) {
    List<ChatParticipantHiveModel> participantsList = [];
    if (json['participants'] != null) {
      participantsList = List<ChatParticipantHiveModel>.from(
        (json['participants'] as List<dynamic>).map(
          (x) => ChatParticipantHiveModel.fromJson(x as Map<String, dynamic>),
        ),
      );
    }

    return ChatHiveModel(
      id: json['id'] as int? ?? 0,
      roomId: json['room_id']?.toString() ?? '',
      organisationId: json['organisation_id'] as int? ?? 0,
      name: json['name'] as String?,
      isGroup: json['is_group'] as bool? ?? false,
      createdBy: json['created_by'] as int? ?? 0,
      lastMessage: json['last_message'] as String?,
      lastMessageAt: json['last_message_at'] != null ? DateTime.parse(json['last_message_at']).millisecondsSinceEpoch : null,
      messageCount: json['message_count'] as int? ?? 0,
      participants: participantsList,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']).millisecondsSinceEpoch : DateTime.now().millisecondsSinceEpoch,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']).millisecondsSinceEpoch : DateTime.now().millisecondsSinceEpoch,
    );
  }
}
