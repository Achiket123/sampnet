import 'package:hackathon/dependency_injection.g.dart';
import 'package:hackathon/features/chats/domain/entities/message_entity.dart';
import 'package:hackathon/globals/constants/user.dart';

class MessageModel extends MessageEntity {
  MessageModel({
    required super.roomId,
    required super.message,
    required super.id,
    required super.senderId,
    required super.receiverId,
    required super.receiverName,
    required super.isSender,
    required super.timeStamp,
    required super.senderName,
  });

  factory MessageModel.fromMap(Map<String, dynamic> json) {
    final senderIdStr = json['sender_id']?.toString() ?? '';
    final currentUserIdStr = getIt<User>().user?.id.toString() ?? '';
    final isSenderCalculated = json['is_sender'] ?? (senderIdStr.isNotEmpty && senderIdStr == currentUserIdStr);

    return MessageModel(
      roomId: json['room_id']?.toString() ?? '',
      message: json['message'] ?? '',
      id: (json['id'] ?? json['ID'] ?? '').toString(),
      senderId: senderIdStr,
      receiverId: json['receiver_id']?.toString() ?? '',
      receiverName: json['receiver_name']?.toString() ?? '',
      isSender: isSenderCalculated,
      timeStamp: json['time_stamp'] != null ? DateTime.parse(json['time_stamp']) : DateTime.now(),
      senderName: json['sender_name']?.toString() ?? '',
    );
  }
}
