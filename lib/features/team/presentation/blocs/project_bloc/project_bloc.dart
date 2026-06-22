import 'package:bloc/bloc.dart';
import 'package:hackathon/features/team/domain/entities/project_entity.dart';
import 'package:hackathon/features/team/domain/usecases/team_get_project_usecase.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';
import 'package:meta/meta.dart';

part 'project_event.dart';
part 'project_state.dart';

class ProjectBloc extends Bloc<ProjectEvent, ProjectState> {
  final TeamGetProjectUsecase _teamGetProjectUsecase;
  ProjectBloc({required TeamGetProjectUsecase teamGetProjectUsecase})
      : _teamGetProjectUsecase = teamGetProjectUsecase,
        super(ProjectInitial()) {
    on<GetProjectEvent>((event, emit) async {
      emit(ProjectLoadingState());
      final result = await _teamGetProjectUsecase.call(event.token);
      result.fold((error) {
        emit(ProjectErrorState(error: error));
      }, (projects) {
        emit(ProjectSuccessState(projects: projects));
      });
    });
  }
}
