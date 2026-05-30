part of 'task_detail_bloc.dart';

abstract class TaskDetailState extends Equatable {
  const TaskDetailState();

  @override
  List<Object?> get props => [];
}

class TaskDetailInitial extends TaskDetailState {}

class TaskDetailLoading extends TaskDetailState {}

class TaskDetailLoaded extends TaskDetailState {
  final TaskEntity task;

  const TaskDetailLoaded({required this.task});

  @override
  List<Object?> get props => [task];
}

class TaskDeleted extends TaskDetailState {}

class TaskDetailError extends TaskDetailState {
  final ErrorModel error;

  const TaskDetailError({required this.error});

  @override
  List<Object?> get props => [error];
}
