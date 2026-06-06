import 'package:hive/hive.dart';
import 'package:hackathon/features/chats/domain/entities/chat_participant_entity.dart';

part 'chat_participant_hive_model.g.dart';

@HiveType(typeId: 2)
class ChatParticipantHiveModel extends HiveObject {
  @HiveField(0)
  final int chatId;

  @HiveField(1)
  final int userId;

  @HiveField(2)
  final int unreadCount;

  @HiveField(3)
  final int lastReadMessageId;

  @HiveField(4)
  final int joinedAt;

  @HiveField(5)
  final String? firstName;

  @HiveField(6)
  final String? lastName;

  @HiveField(7)
  final String? avatarUrl;

  ChatParticipantHiveModel({
    required this.chatId,
    required this.userId,
    required this.unreadCount,
    required this.lastReadMessageId,
    required this.joinedAt,
    this.firstName,
    this.lastName,
    this.avatarUrl,
  });

  factory ChatParticipantHiveModel.fromEntity(ChatParticipantEntity e) {
    return ChatParticipantHiveModel(
      chatId: e.chatId,
      userId: e.userId,
      unreadCount: e.unreadCount,
      lastReadMessageId: e.lastReadMessageId,
      joinedAt: e.joinedAt.millisecondsSinceEpoch,
      firstName: e.firstName,
      lastName: e.lastName,
      avatarUrl: e.avatarUrl,
    );
  }

  ChatParticipantEntity toEntity() {
    return ChatParticipantEntity(
      chatId: chatId,
      userId: userId,
      unreadCount: unreadCount,
      lastReadMessageId: lastReadMessageId,
      joinedAt: DateTime.fromMillisecondsSinceEpoch(joinedAt),
      firstName: firstName,
      lastName: lastName,
      avatarUrl: avatarUrl,
    );
  }

  factory ChatParticipantHiveModel.fromJson(Map<String, dynamic> json) {
    return ChatParticipantHiveModel(
      chatId: json['chat_id'] as int? ?? 0,
      userId: int.tryParse(json['user_id']?.toString() ?? '0') ?? 0,
      unreadCount: json['unread_count'] as int? ?? 0,
      lastReadMessageId: json['last_read_message_id'] as int? ?? 0,
      joinedAt: json['joined_at'] != null ? DateTime.parse(json['joined_at']).millisecondsSinceEpoch : DateTime.now().millisecondsSinceEpoch,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      avatarUrl: json['avatar_url'] as String?,
    );
  }
}
