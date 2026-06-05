import 'package:fpdart/fpdart.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';
import '../entities/task_attachment_entity.dart';
import '../repositories/task_attachment_repository.dart';

class AddTaskAttachmentUseCase {
  final TaskAttachmentRepository repository;
  AddTaskAttachmentUseCase({required this.repository});

  Future<Either<ErrorModel, TaskAttachmentEntity>> call(int taskId, int fileId, int uploadedBy, String fileName) async {
    return await repository.attachFile(taskId, fileId, uploadedBy, fileName);
  }
}
