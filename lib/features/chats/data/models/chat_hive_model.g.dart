// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChatHiveModelAdapter extends TypeAdapter<ChatHiveModel> {
  @override
  final int typeId = 1;

  @override
  ChatHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChatHiveModel(
      id: fields[0] as int,
      roomId: fields[1] as String,
      organisationId: fields[2] as int,
      name: fields[3] as String?,
      isGroup: fields[4] as bool,
      createdBy: fields[5] as int,
      lastMessage: fields[6] as String?,
      lastMessageAt: fields[7] as int?,
      messageCount: fields[8] as int,
      participants: (fields[9] as List).cast<ChatParticipantHiveModel>(),
      createdAt: fields[10] as int,
      updatedAt: fields[11] as int,
    );
  }

  @override
  void write(BinaryWriter writer, ChatHiveModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.roomId)
      ..writeByte(2)
      ..write(obj.organisationId)
      ..writeByte(3)
      ..write(obj.name)
      ..writeByte(4)
      ..write(obj.isGroup)
      ..writeByte(5)
      ..write(obj.createdBy)
      ..writeByte(6)
      ..write(obj.lastMessage)
      ..writeByte(7)
      ..write(obj.lastMessageAt)
      ..writeByte(8)
      ..write(obj.messageCount)
      ..writeByte(9)
      ..write(obj.participants)
      ..writeByte(10)
      ..write(obj.createdAt)
      ..writeByte(11)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
