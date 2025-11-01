import 'package:bloc/bloc.dart';
import 'package:hackathon/features/team/domain/usecases/create_team_usecase.dart';
import 'package:hackathon/features/team/domain/usecases/get_team_usecase.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';
import 'package:hackathon/globals/models/team_model.dart';
import 'package:meta/meta.dart';

part 'team_event.dart';
part 'team_state.dart';

class TeamBloc extends Bloc<TeamEvent, TeamState> {
  final CreateTeamUsecase _createTeamUsecase;
  final GetTeamUseCase _getTeamUseCase;
  TeamBloc({required CreateTeamUsecase createTeamUsecase,required GetTeamUseCase getTeamUseCase})
      : _createTeamUsecase = createTeamUsecase,
        _getTeamUseCase = getTeamUseCase,
        super(TeamInitial()) {
    on<TeamEvent>((event, emit) {
      emit(TeamLoadingState());
    });
    on<GetTeamEvent>((event, emit) async {
      final result = await _getTeamUseCase.call(event.token);
      result.fold((l) => emit(TeamErrorState(error: l)),
          (r) => emit(TeamSuccessState(teams: r)));
    });

    on<CreateTeamEvent>((event, emit) async {
      final result = await _createTeamUsecase.call(event.params);
      result.fold((l) => emit(TeamErrorState(error: l)),
          (r) => emit(TeamSuccessState(teams: r)));
    });
  }
}
