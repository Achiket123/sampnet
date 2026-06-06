import 'package:equatable/equatable.dart';
import '../../../domain/entities/people_entities.dart';

enum PeopleListStatus { initial, loading, success, failure, deleteError, createError }

class PeopleListState extends Equatable {
  final PeopleListStatus status;
  final List<PeopleContactEntity> allContacts;
  final List<PeopleContactEntity> displayedContacts;
  final String searchQuery;
  final String? failureMessage;
  final int? currentStageId;
  final int? currentListId;

  const PeopleListState({
    this.status = PeopleListStatus.initial,
    this.allContacts = const [],
    this.displayedContacts = const [],
    this.searchQuery = '',
    this.failureMessage,
    this.currentStageId,
    this.currentListId,
  });

  PeopleListState copyWith({
    PeopleListStatus? status,
    List<PeopleContactEntity>? allContacts,
    List<PeopleContactEntity>? displayedContacts,
    String? searchQuery,
    String? failureMessage,
    int? currentStageId,
    int? currentListId,
  }) {
    return PeopleListState(
      status: status ?? this.status,
      allContacts: allContacts ?? this.allContacts,
      displayedContacts: displayedContacts ?? this.displayedContacts,
      searchQuery: searchQuery ?? this.searchQuery,
      failureMessage: failureMessage, // Set to null if not explicitly provided
      currentStageId: currentStageId ?? this.currentStageId,
      currentListId: currentListId ?? this.currentListId,
    );
  }

  @override
  List<Object?> get props => [
        status,
        allContacts,
        displayedContacts,
        searchQuery,
        failureMessage,
        currentStageId,
        currentListId,
      ];
}
