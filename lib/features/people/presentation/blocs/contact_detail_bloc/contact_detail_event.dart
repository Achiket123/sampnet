import 'package:equatable/equatable.dart';
import '../../../domain/entities/people_entities.dart';

abstract class ContactDetailEvent extends Equatable {
  const ContactDetailEvent();

  @override
  List<Object?> get props => [];
}

class ContactDetailLoadRequested extends ContactDetailEvent {
  final int contactId;
  const ContactDetailLoadRequested(this.contactId);

  @override
  List<Object> get props => [contactId];
}

class ContactDetailInteractionAdded extends ContactDetailEvent {
  final PeopleInteractionEntity interaction;
  const ContactDetailInteractionAdded(this.interaction);

  @override
  List<Object> get props => [interaction];
}

class ContactDetailUpdated extends ContactDetailEvent {
  final PeopleContactEntity contact;
  const ContactDetailUpdated(this.contact);

  @override
  List<Object> get props => [contact];
}
