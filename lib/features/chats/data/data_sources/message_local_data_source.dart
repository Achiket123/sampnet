import 'package:hive_flutter/hive_flutter.dart';
import 'package:hackathon/features/chats/data/models/message_hive_model.dart';
import 'package:hackathon/features/chats/data/models/message_model.dart';

abstract class MessageLocalDataSource {
  Future<void> saveMessages(String roomId, List<MessageHiveModel> messages);
  Future<List<MessageHiveModel>> getMessages(String roomId);
  Future<void> saveCursor(String roomId, String cursor);
  Future<String?> getCursor(String roomId);
  Future<void> clearCursor(String roomId);
}

class MessageLocalDataSourceImpl implements MessageLocalDataSource {
  final Box<MessageHiveModel> messageBox;
  final Box<String> cursorBox;

  MessageLocalDataSourceImpl({
    required this.messageBox,
    required this.cursorBox,
  });

  @override
  Future<void> saveMessages(String roomId, List<MessageHiveModel> messages) async {
    for (var msg in messages) {
      await messageBox.put('${roomId}_${msg.id}', msg);
    }
  }

  @override
  Future<List<MessageHiveModel>> getMessages(String roomId) async {
    final messages = messageBox.values.where((msg) => msg.roomId == roomId).toList();
    messages.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return messages;
  }

  @override
  Future<void> saveCursor(String roomId, String cursor) async {
    await cursorBox.put(roomId, cursor);
  }

  @override
  Future<String?> getCursor(String roomId) async {
    return cursorBox.get(roomId);
  }

  @override
  Future<void> clearCursor(String roomId) async {
    await cursorBox.delete(roomId);
  }
}
