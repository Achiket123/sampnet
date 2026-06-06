import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/use_cases/people_usecases.dart';
import 'contact_detail_event.dart';
import 'contact_detail_state.dart';

class ContactDetailBloc extends Bloc<ContactDetailEvent, ContactDetailState> {
  final GetContactDetailsUseCase getContactDetailsUseCase;
  final GetInteractionsUseCase getInteractionsUseCase;
  final CreateInteractionUseCase createInteractionUseCase;
  final UpdateContactUseCase updateContactUseCase;

  ContactDetailBloc({
    required this.getContactDetailsUseCase,
    required this.getInteractionsUseCase,
    required this.createInteractionUseCase,
    required this.updateContactUseCase,
  }) : super(const ContactDetailState()) {
    on<ContactDetailLoadRequested>(_onLoadRequested);
    on<ContactDetailInteractionAdded>(_onInteractionAdded);
    on<ContactDetailUpdated>(_onContactUpdated);
  }

  Future<void> _onLoadRequested(
      ContactDetailLoadRequested event, Emitter<ContactDetailState> emit) async {
    emit(state.copyWith(status: ContactDetailStatus.loading));

    final detailsResult = await getContactDetailsUseCase(event.contactId);
    final interactionsResult = await getInteractionsUseCase(event.contactId);

    detailsResult.fold(
      (failure) => emit(state.copyWith(
          status: ContactDetailStatus.failure, failureMessage: failure.message)),
      (contact) {
        interactionsResult.fold(
          (failure) => emit(state.copyWith(
              status: ContactDetailStatus.failure, failureMessage: failure.message)),
          (interactions) => emit(state.copyWith(
            status: ContactDetailStatus.success,
            contact: contact,
            interactions: interactions,
          )),
        );
      },
    );
  }

  Future<void> _onInteractionAdded(
      ContactDetailInteractionAdded event, Emitter<ContactDetailState> emit) async {
    emit(state.copyWith(status: ContactDetailStatus.actionLoading));
    final result = await createInteractionUseCase(event.interaction);
    result.fold(
      (failure) => emit(state.copyWith(
          status: ContactDetailStatus.actionFailure, failureMessage: failure.message)),
      (newInteraction) {
        final updatedInteractions = List.of(state.interactions)..insert(0, newInteraction);
        emit(state.copyWith(
            status: ContactDetailStatus.actionSuccess, interactions: updatedInteractions));
      },
    );
  }

  Future<void> _onContactUpdated(
      ContactDetailUpdated event, Emitter<ContactDetailState> emit) async {
    emit(state.copyWith(status: ContactDetailStatus.actionLoading));
    final result = await updateContactUseCase(event.contact);
    result.fold(
      (failure) => emit(state.copyWith(
          status: ContactDetailStatus.actionFailure, failureMessage: failure.message)),
      (updatedContact) {
        emit(state.copyWith(
            status: ContactDetailStatus.actionSuccess, contact: updatedContact));
      },
    );
  }
}
