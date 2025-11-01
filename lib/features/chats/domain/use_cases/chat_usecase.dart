
import 'package:fpdart/fpdart.dart';
import 'package:hackathon/features/chats/data/models/chat_model.dart';
import 'package:hackathon/features/chats/domain/repositories/chat_repository.dart';
import 'package:hackathon/globals/constants/usecase.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';

class StreamChatUsecase implements StreamUsecase<Stream, Null> {
  final ChatRepository chatRepository;

  StreamChatUsecase({required this.chatRepository});
  @override
    Stream  call(Null params) => chatRepository.getChats();
}

class CreateChatUsecase implements Usecase<ChatModel, ChatParams> {
  final ChatRepository chatRepository;

  CreateChatUsecase({required this.chatRepository});
  @override
  Future<Either<ErrorModel, ChatModel>> call(ChatParams params) =>
      chatRepository.createChat(params);
}


class GetChatUsecase implements Usecase<List<ChatModel>, Null> {
  final ChatRepository chatRepository;

  GetChatUsecase({required this.chatRepository});  
  @override
  Future<Either<ErrorModel, List<ChatModel>>> call(Null params) =>
      chatRepository.getChat();
}

class ChatParams {
  final String firstName;
  final String lastName;
  final DateTime? lastMessageTimestamp;
  final int? numberOfMessage;
  final   String email;

  ChatParams(
      {required this.firstName,
      required this.lastName,
      this.lastMessageTimestamp,
      this.numberOfMessage= 0,
      required this.email});
}
