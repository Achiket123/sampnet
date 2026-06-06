import 'package:fpdart/fpdart.dart';
import 'package:hackathon/features/chats/data/data_sources/chat_data_source.dart';
import 'package:hackathon/features/chats/domain/entities/chat_entity.dart';
import 'package:hackathon/features/chats/domain/repositories/chat_repository.dart';
import 'package:hackathon/features/chats/domain/use_cases/chat_usecase.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatDataSource dataSource;
  ChatRepositoryImpl({required this.dataSource});
  
  @override
  Stream<List<ChatEntity>> getChats() => dataSource.getChats();

  @override
  Future<Either<ErrorModel, ChatEntity>> createChat(ChatParams chat) =>
      dataSource.createChat(chat);
    
  @override
  Future<Either<ErrorModel, List<ChatEntity>>> getChat() =>
      dataSource.getChat();
}
