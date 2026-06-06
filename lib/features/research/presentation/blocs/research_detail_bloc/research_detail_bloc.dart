import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/research_entry_entity.dart';
import '../../../domain/use_cases/get_research_detail_usecase.dart';
import '../../../domain/use_cases/create_research_entry_usecase.dart';
import '../../../domain/use_cases/update_research_entry_usecase.dart';
import '../../../domain/use_cases/delete_research_entry_usecase.dart';

part 'research_detail_event.dart';
part 'research_detail_state.dart';

class ResearchDetailBloc
    extends Bloc<ResearchDetailEvent, ResearchDetailState> {
  final GetResearchDetailUsecase getResearchDetailUsecase;
  final CreateResearchEntryUsecase createResearchEntryUsecase;
  final UpdateResearchEntryUsecase updateResearchEntryUsecase;
  final DeleteResearchEntryUsecase deleteResearchEntryUsecase;

  ResearchDetailBloc({
    required this.getResearchDetailUsecase,
    required this.createResearchEntryUsecase,
    required this.updateResearchEntryUsecase,
    required this.deleteResearchEntryUsecase,
  }) : super(ResearchDetailInitial()) {
    on<GetResearchDetail>(_onGetResearchDetail);
    on<CreateResearchEntry>(_onCreateResearchEntry);
    on<UpdateResearchEntry>(_onUpdateResearchEntry);
    on<DeleteResearchEntry>(_onDeleteResearchEntry);
  }

  Future<void> _onGetResearchDetail(
      GetResearchDetail event, Emitter<ResearchDetailState> emit) async {
    emit(ResearchDetailLoading());
    final result = await getResearchDetailUsecase(event.id);
    result.fold(
      (error) => emit(ResearchDetailError(message: error.message)),
      (entry) => emit(ResearchDetailLoaded(entry: entry)),
    );
  }

  Future<void> _onCreateResearchEntry(
      CreateResearchEntry event, Emitter<ResearchDetailState> emit) async {
    emit(ResearchDetailLoading());
    final result = await createResearchEntryUsecase(event.entry);
    result.fold(
      (error) => emit(ResearchDetailError(message: error.message)),
      (entry) => emit(const ResearchActionSuccess(
          message: 'Research entry created successfully')),
    );
  }

  Future<void> _onUpdateResearchEntry(
      UpdateResearchEntry event, Emitter<ResearchDetailState> emit) async {
    emit(ResearchDetailLoading());
    final result = await updateResearchEntryUsecase(event.entry);
    result.fold(
      (error) => emit(ResearchDetailError(message: error.message)),
      (_) => emit(const ResearchActionSuccess(
          message: 'Research entry updated successfully')),
    );
  }

  Future<void> _onDeleteResearchEntry(
      DeleteResearchEntry event, Emitter<ResearchDetailState> emit) async {
    emit(ResearchDetailLoading());
    final result = await deleteResearchEntryUsecase(event.id);
    result.fold(
      (error) => emit(ResearchDetailError(message: error.message)),
      (_) => emit(const ResearchActionSuccess(
          message: 'Research entry deleted successfully')),
    );
  }
}
