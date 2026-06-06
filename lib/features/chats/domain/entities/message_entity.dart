import 'package:equatable/equatable.dart';

class MessageEntity extends Equatable {
  final int id;
  final String roomId;
  final String senderId;
  final String receiverId;
  final int organisationId;
  final String message;
  final String messageType;
  final String? fileUrl;
  final String? fileName;
  final int? fileSize;
  final bool isSeen;
  final bool isDeleted;
  final int? replyToId;
  final Map<String, dynamic>? replyToPreview;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Local properties
  final bool isSender;
  final String senderName;
  final String? senderAvatarUrl;
  final String? optimisticId;
  final bool isOptimistic;

  const MessageEntity({
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

  @override
  List<Object?> get props => [
        id,
        roomId,
        senderId,
        receiverId,
        organisationId,
        message,
        messageType,
        fileUrl,
        fileName,
        fileSize,
        isSeen,
        isDeleted,
        replyToId,
        replyToPreview,
        createdAt,
        updatedAt,
        isSender,
        senderName,
        senderAvatarUrl,
        optimisticId,
        isOptimistic,
      ];
}
