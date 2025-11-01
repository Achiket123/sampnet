import 'package:fpdart/fpdart.dart';
import 'package:hackathon/features/chats/domain/entities/message_entity.dart';
import 'package:hackathon/features/chats/domain/use_cases/message_usecase.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';

abstract class MessageRepository {
   Stream getMessages(String id);
  Future<Either<ErrorModel, MessageEntity>> sendMessage(MessageParams message);

}