
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hackathon/features/chats/domain/entities/chat_entity.dart';
import 'package:hackathon/features/chats/domain/use_cases/chat_usecase.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';

part 'chat_bloc_event.dart';
part 'chat_bloc_state.dart';

class ChatBlocBloc extends Bloc<ChatBlocEvent, ChatBlocState> {
  final StreamChatUsecase _usecase;
  final CreateChatUsecase _createChatUsecase ;
  final GetChatUsecase _getChatUsecase;
  ChatBlocBloc({required StreamChatUsecase usecase,required CreateChatUsecase createChatUsecase,required GetChatUsecase getChatUsecase})
      : _usecase = usecase,
        _createChatUsecase = createChatUsecase,
        _getChatUsecase = getChatUsecase,
        super(ChatBlocInitial()) {
    on<ChatBlocEvent>((event, emit) {
      // TODO: implement event handler
      emit(ChatLoadingState());
    });
    on<GetChatsEvent>(
      (event, emit) async{
        final result = await _getChatUsecase.call(null);
        result.fold((l) => emit(ChatBlocError(l)), (r) => emit(   ChatBlocLoaded(r)));
      },
    );
    on<CreateChatEvent>((event, emit) async{
      final result = await _createChatUsecase.call(event.params);
      result.fold((l) => emit(ChatBlocError(l)), (r) => emit(   ChatCreatedState(r)));
    });
  }
}
