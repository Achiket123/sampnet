import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hackathon/features/tasks/domain/entities/task_attachment_entity.dart';
import 'package:hackathon/features/tasks/domain/use_cases/add_task_attachment_usecase.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';
import 'package:hackathon/features/tasks/domain/repositories/task_attachment_repository.dart';

part 'task_attachment_event.dart';
part 'task_attachment_state.dart';

class TaskAttachmentBloc extends Bloc<TaskAttachmentEvent, TaskAttachmentState> {
  final TaskAttachmentRepository _repository;
  final AddTaskAttachmentUseCase _addTaskAttachmentUseCase;

  TaskAttachmentBloc({
    required TaskAttachmentRepository repository,
    required AddTaskAttachmentUseCase addTaskAttachmentUseCase,
  })  : _repository = repository,
        _addTaskAttachmentUseCase = addTaskAttachmentUseCase,
        super(TaskAttachmentInitial()) {
    on<FetchTaskAttachmentsEvent>((event, emit) async {
      emit(TaskAttachmentLoading());
      final result = await _repository.getTaskAttachments(event.token, event.taskId);
      result.fold(
        (l) => emit(TaskAttachmentError(error: l)),
        (r) => emit(TaskAttachmentsLoaded(attachments: r)),
      );
    });

    on<AddAttachmentEvent>((event, emit) async {
      final result = await _addTaskAttachmentUseCase(event.token, event.taskId, event.filePath);
      result.fold(
        (l) => emit(TaskAttachmentError(error: l)),
        (r) {
          if (state is TaskAttachmentsLoaded) {
            final updatedAttachments = List<TaskAttachmentEntity>.from((state as TaskAttachmentsLoaded).attachments)..add(r);
            emit(TaskAttachmentsLoaded(attachments: updatedAttachments));
          } else {
            emit(TaskAttachmentsLoaded(attachments: [r]));
          }
        },
      );
    });
  }
}
