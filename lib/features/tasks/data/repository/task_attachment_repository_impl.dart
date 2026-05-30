import 'package:hackathon/features/tasks/data/data_sources/task_attachment_remote_data_source.dart';
import 'package:hackathon/features/tasks/data/models/task_attachment_model.dart';
import 'package:hackathon/features/tasks/domain/entities/task_attachment_entity.dart';
import 'package:hackathon/features/tasks/domain/repositories/task_attachment_repository.dart';

class TaskAttachmentRepositoryImpl implements TaskAttachmentRepository {
  final TaskAttachmentRemoteDataSource remoteDataSource;
  TaskAttachmentRepositoryImpl({required this.remoteDataSource});

  @override
  Future<TaskAttachmentEntity> attachFile(int taskId, int fileId, int uploadedBy, String fileName) async {
    final result = await remoteDataSource.postAttachment(taskId, fileId, fileName);
    return TaskAttachmentModel.fromJson(result).toEntity();
  }

  @override
  Future<List<TaskAttachmentEntity>> getAttachments(int taskId) async {
    final result = await remoteDataSource.fetchAttachments(taskId);
    return result.map((e) => TaskAttachmentModel.fromJson(e as Map<String, dynamic>).toEntity()).toList();
  }

  @override
  Future<void> removeAttachment(int taskId, int attachmentId) async {
    await remoteDataSource.removeAttachment(taskId, attachmentId);
  }
}
