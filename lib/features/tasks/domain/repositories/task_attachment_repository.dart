import '../entities/task_attachment_entity.dart';

abstract class TaskAttachmentRepository {
  Future<TaskAttachmentEntity> attachFile(int taskId, int fileId, int uploadedBy, String fileName);
  Future<List<TaskAttachmentEntity>> getAttachments(int taskId);
  Future<void> removeAttachment(int taskId, int attachmentId);
}
