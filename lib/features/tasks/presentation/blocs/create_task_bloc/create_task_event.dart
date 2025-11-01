part of 'create_task_bloc.dart';

@immutable
sealed class CreateTaskEvent {}

class CreateTask extends CreateTaskEvent {
  final CreateTaskParams params;
  CreateTask({required this.params});
}
