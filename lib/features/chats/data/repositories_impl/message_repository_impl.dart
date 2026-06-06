import 'package:fpdart/src/either.dart';
import 'package:hackathon/features/chats/data/data_sources/message_data_source.dart';
import 'package:hackathon/features/chats/data/data_sources/message_local_data_source.dart';
import 'package:hackathon/features/chats/data/models/message_hive_model.dart';
import 'package:hackathon/features/chats/domain/entities/message_entity.dart';
import 'package:hackathon/features/chats/domain/repositories/message_repository.dart';
import 'package:hackathon/features/chats/domain/use_cases/message_usecase.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';
import 'package:hackathon/features/chats/data/models/message_model.dart';
import 'package:hackathon/services/websocket_service.dart';
import 'package:hive_flutter/hive_flutter.dart';

class MessageRepositoryImpl implements MessageRepository {
  final MessageDataSource remoteDataSource;
  final MessageLocalDataSource localDataSource;
  final WebsocketService websocketService;
  final Box<MessageHiveModel> messageBox;

  MessageRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.websocketService,
    required this.messageBox,
  }) {
    websocketService.messageStream.listen((data) {
      if (data != null && data is Map<String, dynamic>) {
        final m = MessageModel.fromMap(data);
        final hiveMsg = MessageHiveModel.fromEntity(m);
        localDataSource.saveMessages(m.roomId.toString(), [hiveMsg]);
      }
    });
  }

  @override
  Stream<List<MessageEntity>> getMessages(String id) async* {
    // Yield the initial state from the box
    final initialMessages = messageBox.values.where((msg) => msg.roomId == id).toList();
    initialMessages.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    yield initialMessages.map((m) => m.toEntity()).toList();

    // Watch the local Hive box for changes
    await for (final event in messageBox.watch()) {
      final messages = messageBox.values.where((msg) => msg.roomId == id).toList();
      messages.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      yield messages.map((m) => m.toEntity()).toList();
    }
  }

  Future<void> fetchInitialMessages(String id) async {
    final page = await remoteDataSource.getMessages(id, limit: 30);
    final hiveMessages = page.messages.map((m) => MessageHiveModel.fromEntity(m)).toList();
    await localDataSource.saveMessages(id, hiveMessages);
    if (page.nextCursor.isNotEmpty) {
      await localDataSource.saveCursor(id, page.nextCursor);
    }
  }

  Future<void> loadMoreMessages(String id) async {
    final cursor = await localDataSource.getCursor(id);
    if (cursor == null || cursor.isEmpty) return; // No more messages
    final page = await remoteDataSource.getMessages(id, cursor: cursor, limit: 30);
    final hiveMessages = page.messages.map((m) => MessageHiveModel.fromEntity(m)).toList();
    await localDataSource.saveMessages(id, hiveMessages);
    if (page.nextCursor.isNotEmpty) {
      await localDataSource.saveCursor(id, page.nextCursor);
    } else {
      await localDataSource.clearCursor(id);
    }
  }


  @override
  Future<Either<ErrorModel, MessageEntity>> sendMessage(MessageParams message) async {
    final result = await remoteDataSource.sendMessage(message);
    return result.map((msg) {
      // Save optimistic/confirmed message locally
      final hiveMsg = MessageHiveModel.fromEntity(msg);
      localDataSource.saveMessages(message.receiverId, [hiveMsg]);
      return msg;
    });
  }
}