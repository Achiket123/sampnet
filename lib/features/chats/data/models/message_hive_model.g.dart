// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MessageHiveModelAdapter extends TypeAdapter<MessageHiveModel> {
  @override
  final int typeId = 0;

  @override
  MessageHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MessageHiveModel(
      id: fields[0] as int,
      roomId: fields[1] as String,
      senderId: fields[2] as String,
      receiverId: fields[3] as String,
      organisationId: fields[4] as int,
      message: fields[5] as String,
      messageType: fields[6] as String,
      fileUrl: fields[7] as String?,
      fileName: fields[8] as String?,
      fileSize: fields[9] as int?,
      isSeen: fields[10] as bool,
      isDeleted: fields[11] as bool,
      replyToId: fields[12] as int?,
      replyToPreview: (fields[13] as Map?)?.cast<String, dynamic>(),
      createdAt: fields[14] as int,
      updatedAt: fields[15] as int,
      isSender: fields[16] as bool,
      senderName: fields[17] as String,
      senderAvatarUrl: fields[18] as String?,
      optimisticId: fields[19] as String?,
      isOptimistic: fields[20] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, MessageHiveModel obj) {
    writer
      ..writeByte(21)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.roomId)
      ..writeByte(2)
      ..write(obj.senderId)
      ..writeByte(3)
      ..write(obj.receiverId)
      ..writeByte(4)
      ..write(obj.organisationId)
      ..writeByte(5)
      ..write(obj.message)
      ..writeByte(6)
      ..write(obj.messageType)
      ..writeByte(7)
      ..write(obj.fileUrl)
      ..writeByte(8)
      ..write(obj.fileName)
      ..writeByte(9)
      ..write(obj.fileSize)
      ..writeByte(10)
      ..write(obj.isSeen)
      ..writeByte(11)
      ..write(obj.isDeleted)
      ..writeByte(12)
      ..write(obj.replyToId)
      ..writeByte(13)
      ..write(obj.replyToPreview)
      ..writeByte(14)
      ..write(obj.createdAt)
      ..writeByte(15)
      ..write(obj.updatedAt)
      ..writeByte(16)
      ..write(obj.isSender)
      ..writeByte(17)
      ..write(obj.senderName)
      ..writeByte(18)
      ..write(obj.senderAvatarUrl)
      ..writeByte(19)
      ..write(obj.optimisticId)
      ..writeByte(20)
      ..write(obj.isOptimistic);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
