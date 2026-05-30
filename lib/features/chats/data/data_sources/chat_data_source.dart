import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hackathon/dependency_injection.g.dart';
import 'package:hackathon/features/chats/data/models/chat_model.dart';
import 'package:hackathon/features/chats/domain/use_cases/chat_usecase.dart';
import 'package:hackathon/globals/constants/api_end_points.dart';
import 'package:hackathon/globals/constants/user.dart' as user;
import 'package:hackathon/globals/error_handling/error_model.dart';
import 'package:hackathon/services/api_client.dart';

abstract class ChatDataSource {
  Stream getChats();
  Future<Either<ErrorModel, ChatModel>> createChat(ChatParams chat);
  Future<Either<ErrorModel, List<ChatModel>>> getChat();
}

class ChatDataSourceImpl implements ChatDataSource {
  final ApiClient apiClient;
  ChatDataSourceImpl({required this.apiClient});

  @override
  Stream getChats() async* {
    debugPrint("Chat data source called");

    yield* Stream.periodic(const Duration(seconds: 3)).asyncMap((_) async {
      try {
        final response = await apiClient.get(
            '${ApiConstants.getChats}?organisation_id=${getIt<user.User>().organisation!.id}');
        if (response.statusCode == 200) {
          debugPrint(response.body);
          final List<dynamic> data = jsonDecode(response.body)['chats'];
          return data.map((doc) => ChatModel.fromMap(doc)).toList()
            ..sort((a, b) =>
                b.lastMessageTimestamp!.compareTo(a.lastMessageTimestamp!));
        }
        return [];
      } catch (e) {
        debugPrint(e.toString());
        return [];
      }
    });
  }

  @override
  Future<Either<ErrorModel, ChatModel>> createChat(ChatParams chat) async {
    try {
      final chatData = {
        'ID': getIt<user.User>().user!.id,
        'first_name': chat.firstName,
        'last_name': chat.lastName,
        'email': chat.email,
        'organisation_id': getIt<user.User>().organisation!.id,
        'last_message_timestamp':
            chat.lastMessageTimestamp?.toUtc().toIso8601String(),
        'number_of_message': 0,
      };

      final callData = {
        'id': getIt<user.User>().user!.id,
        'first_name': chat.firstName,
        'last_name': chat.lastName,
        'email': chat.email,
        'organisation_id': getIt<user.User>().organisation!.id,
        'in_call': false,
        'offer': null,
      };

      await apiClient.post(ApiConstants.createChat, body: chatData);
      await apiClient.post(ApiConstants.upsertCall, body: callData);

      return right(ChatModel.fromMap(chatData));
    } catch (e) {
      debugPrint(e.toString());
      return left(ErrorModel(message: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, List<ChatModel>>> getChat() async {
    try {
      final response = await apiClient.get(
          '${ApiConstants.getChats}?organisation_id=${getIt<user.User>().organisation!.id}');
      if (response.statusCode == 200) {
        debugPrint(response.body);
        final List<dynamic> data = jsonDecode(response.body);
        return right(data
            .where((doc) =>
                doc['id'].toString() != getIt<user.User>().user!.id.toString())
            .map((doc) => ChatModel.fromMap(doc))
            .toList()
          ..sort((a, b) =>
              b.lastMessageTimestamp!.compareTo(a.lastMessageTimestamp!)));
      } else {
        return left(ErrorModel(message: 'Failed to load chats'));
      }
    } catch (e) {
      debugPrint(e.toString());
      return left(ErrorModel(message: e.toString()));
    }
  }
}
