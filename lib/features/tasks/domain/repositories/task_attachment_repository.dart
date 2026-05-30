import 'package:fpdart/fpdart.dart';
import 'package:hackathon/features/tasks/domain/entities/task_attachment_entity.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';

abstract class TaskAttachmentRepository {
  Future<Either<ErrorModel, List<TaskAttachmentEntity>>> getTaskAttachments(String token, String taskId);
  Future<Either<ErrorModel, TaskAttachmentEntity>> addTaskAttachment(String token, String taskId, String filePath);
}
