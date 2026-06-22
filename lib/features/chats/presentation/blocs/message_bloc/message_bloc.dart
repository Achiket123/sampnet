import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hackathon/features/chats/domain/use_cases/message_usecase.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';

part 'message_event.dart';
part 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final MessageUsecase _messageUseCase;
  MessageBloc({required MessageUsecase messageUseCase})
      : _messageUseCase = messageUseCase,
        super(MessageInitial()) {
    on<SendMessageEvent>(
      (event, emit) async {
        emit(SendingMessageState());
        final result = await _messageUseCase.call(event.messageParams);
        result.fold(
          (l) => emit(MessageErrorState(errorModel: l)),
          (r) => emit(MessageSentState()),
        );
      },
    );
  }
}
