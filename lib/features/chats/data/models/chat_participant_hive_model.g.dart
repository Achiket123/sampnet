// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_participant_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChatParticipantHiveModelAdapter
    extends TypeAdapter<ChatParticipantHiveModel> {
  @override
  final int typeId = 2;

  @override
  ChatParticipantHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChatParticipantHiveModel(
      chatId: fields[0] as int,
      userId: fields[1] as int,
      unreadCount: fields[2] as int,
      lastReadMessageId: fields[3] as int,
      joinedAt: fields[4] as int,
      firstName: fields[5] as String?,
      lastName: fields[6] as String?,
      avatarUrl: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ChatParticipantHiveModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.chatId)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.unreadCount)
      ..writeByte(3)
      ..write(obj.lastReadMessageId)
      ..writeByte(4)
      ..write(obj.joinedAt)
      ..writeByte(5)
      ..write(obj.firstName)
      ..writeByte(6)
      ..write(obj.lastName)
      ..writeByte(7)
      ..write(obj.avatarUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatParticipantHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
