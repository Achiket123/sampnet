import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hackathon/features/team/data/models/team_memory.dart';
import 'package:hackathon/features/team/domain/usecases/get_team_usecase.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';

part 'teamid_event.dart';
part 'teamid_state.dart';

class TeamidBloc extends Bloc<TeamidEvent, TeamidState> {
  final GetTeamByIdUseCase _getTeamByIdUseCase;
  TeamidBloc({required GetTeamByIdUseCase getTeamByIdUseCase})
      : _getTeamByIdUseCase = getTeamByIdUseCase,
        super(TeamidInitial()) {
    on<GetTeamIdEvent>((event, emit) async {
      emit(TeamLoadingState());
      final res = await _getTeamByIdUseCase.call(event.id);
      res.fold((l) => emit(TeamFailureState(errorModel: l)),
          (r) => emit(TeamSuccessState(teamMemory: r)));
    });
  }
}
