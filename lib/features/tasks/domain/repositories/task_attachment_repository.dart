import 'package:fpdart/fpdart.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';
import '../entities/task_attachment_entity.dart';

abstract class TaskAttachmentRepository {
  Future<Either<ErrorModel, TaskAttachmentEntity>> attachFile(int taskId, int fileId, int uploadedBy, String fileName);
  Future<Either<ErrorModel, List<TaskAttachmentEntity>>> getAttachments(int taskId);
  Future<Either<ErrorModel, Unit>> removeAttachment(int taskId, int attachmentId);
}
