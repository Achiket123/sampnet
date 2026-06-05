import 'package:fpdart/fpdart.dart';
import 'package:hackathon/features/tasks/data/data_sources/task_attachment_data_source.dart';
import 'package:hackathon/features/tasks/domain/entities/task_attachment_entity.dart';
import 'package:hackathon/features/tasks/domain/repositories/task_attachment_repository.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';

class TaskAttachmentRepositoryImpl implements TaskAttachmentRepository {
  final TaskAttachmentRemoteDataSource remoteDataSource;
  TaskAttachmentRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<ErrorModel, TaskAttachmentEntity>> attachFile(int taskId, int fileId, int uploadedBy, String fileName) async {
    final result = await remoteDataSource.addTaskAttachment(taskId, fileId, fileName);
    return result.map((model) => model.toEntity());
  }

  @override
  Future<Either<ErrorModel, List<TaskAttachmentEntity>>> getAttachments(int taskId) async {
    final result = await remoteDataSource.getTaskAttachments(taskId);
    return result.map((models) => models.map((e) => e.toEntity()).toList());
  }

  @override
  Future<Either<ErrorModel, Unit>> removeAttachment(int taskId, int attachmentId) async {
    return await remoteDataSource.removeTaskAttachment(taskId, attachmentId);
  }
}
