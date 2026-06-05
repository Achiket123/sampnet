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
  Stream<List<ChatModel>> getChats();
  Future<Either<ErrorModel, ChatModel>> createChat(ChatParams chat);
  Future<Either<ErrorModel, List<ChatModel>>> getChat();
}

class ChatDataSourceImpl implements ChatDataSource {
  final ApiClient apiClient;
  ChatDataSourceImpl({required this.apiClient});

  @override
  Stream<List<ChatModel>> getChats() async* {
    debugPrint("Chat data source called");

    yield* Stream.periodic(const Duration(seconds: 3)).asyncMap<List<ChatModel>>((_) async {
      try {
        final response = await apiClient.get(
            '${ApiConstants.getChats}?organisation_id=${getIt<user.User>().organisation!.id}');
        if (response.statusCode == 200) {
          debugPrint(response.body);
          final List<dynamic> data = jsonDecode(response.body)['chats'];
          debugPrint(data.toString());
          final List<ChatModel> chatList = data.map<ChatModel>((doc) => ChatModel.fromMap(doc)).toList();
          chatList.sort((a, b) {
            final aTime = a.lastMessageTimestamp;
            final bTime = b.lastMessageTimestamp;
            if (aTime == null && bTime == null) return 0;
            if (aTime == null) return 1;
            if (bTime == null) return -1;
            return bTime.compareTo(aTime);
          });
          return chatList;
        }
        return <ChatModel>[];
      } catch (e) {
        debugPrint(e.toString());
        return <ChatModel>[];
      }
    });
  }

  @override
  Future<Either<ErrorModel, ChatModel>> createChat(ChatParams chat) async {
    try {
      final chatId = chat.id ?? getIt<user.User>().user!.id;
      final chatData = {
        'ID': chatId,
        'first_name': chat.firstName,
        'last_name': chat.lastName,
        'email': chat.email,
        'organisation_id': getIt<user.User>().organisation!.id,
        'last_message_timestamp':
            (chat.lastMessageTimestamp ?? DateTime.now()).toUtc().toIso8601String(),
        'number_of_message': 0,
      };

      final callData = {
        'id': chatId,
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
        debugPrint("HEHE");
        debugPrint(response.body);
        final List<dynamic> data = jsonDecode(response.body)["chats"];
        final List<ChatModel> chatList = data
            .where((doc) =>
                doc['id'].toString() != getIt<user.User>().user!.id.toString())
            .map((doc) => ChatModel.fromMap(doc))
            .toList();
        chatList.sort((a, b) {
          final aTime = a.lastMessageTimestamp;
          final bTime = b.lastMessageTimestamp;
          if (aTime == null && bTime == null) return 0;
          if (aTime == null) return 1;
          if (bTime == null) return -1;
          return bTime.compareTo(aTime);
        });
        return right(chatList);
      } else {
        return left(ErrorModel(message: 'Failed to load chats'));
      }
    } catch (e) {
      debugPrint(e.toString());
      return left(ErrorModel(message: e.toString()));
    }
  }
}
