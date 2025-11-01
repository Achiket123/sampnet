import 'package:equatable/equatable.dart';

abstract class MessageEntity {
  final String _roomId;
  final String _id;
  final String _senderId;
  final String _receiverId;
  final String _receiverName;
  final bool _isSender;
  final DateTime _timeStamp;
  final String _senderName;
  final String _message;
  MessageEntity(
      {
        required String roomId,
        required String id,
      required String senderId,
      required String receiverId,
      required String receiverName,
      required bool isSender,
      required DateTime timeStamp,
      required String senderName,
      required String message})
      : _id = id,
      _roomId = roomId,
        _message = message,
        _senderId = senderId,
        _receiverId = receiverId,
        _receiverName = receiverName,
        _isSender = isSender,
        _timeStamp = timeStamp,
        _senderName = senderName;

  get id => _id;
  get senderId => _senderId;
  get receiverId => _receiverId;
  get receiverName => _receiverName;
  get isSender => _isSender;
  get timeStamp => _timeStamp;
  get senderName => _senderName;
  get message => _message;
}

class TextMessageEntity extends Equatable implements MessageEntity {
  @override
  final String id;
  @override
  final String message;
  @override
  final String senderId;
  @override
  final String receiverId;
  @override
  final String receiverName;
  @override
  final bool isSender;
  @override
  final DateTime timeStamp;
  @override
  final String senderName;
  final String roomId;
  const TextMessageEntity(
      {required this.id,
      required this.message,
      required this.senderId,
      required this.receiverId,
      required this.receiverName,
      required this.isSender,
      required this.timeStamp,
      required this.roomId,
      required this.senderName});
  @override
  String get _id => id;

  @override
  bool get _isSender => isSender;

  @override
  String get _receiverId => receiverId;

  @override
  String get _receiverName => receiverName;

  @override
  String get _senderId => senderId;

  @override
  String get _senderName => senderName;

  @override
  DateTime get _timeStamp => timeStamp;

  @override
  String get _message => message;

  @override
  String get _roomId => roomId;
  @override
  List<Object?> get props => [
        id,
        message,
        senderId,
        receiverId,
        receiverName,
        isSender,
        timeStamp,
        senderName,
        message
      ];

  @override
  bool? get stringify => true;

  static TextMessageEntity empty({isSender}) => TextMessageEntity(
      roomId: '1-0',
      id: '1',
      message: 'Hey whats up',
      senderId: '2',
      receiverId: '3',
      receiverName: 'Naman',
      isSender: isSender,
      timeStamp: DateTime.now(),
      senderName: '');
}
