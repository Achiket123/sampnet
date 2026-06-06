import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/use_cases/people_usecases.dart';
import '../../../domain/entities/people_entities.dart';
import 'people_list_event.dart';
import 'people_list_state.dart';

class PeopleListBloc extends Bloc<PeopleListEvent, PeopleListState> {
  final GetContactsUseCase getContactsUseCase;
  final DeleteContactUseCase deleteContactUseCase;
  final CreateContactUseCase createContactUseCase;
  
  PeopleListBloc({
    required this.getContactsUseCase,
    required this.deleteContactUseCase,
    required this.createContactUseCase,
  }) : super(const PeopleListState()) {
    on<PeopleListLoadRequested>(_onLoadRequested);
    on<PeopleListSearchChanged>(_onSearchChanged);
    on<PeopleListSearchCleared>(_onSearchCleared);
    on<PeopleListContactDeleted>(_onContactDeleted);
    on<PeopleListContactCreated>(_onContactCreated);
  }

Future<void> _onContactCreated(
    PeopleListContactCreated event, Emitter<PeopleListState> emit) async {
  emit(state.copyWith(status: PeopleListStatus.loading));
  final result = await createContactUseCase(event.contact);
  
  result.fold(
    (failure) => emit(state.copyWith(
        status: PeopleListStatus.createError, failureMessage: failure.message)),
    (newContact) {
      // Re-fetch the list from backend to ensure consistent state
      add(PeopleListLoadRequested(
        stageId: state.currentStageId,
        listId: state.currentListId,
        search: state.searchQuery,
      ));
    },
  );
}
  Future<void> _onLoadRequested(
      PeopleListLoadRequested event, Emitter<PeopleListState> emit) async {
    emit(state.copyWith(
        status: PeopleListStatus.loading,
        currentListId: event.listId,
        currentStageId: event.stageId,
        searchQuery: event.search ?? state.searchQuery));

    final result = await getContactsUseCase(
        stageId: event.stageId,
        listId: event.listId,
        search: event.search ?? state.searchQuery);

    result.fold(
      (failure) => emit(state.copyWith(
          status: PeopleListStatus.failure, failureMessage: failure.message)),
      (contacts) => emit(state.copyWith(
        status: PeopleListStatus.success,
        allContacts: contacts,
        displayedContacts: contacts,
      )),
    );
  }

  void _onSearchChanged(
      PeopleListSearchChanged event, Emitter<PeopleListState> emit) {
    if (event.query.isEmpty) {
      emit(state.copyWith(
          searchQuery: '', displayedContacts: state.allContacts));
      return;
    }

    final query = event.query.toLowerCase();
    final filtered = state.allContacts.where((contact) {
      final name = '${contact.firstName} ${contact.lastName}'.toLowerCase();
      final email = contact.email.toLowerCase();
      final company = contact.company?.toLowerCase() ?? '';
      return name.contains(query) ||
          email.contains(query) ||
          company.contains(query);
    }).toList();

    emit(state.copyWith(
        searchQuery: event.query, displayedContacts: filtered));
  }

  void _onSearchCleared(
      PeopleListSearchCleared event, Emitter<PeopleListState> emit) {
    emit(state.copyWith(
        searchQuery: '', displayedContacts: state.allContacts));
  }

  Future<void> _onContactDeleted(
      PeopleListContactDeleted event, Emitter<PeopleListState> emit) async {
    final result = await deleteContactUseCase(event.id);
    result.fold(
      (failure) => emit(state.copyWith(
          status: PeopleListStatus.deleteError,
          failureMessage: failure.message)),
      (_) {
        final updatedAll = state.allContacts
            .where((contact) => contact.id != event.id)
            .toList();
        final updatedDisplayed = state.displayedContacts
            .where((contact) => contact.id != event.id)
            .toList();
        emit(state.copyWith(
            status: PeopleListStatus.success,
            allContacts: updatedAll,
            displayedContacts: updatedDisplayed));
      },
    );
  }
}
