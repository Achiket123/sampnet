import 'package:fpdart/fpdart.dart';
import 'package:hackathon/features/tasks/domain/entities/task_attachment_entity.dart';
import 'package:hackathon/features/tasks/domain/repositories/task_attachment_repository.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';

class AddTaskAttachmentUseCase {
  final TaskAttachmentRepository repository;
  AddTaskAttachmentUseCase({required this.repository});

  Future<Either<ErrorModel, TaskAttachmentEntity>> call(String token, String taskId, String filePath) async {
    return await repository.addTaskAttachment(token, taskId, filePath);
  }
}
