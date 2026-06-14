part of 'upload_file_bloc.dart';

@immutable
sealed class UploadFileState {}

final class UploadFileInitial extends UploadFileState {}

final class UploadFileLoading extends UploadFileState {}

final class UploadFileSuccess extends UploadFileState {
  final int fileId;
  final String url;
  final String? fileName;
  UploadFileSuccess({required this.fileId, required this.url, this.fileName});
}

final class UploadFileError extends UploadFileState {
  final ErrorModel error;
  UploadFileError({required this.error});
}
