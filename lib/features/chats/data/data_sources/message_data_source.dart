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

abstract class MessageDataSource {
  Stream<List<MessageModel>> getMessages(String id);
  Future<Either<ErrorModel, MessageModel>> sendMessage(MessageParams message);
}

class MessageDataSourceImpl implements MessageDataSource {
  final ApiClient apiClient;
  MessageDataSourceImpl({required this.apiClient});

  @override
  Stream<List<MessageModel>> getMessages(String id) async* {
    yield* Stream.periodic(const Duration(seconds: 3)).asyncMap<List<MessageModel>>((_) async {
      try {
        final response = await apiClient.get(ApiConstants.getMessages(id));
        if (response.statusCode == 200) {
          final decoded = jsonDecode(response.body);
          final List<dynamic> data = decoded is Map && decoded.containsKey('messages')
              ? (decoded['messages'] ?? [])
              : (decoded is List ? decoded : []);
          final List<MessageModel> msgList = data.map((doc) => MessageModel.fromMap(doc)).toList();
          msgList.sort((a, b) => a.timeStamp.compareTo(b.timeStamp));
          return msgList;
        }
        return <MessageModel>[];
      } catch (e) {
        debugPrint(e.toString());
        return <MessageModel>[];
      }
    });
  }

  @override
  Future<Either<ErrorModel, MessageModel>> sendMessage(
      MessageParams message) async {
    try {
      final data = {
        "sender_id": message.senderId,
        "receiver_id": message.receiverId,
        "message": message.message,
        "time_stamp": message.timeStamp.toUtc().toIso8601String()
      };

      final response =
          await apiClient.post(ApiConstants.sendMessage, body: data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = jsonDecode(response.body);
        final Map<String, dynamic> msgData = decoded is Map && decoded.containsKey('message')
            ? decoded['message']
            : decoded;
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
