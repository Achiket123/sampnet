part of 'task_bloc.dart';

@immutable
sealed class TaskState {}

final class TaskInitial extends TaskState {}

final class TaskLoading extends TaskState {}

final class TaskSuccess extends TaskState {
  final List<TaskEntity> tasks;
  TaskSuccess({required this.tasks});
}

final class TaskError extends TaskState {
  final ErrorModel error;
  TaskError({required this.error});
}
