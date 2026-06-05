import 'package:fpdart/fpdart.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';
import '../entities/task_attachment_entity.dart';
import '../repositories/task_attachment_repository.dart';

class GetTaskAttachmentsUseCase {
  final TaskAttachmentRepository repository;
  GetTaskAttachmentsUseCase({required this.repository});

  Future<Either<ErrorModel, List<TaskAttachmentEntity>>> call(int taskId) async {
    return await repository.getAttachments(taskId);
  }
}
