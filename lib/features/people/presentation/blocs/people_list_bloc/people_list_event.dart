import 'package:equatable/equatable.dart';
import '../../../domain/entities/people_entities.dart';

abstract class PeopleListEvent extends Equatable {
  const PeopleListEvent();

  @override
  List<Object?> get props => [];
}

class PeopleListLoadRequested extends PeopleListEvent {
  final int? stageId;
  final int? listId;
  final String? search;

  const PeopleListLoadRequested({this.stageId, this.listId, this.search});

  @override
  List<Object?> get props => [stageId, listId, search];
}

class PeopleListSearchChanged extends PeopleListEvent {
  final String query;
  const PeopleListSearchChanged(this.query);

  @override
  List<Object> get props => [query];
}

class PeopleListSearchCleared extends PeopleListEvent {}

class PeopleListContactCreated extends PeopleListEvent {
  final PeopleContactEntity contact;
  const PeopleListContactCreated(this.contact);

  @override
  List<Object> get props => [contact];
}

class PeopleListContactDeleted extends PeopleListEvent {
  final int id;
  const PeopleListContactDeleted(this.id);

  @override
  List<Object> get props => [id];
}
