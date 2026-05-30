import '../entities/task_attachment_entity.dart';
import '../repositories/task_attachment_repository.dart';

class AddTaskAttachmentUseCase {
  final TaskAttachmentRepository repository;
  AddTaskAttachmentUseCase({required this.repository});

  Future<TaskAttachmentEntity> call(int taskId, int fileId, int uploadedBy, String fileName) async {
    return await repository.attachFile(taskId, fileId, uploadedBy, fileName);
  }
}
