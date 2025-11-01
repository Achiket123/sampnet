part of 'create_task_bloc.dart';

@immutable
sealed class CreateTaskState {}

final class CreateTaskInitial extends CreateTaskState {}

final class CreateTaskLoading extends CreateTaskState {}

final class CreateTaskSuccess extends CreateTaskState {
  final TaskEntity task;
  CreateTaskSuccess({required this.task});
}

final class CreateTaskFailure extends CreateTaskState {
  final ErrorModel error;
  CreateTaskFailure({required this.error});
}
