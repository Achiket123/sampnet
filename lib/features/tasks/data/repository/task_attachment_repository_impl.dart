import 'package:fpdart/fpdart.dart';
import 'package:hackathon/features/tasks/data/data_sources/task_attachment_data_source.dart';
import 'package:hackathon/features/tasks/domain/entities/task_attachment_entity.dart';
import 'package:hackathon/features/tasks/domain/repositories/task_attachment_repository.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';

class TaskAttachmentRepositoryImpl implements TaskAttachmentRepository {
  final TaskAttachmentRemoteDataSource remoteDataSource;
  TaskAttachmentRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<ErrorModel, List<TaskAttachmentEntity>>> getTaskAttachments(String token, String taskId) async {
    return await remoteDataSource.getTaskAttachments(token, taskId);
  }

  @override
  Future<Either<ErrorModel, TaskAttachmentEntity>> addTaskAttachment(String token, String taskId, String filePath) async {
    return await remoteDataSource.addTaskAttachment(token, taskId, filePath);
  }
}
