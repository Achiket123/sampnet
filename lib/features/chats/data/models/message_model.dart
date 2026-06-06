import 'package:hackathon/dependency_injection.g.dart';
import 'package:hackathon/features/chats/domain/entities/message_entity.dart';
import 'package:hackathon/globals/constants/user.dart';

class MessageModel extends MessageEntity {
  const MessageModel({
    required super.id,
    required super.roomId,
    required super.senderId,
    required super.receiverId,
    required super.organisationId,
    required super.message,
    required super.messageType,
    super.fileUrl,
    super.fileName,
    super.fileSize,
    required super.isSeen,
    required super.isDeleted,
    super.replyToId,
    required super.createdAt,
    required super.updatedAt,
    required super.isSender,
    required super.senderName,
  });

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    final senderIdStr = map['sender_id']?.toString() ?? '';
    final currentUserIdStr = getIt<User>().user?.id.toString() ?? '';
    final isSenderCalculated = senderIdStr.isNotEmpty && senderIdStr == currentUserIdStr;

    return MessageModel(
      id: map['id'] as int,
      roomId: map['room_id']?.toString() ?? '',
      senderId: senderIdStr,
      receiverId: map['receiver_id']?.toString() ?? '',
      organisationId: map['organisation_id'] as int? ?? 0,
      message: map['message'] ?? '',
      messageType: map['message_type'] ?? 'text',
      fileUrl: map['file_url'],
      fileName: map['file_name'],
      fileSize: map['file_size'] as int?,
      isSeen: map['is_seen'] as bool? ?? false,
      isDeleted: map['is_deleted'] as bool? ?? false,
      replyToId: map['reply_to_id'] as int?,
      createdAt: map['created_at'] != null ? DateTime.parse(map['created_at']) : DateTime.now(),
      updatedAt: map['updated_at'] != null ? DateTime.parse(map['updated_at']) : DateTime.now(),
      isSender: isSenderCalculated,
      senderName: map['sender_first_name']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'room_id': roomId,
      'sender_id': senderId,
      'receiver_id': receiverId,
      'organisation_id': organisationId,
      'message': message,
      'message_type': messageType,
      'file_url': fileUrl,
      'file_name': fileName,
      'file_size': fileSize,
      'is_seen': isSeen,
      'is_deleted': isDeleted,
      'reply_to_id': replyToId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
