import 'package:equatable/equatable.dart';

class ChatParticipantEntity extends Equatable {
  final int chatId;
  final int userId;
  final int unreadCount;
  final int lastReadMessageId;
  final DateTime joinedAt;
  final String? firstName;
  final String? lastName;
  final String? avatarUrl;

  const ChatParticipantEntity({
    required this.chatId,
    required this.userId,
    required this.unreadCount,
    required this.lastReadMessageId,
    required this.joinedAt,
    this.firstName,
    this.lastName,
    this.avatarUrl,
  });

  @override
  List<Object?> get props => [
        chatId,
        userId,
        unreadCount,
        lastReadMessageId,
        joinedAt,
        firstName,
        lastName,
        avatarUrl,
      ];
}
