import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hackathon/features/chats/data/models/message_model.dart';
import 'package:hackathon/features/chats/domain/use_cases/message_usecase.dart';
import 'package:hackathon/globals/constants/api_end_points.dart';
import 'package:hackathon/globals/constants/user.dart' as user;
import 'package:hackathon/globals/error_handling/error_model.dart';
import 'package:hackathon/services/api_client.dart';

class MessageCursorPage {
  final List<MessageModel> messages;
  final String nextCursor;
  final bool hasMore;

  MessageCursorPage({
    required this.messages,
    required this.nextCursor,
    required this.hasMore,
  });
}

abstract class MessageDataSource {
  Future<MessageCursorPage> getMessages(String id, {String? cursor, int limit = 30});
  Future<Either<ErrorModel, MessageModel>> sendMessage(MessageParams message);
}

class MessageDataSourceImpl implements MessageDataSource {
  final ApiClient apiClient;
  MessageDataSourceImpl({required this.apiClient});

  @override
  Future<MessageCursorPage> getMessages(String id, {String? cursor, int limit = 30}) async {
    try {
      String url = '${ApiConstants.getMessages(id)}?limit=$limit';
      if (cursor != null && cursor.isNotEmpty) {
        url += '&cursor=${Uri.encodeComponent(cursor)}';
      }
      final response = await apiClient.get(url);
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final List<dynamic> data = decoded is Map && decoded.containsKey('messages')
            ? (decoded['messages'] ?? [])
            : (decoded is List ? decoded : []);
        final List<MessageModel> msgList = data.map((doc) => MessageModel.fromMap(doc)).toList();
        
        String nextCursor = '';
        bool hasMore = false;
        if (decoded is Map) {
          nextCursor = decoded['next_cursor'] ?? '';
          hasMore = decoded['has_more'] ?? false;
        }

        return MessageCursorPage(
          messages: msgList,
          nextCursor: nextCursor,
          hasMore: hasMore,
        );
      }
      return MessageCursorPage(messages: [], nextCursor: '', hasMore: false);
    } catch (e) {
      debugPrint(e.toString());
      return MessageCursorPage(messages: [], nextCursor: '', hasMore: false);
    }
  }

  @override
  Future<Either<ErrorModel, MessageModel>> sendMessage(
      MessageParams message) async {
    try {
      final data = {
        "room_id": message.roomId,
        "receiver_id": message.receiverId,
        "message": message.message,
        "message_type": "text",
      };
      
      debugPrint("SENDING MESSAGE PAYLOAD: $data");

      final response =
          await apiClient.post(ApiConstants.sendMessage, body: data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> msgData = jsonDecode(response.body);
        return right(MessageModel.fromMap(msgData));
      } else {
        return left(ErrorModel(message: 'Failed to send message'));
      }
    } catch (e) {
      debugPrint(e.toString());
      return left(ErrorModel(message: e.toString()));
    }
  }
}
