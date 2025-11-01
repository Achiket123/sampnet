part of 'chat_bloc_bloc.dart';

sealed class ChatBlocEvent extends Equatable {
  const ChatBlocEvent();

  @override
  List<Object> get props => [];
}
class GetChatsEvent extends ChatBlocEvent {
  
}
class CreateChatEvent extends ChatBlocEvent {
  final ChatParams params;
  const CreateChatEvent({required this.params});
}