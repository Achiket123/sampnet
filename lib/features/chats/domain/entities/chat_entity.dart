import 'package:equatable/equatable.dart';
import 'package:hackathon/features/chats/domain/entities/chat_participant_entity.dart';

class ChatEntity extends Equatable {
  final int id;
  final String roomId;
  final int organisationId;
  final String? name;
  final bool isGroup;
  final int createdBy;
  final String? lastMessage;
  final DateTime? lastMessageAt;
  final int messageCount;
  final List<ChatParticipantEntity> participants;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ChatEntity({
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

  @override
  List<Object?> get props => [
        id,
        roomId,
        organisationId,
        name,
        isGroup,
        createdBy,
        lastMessage,
        lastMessageAt,
        messageCount,
        participants,
        createdAt,
        updatedAt,
      ];
}
