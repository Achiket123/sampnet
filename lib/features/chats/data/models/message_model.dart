import 'package:hackathon/features/chats/domain/entities/message_entity.dart';

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
    return MessageModel(
      roomId: json['room_id'].toString(),
      message: json['message'],
      id: json['id'].toString(),
      senderId: json['sender_id'].toString(),
      receiverId: json['receiver_id'].toString(),
      receiverName: json['receiver_name'].toString(),
      isSender: json['is_sender'],
      timeStamp: DateTime.parse(json['time_stamp']),
      senderName: json['sender_name'].toString(),
    );
  }
}
