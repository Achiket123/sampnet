
import 'package:fpdart/fpdart.dart';
import 'package:hackathon/features/chats/domain/entities/chat_entity.dart';
import 'package:hackathon/features/chats/domain/use_cases/chat_usecase.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';

abstract class ChatRepository {
  Stream<List<ChatEntity>> getChats();
  Future<Either<ErrorModel, ChatEntity>> createChat(ChatParams chat);
  Future<Either<ErrorModel, List<ChatEntity>>> getChat();
}
