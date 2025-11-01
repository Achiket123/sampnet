import 'package:equatable/equatable.dart';

class ChatEntity extends Equatable {
  final int id;
  final String firstName;
  final String lastName;
  final DateTime? lastMessageTimestamp;
  final String? lastMessage;
  final int numberOfMessage;
  final String? email;

  const ChatEntity(
      {required this.id,
      required this.firstName,
      required this.lastName,
      this.lastMessage,
      this.lastMessageTimestamp,
     this.email,
      required this.numberOfMessage});

  @override
  List<Object?> get props => [
        id,
      ];

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "first_name": firstName,
      "last_name": lastName,
      "last_message": lastMessage,
      "email": email,
      "last_message_timestamp": lastMessageTimestamp!.toUtc().toIso8601String(),
      "number_of_message": numberOfMessage
    };
  }
}

class ChatGroupEntity extends ChatEntity {
  final List<String> members;
  final int image;
  const ChatGroupEntity(
      {required super.id,

      required super.numberOfMessage,
      required super.firstName,
      required super.lastName,
      required this.image,
      required this.members,
      required super.lastMessageTimestamp});
}
