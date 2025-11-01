
import 'package:fpdart/fpdart.dart';
import 'package:hackathon/features/chats/data/models/chat_model.dart';
import 'package:hackathon/features/chats/domain/use_cases/chat_usecase.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';

abstract class ChatRepository {
  Stream  getChats();
  Future<Either<ErrorModel, ChatModel>> createChat(ChatParams chat);
   Future<Either<ErrorModel, List<ChatModel>>> getChat();
}
