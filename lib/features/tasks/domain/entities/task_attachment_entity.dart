import 'package:equatable/equatable.dart';

class TaskAttachmentEntity extends Equatable {
  final String id;
  final String taskId;
  final String fileName;
  final String fileUrl;
  final String fileType;
  final int fileSize;
  final DateTime uploadedAt;

  const TaskAttachmentEntity({
    required this.id,
    required this.taskId,
    required this.fileName,
    required this.fileUrl,
    required this.fileType,
    required this.fileSize,
    required this.uploadedAt,
  });

  @override
  List<Object?> get props => [id, taskId, fileName, fileUrl, fileType, fileSize, uploadedAt];
}
