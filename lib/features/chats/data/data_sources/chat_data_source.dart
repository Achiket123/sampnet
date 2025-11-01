import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hackathon/features/chats/data/models/chat_model.dart';
import 'package:hackathon/features/chats/domain/use_cases/chat_usecase.dart';
import 'package:hackathon/globals/constants/user.dart' as user;
import 'package:hackathon/globals/error_handling/error_model.dart';
import 'package:hackathon/main.dart';

abstract class ChatDataSource {
  Stream getChats();
  Future<Either<ErrorModel, ChatModel>> createChat(ChatParams chat);
  Future<Either<ErrorModel, List<ChatModel>>> getChat();
}

class ChatDataSourceImpl implements ChatDataSource {
  @override
  Stream getChats() async* {
    debugPrint(
      "Chat data source called",
    );

    final data = await supabase
        .from('messages')
        .select('is_seen')
        .eq('receiver_id', user.User.user.id)
        .eq("is_seen", false)
        .count();
    debugPrint(
      data.toString(),
    );

    yield* supabase
        .from('chats')
        .stream(primaryKey: ['id'])
        .eq('organisation_id', user.User.organisation.id!)
        .order('last_message_timestamp', ascending: false);
  }

  @override
  Future<Either<ErrorModel, ChatModel>> createChat(ChatParams chat) async {
    try {
      final data = {
        'id': user.User.user.id,
        'first_name': chat.firstName,
        'last_name': chat.lastName,
        'last_message_timestamp':
            chat.lastMessageTimestamp?.toUtc().toIso8601String(),
        'number_of_message': 0,
        'email': chat.email,
        'organisation_id': user.User.organisation.id
      };
      supabase.from('chats').insert(data).ignore();
      supabase.from('calls').insert({
        'id': user.User.user.id,
        'first_name': chat.firstName,
        'last_name': chat.lastName,
        'organisation_id': user.User.organisation.id,
        'email': chat.email,
        'in_call': false,
        'last_call': null,
        'offer': null,
      }).ignore();
      return right(ChatModel.fromMap(data));
    } catch (e) {
      debugPrint(
        e.toString(),
      );
      return left(ErrorModel(message: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, List<ChatModel>>> getChat() async {
    try {
      // debugPrint("Chat data source called", );

      final response = await supabase
          .from('chats')
          .select()
          .filter("organisation_id", "eq", user.User.organisation.id)
          .order('last_message_timestamp', ascending: false);
      debugPrint(
        response.toString(),
      );
      return right(response
          .where((doc) => doc['id'].toString() != user.User.user.id.toString())
          .map((doc) => ChatModel.fromMap(doc))
          .toList());
    } catch (e) {
      print(e);
      return left(ErrorModel(message: e.toString()));
    }
  }
}
