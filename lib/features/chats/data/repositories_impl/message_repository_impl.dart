import 'package:fpdart/src/either.dart';
import 'package:hackathon/features/chats/data/data_sources/message_data_source.dart';
import 'package:hackathon/features/chats/domain/entities/message_entity.dart';
import 'package:hackathon/features/chats/domain/repositories/message_repository.dart';
import 'package:hackathon/features/chats/domain/use_cases/message_usecase.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';

class MessageRepositoryImpl implements MessageRepository{
  final MessageDataSource messageDataSource;

  MessageRepositoryImpl({required this.messageDataSource});
  @override
  Stream<List<MessageEntity>> getMessages(String id) => messageDataSource.getMessages(id);


  @override
  Future<Either<ErrorModel, MessageEntity>> sendMessage(MessageParams message) => messageDataSource.sendMessage(message);
}