import '../repositories/task_attachment_repository.dart';

class RemoveTaskAttachmentUseCase {
  final TaskAttachmentRepository repository;
  RemoveTaskAttachmentUseCase({required this.repository});

  Future<void> call(int taskId, int attachmentId) async {
    return await repository.removeAttachment(taskId, attachmentId);
  }
}
