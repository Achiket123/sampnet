import 'package:hackathon/features/chats/domain/entities/chat_entity.dart';
import 'package:hackathon/features/chats/domain/entities/chat_participant_entity.dart';

class ChatParticipantModel extends ChatParticipantEntity {
  const ChatParticipantModel({
    required super.chatId,
    required super.userId,
    required super.unreadCount,
    required super.lastReadMessageId,
    required super.joinedAt,
    super.firstName,
    super.lastName,
    super.avatarUrl,
  });

  factory ChatParticipantModel.fromMap(Map<String, dynamic> map) {
    return ChatParticipantModel(
      chatId: map['chat_id'] as int,
      userId: map['user_id'] as int,
      unreadCount: map['unread_count'] as int? ?? 0,
      lastReadMessageId: map['last_read_message_id'] as int? ?? 0,
      joinedAt: DateTime.parse(map['joined_at'] as String),
      firstName: map['first_name'] as String?,
      lastName: map['last_name'] as String?,
      avatarUrl: map['avatar_url'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'chat_id': chatId,
      'user_id': userId,
      'unread_count': unreadCount,
      'last_read_message_id': lastReadMessageId,
      'joined_at': joinedAt.toIso8601String(),
      'first_name': firstName,
      'last_name': lastName,
      'avatar_url': avatarUrl,
    };
  }
}

class ChatModel extends ChatEntity {
  const ChatModel({
    required super.id,
    required super.roomId,
    required super.organisationId,
    super.name,
    required super.isGroup,
    required super.createdBy,
    super.lastMessage,
    super.lastMessageAt,
    required super.messageCount,
    required super.participants,
    required super.createdAt,
    required super.updatedAt,
  });

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    List<ChatParticipantModel> participantsList = [];
    if (map['participants'] != null) {
      participantsList = List<ChatParticipantModel>.from(
        (map['participants'] as List<dynamic>).map(
          (x) => ChatParticipantModel.fromMap(x as Map<String, dynamic>),
        ),
      );
    }

    return ChatModel(
      id: map['id'] as int,
      roomId: map['room_id'] as String,
      organisationId: map['organisation_id'] as int,
      name: map['name'] as String?,
      isGroup: map['is_group'] as bool? ?? false,
      createdBy: map['created_by'] as int? ?? 0,
      lastMessage: map['last_message'] as String?,
      lastMessageAt: map['last_message_at'] != null ? DateTime.parse(map['last_message_at']) : null,
      messageCount: map['message_count'] as int? ?? 0,
      participants: participantsList,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'room_id': roomId,
      'organisation_id': organisationId,
      'name': name,
      'is_group': isGroup,
      'created_by': createdBy,
      'last_message': lastMessage,
      'last_message_at': lastMessageAt?.toIso8601String(),
      'message_count': messageCount,
      'participants': participants.map((x) => (x as ChatParticipantModel).toMap()).toList(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
