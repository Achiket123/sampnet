import 'package:fpdart/fpdart.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';
import '../repositories/task_attachment_repository.dart';

class RemoveTaskAttachmentUseCase {
  final TaskAttachmentRepository repository;
  RemoveTaskAttachmentUseCase({required this.repository});

  Future<Either<ErrorModel, Unit>> call(int taskId, int attachmentId) async {
    return await repository.removeAttachment(taskId, attachmentId);
  }
}
