import 'package:hackathon/features/tasks/domain/entities/task_attachment_entity.dart';

class TaskAttachmentModel extends TaskAttachmentEntity {
  const TaskAttachmentModel({
    required super.id,
    required super.taskId,
    required super.fileName,
    required super.fileUrl,
    required super.fileType,
    required super.fileSize,
    required super.uploadedAt,
  });

  factory TaskAttachmentModel.fromJson(Map<String, dynamic> json) {
    return TaskAttachmentModel(
      id: json['id'].toString(),
      taskId: json['task_id'].toString(),
      fileName: json['file_name'],
      fileUrl: json['file_url'],
      fileType: json['file_type'],
      fileSize: json['file_size'],
      uploadedAt: DateTime.parse(json['uploaded_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'task_id': taskId,
      'file_name': fileName,
      'file_url': fileUrl,
      'file_type': fileType,
      'file_size': fileSize,
      'uploaded_at': uploadedAt.toIso8601String(),
    };
  }
}
