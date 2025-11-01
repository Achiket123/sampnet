part of 'message_bloc.dart';

sealed class MessageState extends Equatable {
  const MessageState();
  
  @override
  List<Object> get props => [];
}

final class MessageInitial extends MessageState {}

class SendingMessageState extends MessageState {
}

class MessageSentState extends MessageState {}

class MessageErrorState extends MessageState {
  final ErrorModel errorModel;

  const MessageErrorState({required this.errorModel});
}