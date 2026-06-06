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
import 'package:hackathon/services/websocket_service.dart';

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

    Future<List<ChatModel>> fetchChats() async {
      try {
        final response = await apiClient.get(
            '${ApiConstants.getChats}?organisation_id=${getIt<user.User>().organisation!.id}');
        if (response.statusCode == 200) {
          final dynamic decoded = jsonDecode(response.body);
          final List<dynamic> data = decoded is Map && decoded.containsKey('chats') ? decoded['chats'] : [];
          final List<ChatModel> chatList = data.map<ChatModel>((doc) => ChatModel.fromMap(doc)).toList();
          chatList.sort((a, b) {
            final aTime = a.lastMessageAt;
            final bTime = b.lastMessageAt;
            if (aTime == null && bTime == null) return 0;
            if (aTime == null) return 1;
            if (bTime == null) return -1;
            return bTime.compareTo(aTime);
          });
          return chatList;
        }
        return <ChatModel>[];
      } catch (e, stack) {
        debugPrint("Error fetching chats: $e\n$stack");
        return <ChatModel>[];
      }
    }

    // Yield initial fetch
    yield await fetchChats();

    // Yield on websocket messages
    final websocketService = getIt<WebsocketService>();
    await for (final _ in websocketService.messageStream) {
      yield await fetchChats();
    }
  }

  @override
  Future<Either<ErrorModel, ChatModel>> createChat(ChatParams chat) async {
    try {
      final targetUserId = chat.id ?? 0;
      
      final callData = {
        'id': targetUserId,
        'first_name': chat.firstName,
        'last_name': chat.lastName,
        'email': chat.email,
        'organisation_id': getIt<user.User>().organisation!.id,
        'in_call': false,
        'offer': null,
      };

      final res = await apiClient.get('${ApiConstants.getChats}/dm/$targetUserId');
      await apiClient.post(ApiConstants.upsertCall, body: callData);
      
      final data = jsonDecode(res.body)['chat'];
      return right(ChatModel.fromMap(data));
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
            .map((doc) => ChatModel.fromMap(doc))
            .toList();
        chatList.sort((a, b) {
          final aTime = a.lastMessageAt;
          final bTime = b.lastMessageAt;
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
