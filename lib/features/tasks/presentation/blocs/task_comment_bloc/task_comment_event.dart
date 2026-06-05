part of 'task_comment_bloc.dart';

abstract class TaskCommentEvent extends Equatable {
  const TaskCommentEvent();

  @override
  List<Object?> get props => [];
}

class FetchTaskCommentsEvent extends TaskCommentEvent {
  final int taskId;

  const FetchTaskCommentsEvent({required this.taskId});

  @override
  List<Object?> get props => [taskId];
}

class AddCommentEvent extends TaskCommentEvent {
  final int taskId;
  final int userId;
  final String content;

  const AddCommentEvent({required this.taskId, required this.userId, required this.content});

  @override
  List<Object?> get props => [taskId, userId, content];
}
