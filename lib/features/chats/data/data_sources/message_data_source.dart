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
  Stream getMessages(String id);
  Future<Either<ErrorModel, MessageModel>> sendMessage(MessageParams message);
}

class MessageDataSourceImpl implements MessageDataSource {
  final ApiClient apiClient;
  MessageDataSourceImpl({required this.apiClient});

  @override
  Stream getMessages(String id) async* {
    yield* Stream.periodic(const Duration(seconds: 3)).asyncMap((_) async {
      try {
        final response = await apiClient.get(ApiConstants.getMessages(id));
        if (response.statusCode == 200) {
          final List<dynamic> data = jsonDecode(response.body);
          return data.map((doc) => MessageModel.fromMap(doc)).toList()
            ..sort((a, b) => a.timeStamp.compareTo(b.timeStamp));
        }
        return [];
      } catch (e) {
        debugPrint(e.toString());
        return [];
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
        return right(MessageModel.fromMap(jsonDecode(response.body)));
      } else {
        return left(ErrorModel(message: 'Failed to send message'));
      }
    } catch (e) {
      debugPrint(e.toString());
      return left(ErrorModel(message: e.toString()));
    }
  }
}
