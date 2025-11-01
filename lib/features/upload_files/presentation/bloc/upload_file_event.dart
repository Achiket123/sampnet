part of 'upload_file_bloc.dart';

@immutable
sealed class UploadFileEvent {}

final class UploadFileBlocEvent extends UploadFileEvent {
  final UploadFileParams file;
  UploadFileBlocEvent({required this.file});
}

