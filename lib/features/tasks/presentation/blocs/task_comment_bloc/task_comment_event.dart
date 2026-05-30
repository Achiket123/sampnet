part of 'task_comment_bloc.dart';

abstract class TaskCommentEvent extends Equatable {
  const TaskCommentEvent();

  @override
  List<Object?> get props => [];
}

class FetchTaskCommentsEvent extends TaskCommentEvent {
  final String token;
  final String taskId;

  const FetchTaskCommentsEvent({required this.token, required this.taskId});

  @override
  List<Object?> get props => [token, taskId];
}

class AddCommentEvent extends TaskCommentEvent {
  final String token;
  final String taskId;
  final String content;

  const AddCommentEvent({required this.token, required this.taskId, required this.content});

  @override
  List<Object?> get props => [token, taskId, content];
}
