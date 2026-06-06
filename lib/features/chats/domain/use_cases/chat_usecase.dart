
import 'package:fpdart/fpdart.dart';
import 'package:hackathon/features/chats/domain/entities/chat_entity.dart';
import 'package:hackathon/features/chats/domain/repositories/chat_repository.dart';
import 'package:hackathon/globals/constants/usecase.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';

class StreamChatUsecase implements StreamUsecase<Stream<List<ChatEntity>>, Null> {
  final ChatRepository chatRepository;

  StreamChatUsecase({required this.chatRepository});
  @override
  Stream<List<ChatEntity>> call(Null params) => chatRepository.getChats();
}

class CreateChatUsecase implements Usecase<ChatEntity, ChatParams> {
  final ChatRepository chatRepository;

  CreateChatUsecase({required this.chatRepository});
  @override
  Future<Either<ErrorModel, ChatEntity>> call(ChatParams params) =>
      chatRepository.createChat(params);
}


class GetChatUsecase implements Usecase<List<ChatEntity>, Null> {
  final ChatRepository chatRepository;

  GetChatUsecase({required this.chatRepository});  
  @override
  Future<Either<ErrorModel, List<ChatEntity>>> call(Null params) =>
      chatRepository.getChat();
}

class ChatParams {
  final int? id;
  final String firstName;
  final String lastName;
  final DateTime? lastMessageTimestamp;
  final int? numberOfMessage;
  final String email;

  ChatParams(
      {this.id,
      required this.firstName,
      required this.lastName,
      this.lastMessageTimestamp,
      this.numberOfMessage = 0,
      required this.email});
}
