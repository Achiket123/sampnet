import '../../domain/entities/task_attachment_entity.dart';

class TaskAttachmentModel extends TaskAttachmentEntity {
  const TaskAttachmentModel({
    required super.id,
    required super.taskId,
    required super.fileId,
    required super.uploadedBy,
    required super.fileName,
    required super.createdAt,
    required super.uploaderFirstName,
    required super.uploaderLastName,
  });

  factory TaskAttachmentModel.fromJson(Map<String, dynamic> json) {
    return TaskAttachmentModel(
      id: json['id'] is String ? int.parse(json['id']) : json['id'] as int,
      taskId: json['task_id'] is String ? int.parse(json['task_id']) : json['task_id'] as int,
      fileId: json['file_id'] is String ? int.parse(json['file_id']) : json['file_id'] as int,
      uploadedBy: json['uploaded_by'] is String ? int.parse(json['uploaded_by']) : json['uploaded_by'] as int,
      fileName: json['file_name'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
      uploaderFirstName: json['uploader_first_name'] ?? '',
      uploaderLastName: json['uploader_last_name'] ?? '',
    );
  }

  TaskAttachmentEntity toEntity() {
    return TaskAttachmentEntity(
      id: id,
      taskId: taskId,
      fileId: fileId,
      uploadedBy: uploadedBy,
      fileName: fileName,
      createdAt: createdAt,
      uploaderFirstName: uploaderFirstName,
      uploaderLastName: uploaderLastName,
    );
  }
}
