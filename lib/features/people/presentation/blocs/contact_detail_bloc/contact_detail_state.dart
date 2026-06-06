import 'package:equatable/equatable.dart';
import '../../../domain/entities/people_entities.dart';

enum ContactDetailStatus { initial, loading, success, failure, actionLoading, actionSuccess, actionFailure }

class ContactDetailState extends Equatable {
  final ContactDetailStatus status;
  final PeopleContactEntity? contact;
  final List<PeopleInteractionEntity> interactions;
  final String? failureMessage;

  const ContactDetailState({
    this.status = ContactDetailStatus.initial,
    this.contact,
    this.interactions = const [],
    this.failureMessage,
  });

  ContactDetailState copyWith({
    ContactDetailStatus? status,
    PeopleContactEntity? contact,
    List<PeopleInteractionEntity>? interactions,
    String? failureMessage,
  }) {
    return ContactDetailState(
      status: status ?? this.status,
      contact: contact ?? this.contact,
      interactions: interactions ?? this.interactions,
      failureMessage: failureMessage, // can be null
    );
  }

  @override
  List<Object?> get props => [status, contact, interactions, failureMessage];
}
