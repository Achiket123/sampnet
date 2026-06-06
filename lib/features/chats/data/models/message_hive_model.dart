import 'package:hive/hive.dart';
import 'package:hackathon/features/chats/domain/entities/message_entity.dart';

part 'message_hive_model.g.dart';

@HiveType(typeId: 0)
class MessageHiveModel extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String roomId;

  @HiveField(2)
  final String senderId;

  @HiveField(3)
  final String receiverId;

  @HiveField(4)
  final int organisationId;

  @HiveField(5)
  final String message;

  @HiveField(6)
  final String messageType;

  @HiveField(7)
  final String? fileUrl;

  @HiveField(8)
  final String? fileName;

  @HiveField(9)
  final int? fileSize;

  @HiveField(10)
  final bool isSeen;

  @HiveField(11)
  final bool isDeleted;

  @HiveField(12)
  final int? replyToId;

  @HiveField(13)
  final Map<String, dynamic>? replyToPreview;

  @HiveField(14)
  final int createdAt;

  @HiveField(15)
  final int updatedAt;

  @HiveField(16)
  final bool isSender;

  @HiveField(17)
  final String senderName;

  @HiveField(18)
  final String? senderAvatarUrl;

  @HiveField(19)
  final String? optimisticId;

  @HiveField(20)
  final bool isOptimistic;

  MessageHiveModel({
    required this.id,
    required this.roomId,
    required this.senderId,
    required this.receiverId,
    required this.organisationId,
    required this.message,
    required this.messageType,
    this.fileUrl,
    this.fileName,
    this.fileSize,
    required this.isSeen,
    required this.isDeleted,
    this.replyToId,
    this.replyToPreview,
    required this.createdAt,
    required this.updatedAt,
    required this.isSender,
    required this.senderName,
    this.senderAvatarUrl,
    this.optimisticId,
    this.isOptimistic = false,
  });

  factory MessageHiveModel.fromEntity(MessageEntity e) {
    return MessageHiveModel(
      id: e.id,
      roomId: e.roomId,
      senderId: e.senderId,
      receiverId: e.receiverId,
      organisationId: e.organisationId,
      message: e.message,
      messageType: e.messageType,
      fileUrl: e.fileUrl,
      fileName: e.fileName,
      fileSize: e.fileSize,
      isSeen: e.isSeen,
      isDeleted: e.isDeleted,
      replyToId: e.replyToId,
      replyToPreview: e.replyToPreview,
      createdAt: e.createdAt.millisecondsSinceEpoch,
      updatedAt: e.updatedAt.millisecondsSinceEpoch,
      isSender: e.isSender,
      senderName: e.senderName,
      senderAvatarUrl: e.senderAvatarUrl,
      optimisticId: e.optimisticId,
      isOptimistic: e.isOptimistic,
    );
  }

  MessageEntity toEntity() {
    return MessageEntity(
      id: id,
      roomId: roomId,
      senderId: senderId,
      receiverId: receiverId,
      organisationId: organisationId,
      message: message,
      messageType: messageType,
      fileUrl: fileUrl,
      fileName: fileName,
      fileSize: fileSize,
      isSeen: isSeen,
      isDeleted: isDeleted,
      replyToId: replyToId,
      replyToPreview: replyToPreview,
      createdAt: DateTime.fromMillisecondsSinceEpoch(createdAt),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(updatedAt),
      isSender: isSender,
      senderName: senderName,
      senderAvatarUrl: senderAvatarUrl,
      optimisticId: optimisticId,
      isOptimistic: isOptimistic,
    );
  }

  factory MessageHiveModel.fromJson(Map<String, dynamic> json, String currentUserIdStr) {
    final senderIdStr = json['sender_id']?.toString() ?? '';
    final isSenderCalculated = senderIdStr.isNotEmpty && senderIdStr == currentUserIdStr;

    return MessageHiveModel(
      id: json['id'] as int,
      roomId: json['room_id']?.toString() ?? '',
      senderId: senderIdStr,
      receiverId: json['receiver_id']?.toString() ?? '',
      organisationId: json['organisation_id'] as int? ?? 0,
      message: json['message'] ?? '',
      messageType: json['message_type'] ?? 'text',
      fileUrl: json['file_url'],
      fileName: json['file_name'],
      fileSize: json['file_size'] as int?,
      isSeen: json['is_seen'] as bool? ?? false,
      isDeleted: json['is_deleted'] as bool? ?? false,
      replyToId: json['reply_to_id'] as int?,
      replyToPreview: json['reply_to_preview'] as Map<String, dynamic>?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']).millisecondsSinceEpoch : DateTime.now().millisecondsSinceEpoch,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']).millisecondsSinceEpoch : DateTime.now().millisecondsSinceEpoch,
      isSender: isSenderCalculated,
      senderName: '${json['sender_first_name'] ?? ''} ${json['sender_last_name'] ?? ''}'.trim(),
      senderAvatarUrl: json['sender_avatar_url']?.toString(),
    );
  }
}
