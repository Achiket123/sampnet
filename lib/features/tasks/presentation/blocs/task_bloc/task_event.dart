part of 'task_bloc.dart';

@immutable
sealed class TaskEvent {}

final class FetchTasksEvent extends TaskEvent {
  final String token;
  FetchTasksEvent({required this.token});
}

final class FetchTaskByIdEvent extends TaskEvent {
  final FetchTaskByIdParams params;
  FetchTaskByIdEvent({required this.params});
}

class UpdateTaskEvent extends TaskEvent {
  final UpdateTaskParams params;

  UpdateTaskEvent({required this.params});
  
}
