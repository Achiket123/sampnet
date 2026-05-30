part of 'task_detail_bloc.dart';

abstract class TaskDetailEvent extends Equatable {
  const TaskDetailEvent();

  @override
  List<Object?> get props => [];
}

class FetchTaskDetailEvent extends TaskDetailEvent {
  final String token;
  final String id;

  const FetchTaskDetailEvent({required this.token, required this.id});

  @override
  List<Object?> get props => [token, id];
}

class DeleteTaskEvent extends TaskDetailEvent {
  final String token;
  final String id;

  const DeleteTaskEvent({required this.token, required this.id});

  @override
  List<Object?> get props => [token, id];
}
