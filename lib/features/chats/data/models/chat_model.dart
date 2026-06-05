// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:hackathon/features/chats/domain/entities/chat_entity.dart';

class ChatModel extends ChatEntity {
  ChatModel({
    required super.id,
    required super.firstName,
    required super.lastName,
    super.lastMessageTimestamp,
    required super.email,
    super.lastMessage,
    required super.numberOfMessage,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      "ID": id,
      "first_name": firstName,
      "last_name": lastName,
      "email": email,
      "last_message_timestamp": lastMessageTimestamp?.toUtc().toIso8601String(),
      "number_of_message": numberOfMessage
    };
  }

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    print(map);
    return ChatModel(
        id: map["id"] as int,
        email: map["email"] as String,
        firstName: map["first_name"] as String,
        lastName: map["last_name"] as String,
        lastMessageTimestamp: map["last_message_timestamp"] != null
            ? DateTime.parse(map["last_message_timestamp"])
            : null,
        numberOfMessage: map["number_of_message"] as int,
        lastMessage: map["last_message"] as String?);
  }
  factory ChatModel.fromEntity(ChatEntity entity) {
    return ChatModel(
        id: entity.id,
        email: entity.email,
        firstName: entity.firstName,
        lastName: entity.lastName,
        lastMessageTimestamp: entity.lastMessageTimestamp,
        numberOfMessage: entity.numberOfMessage);
  }
}

class ChatGroupModel extends ChatGroupEntity {
  ChatGroupModel(
      {required super.id,
      required super.firstName,
      required super.lastName,
      required super.lastMessageTimestamp,
      required super.numberOfMessage,
      required super.image,
      required super.members});
  @override
  Map<String, dynamic> toMap() {
    return {
      "ID": id,
      "first_name": firstName,
      "last_name": lastName,
      "last_message_timestamp": lastMessageTimestamp,
      "number_of_message": numberOfMessage,
      "image": image,
      "members": members
    };
  }
}
