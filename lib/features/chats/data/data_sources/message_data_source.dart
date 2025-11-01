import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hackathon/features/chats/data/models/message_model.dart';
import 'package:hackathon/features/chats/domain/use_cases/message_usecase.dart';
import 'package:hackathon/globals/constants/user.dart' as user;
import 'package:hackathon/globals/error_handling/error_model.dart';
import 'package:hackathon/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class MessageDataSource {
  Stream getMessages(String id);
  Future<Either<ErrorModel, MessageModel>> sendMessage(MessageParams message);
}

class MessageDataSourceImpl implements MessageDataSource {
  @override
  Stream getMessages(String id) async* {
    final ids = [id, user.User.user.id.toString()];
    ids.sort();
    final id0 = ids.join('-');
    await supabase
        .from('messages')
        .update({"is_seen": true})
        .eq('room_id', id0)
        .eq("receiver_id", user.User.user.id.toString());

    yield* supabase
        .from('messages')
        .stream(primaryKey: ['id'])
        .eq('room_id', id0)
        .order('time_stamp', ascending: true);
  }

  @override
  Future<Either<ErrorModel, MessageModel>> sendMessage(
      MessageParams message) async {
    try {
      final ids = [message.receiverId, message.senderId];
      ids.sort();
      final id = ids.join('-');

      final data = message.toMap();
      data.addAll({"room_id": id});
      supabase.rpc('increment_message_count',
          params: {'_id': message.receiverId}).ignore();
      // debugPrint(_.toString(), );
      supabase
          .from("chats")
          .update({
            "last_message": message.message,
            "last_message_timestamp":
                message.timeStamp.toUtc().toIso8601String(),
          })
          .eq("id", message.receiverId)
          .ignore();
      // debugPrint(_mess.toString(), );
      final response = await supabase.from('messages').insert(data).select();
      return right(MessageModel.fromMap(response.first));
    } catch (e) {
      debugPrint(
        e.toString(),
      );
      return left(ErrorModel(message: e.toString()));
    }
  }
}
