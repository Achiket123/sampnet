import 'package:equatable/equatable.dart';

class TaskAttachmentEntity extends Equatable {
  final int id;
  final int taskId;
  final int fileId;
  final int uploadedBy;
  final String fileName;
  final DateTime createdAt;
  final String uploaderFirstName;
  final String uploaderLastName;

  const TaskAttachmentEntity({
    required this.id,
    required this.taskId,
    required this.fileId,
    required this.uploadedBy,
    required this.fileName,
    required this.createdAt,
    required this.uploaderFirstName,
    required this.uploaderLastName,
  });

  String get uploaderDisplayName => "$uploaderFirstName $uploaderLastName";

  @override
  List<Object?> get props => [
        id,
        taskId,
        fileId,
        uploadedBy,
        fileName,
        createdAt,
        uploaderFirstName,
        uploaderLastName
      ];
}
