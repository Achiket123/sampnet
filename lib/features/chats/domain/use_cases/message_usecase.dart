import 'package:fpdart/src/either.dart';
import 'package:hackathon/features/chats/domain/entities/message_entity.dart';
import 'package:hackathon/features/chats/domain/repositories/message_repository.dart';
import 'package:hackathon/globals/constants/usecase.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';

class MessageUsecase implements Usecase<MessageEntity,MessageParams > {
  final MessageRepository messageRepository;

  MessageUsecase({required this.messageRepository});
  @override
  Future<Either<ErrorModel, MessageEntity>> call(MessageParams params) {
    return messageRepository.sendMessage(params);
  }
}

class MessageParams {
  final String message;
  final String senderId;
  final String receiverId;
  final String receiverName;
  final String senderName;
  final bool isSender;
  final DateTime timeStamp;
  MessageParams(
      {required this.message,
      required this.senderId,
      required this.receiverId,
      required this.receiverName,
      required this.isSender,
      required this.timeStamp,
      required this.senderName});

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'sender_id': senderId,
      'receiver_id': receiverId,
      'receiver_name': receiverName,
      'sender_name': senderName,
      'is_sender': isSender,
      'time_stamp': timeStamp.toUtc().toIso8601String()
    };
  }
}
