part of 'chat_bloc_bloc.dart';

sealed class ChatBlocState extends Equatable {
  const ChatBlocState();
  
  @override
  List<Object> get props => [];
}

final class ChatBlocInitial extends ChatBlocState {}

class ChatBlocLoaded extends ChatBlocState {
  final List<ChatEntity> chats;
  const ChatBlocLoaded(this.chats);
}

class ChatLoadingState extends ChatBlocState {}

class ChatBlocError extends ChatBlocState {
  final ErrorModel errorModel;
  const ChatBlocError(this.errorModel);
}
class ChatCreatedState extends ChatBlocState {
  final ChatEntity chat;
  const ChatCreatedState(this.chat);
}

class ChatLoadedState extends ChatBlocState {
  final Stream chat;
  const ChatLoadedState(this.chat);
}