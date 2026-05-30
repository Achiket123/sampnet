part of 'task_comment_bloc.dart';

abstract class TaskCommentState extends Equatable {
  const TaskCommentState();

  @override
  List<Object?> get props => [];
}

class TaskCommentInitial extends TaskCommentState {}

class TaskCommentLoading extends TaskCommentState {}

class TaskCommentsLoaded extends TaskCommentState {
  final List<TaskCommentEntity> comments;

  const TaskCommentsLoaded({required this.comments});

  @override
  List<Object?> get props => [comments];
}

class TaskCommentError extends TaskCommentState {
  final ErrorModel error;

  const TaskCommentError({required this.error});

  @override
  List<Object?> get props => [error];
}
