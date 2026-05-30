import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hackathon/dependency_injection.g.dart';
import 'package:hackathon/features/tasks/domain/entities/task_entity.dart';
import 'package:hackathon/features/tasks/presentation/blocs/task_detail_bloc/task_detail_bloc.dart';
import 'package:hackathon/features/tasks/presentation/blocs/task_detail_bloc/task_detail_event.dart';
import 'package:hackathon/features/tasks/presentation/blocs/task_detail_bloc/task_detail_state.dart';
import 'package:hackathon/features/tasks/presentation/widgets/task_comment_section.dart';
import 'package:hackathon/features/tasks/presentation/widgets/task_attachment_section.dart';
import 'package:hackathon/features/upload_files/presentation/bloc/upload_file_bloc.dart';
import 'package:hackathon/globals/constants/color_pallete.dart';
import 'package:hackathon/globals/constants/user.dart';
import 'package:intl/intl.dart';

class TaskDetailPage extends StatefulWidget {
  final int taskId;

  const TaskDetailPage({super.key, required this.taskId});

  @override
  State<TaskDetailPage> createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<TaskDetailBloc>()..add(LoadTaskDetail(taskId: widget.taskId)),
      child: Scaffold(
        appBar: AppBar(
          title: BlocBuilder<TaskDetailBloc, TaskDetailState>(
            builder: (context, state) {
              return Text(state.task?.title ?? "Task Details");
            },
          ),
          actions: [
            BlocBuilder<TaskDetailBloc, TaskDetailState>(
              builder: (context, state) {
                final currentUserId = getIt<User>().user!.id;
                if (state.task != null && state.task!.assignedBy == currentUserId) {
                  return IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _showDeleteConfirmation(context),
                  );
                }
                return const SizedBox();
              },
            ),
          ],
        ),
        body: MultiBlocListener(
          listeners: [
            BlocListener<TaskDetailBloc, TaskDetailState>(
              listener: (context, state) {
                if (state.taskError != null) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.taskError!)));
                }
                if (state.commentError != null) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.commentError!)));
                }
                if (state.attachmentError != null) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.attachmentError!)));
                }
              },
            ),
            BlocListener<UploadFileBloc, UploadFileState>(
              listener: (context, state) {
                if (state is UploadFileSuccess) {
                  context.read<TaskDetailBloc>().add(AddAttachment(
                    fileId: state.fileId,
                    fileName: "New Attachment", // Ideally we'd get the actual file name
                  ));
                }
              },
            ),
          ],
          child: BlocBuilder<TaskDetailBloc, TaskDetailState>(
            builder: (context, state) {
              if (state.isLoadingTask && state.task == null) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state.taskError != null && state.task == null) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Error: ${state.taskError}"),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () => context.read<TaskDetailBloc>().add(LoadTaskDetail(taskId: widget.taskId)),
                        child: const Text("Retry"),
                      ),
                    ],
                  ),
                );
              }

              final task = state.task!;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section 1: Header
                    Text(
                      task.title,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      task.description ?? "No description provided",
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _buildBadge(context, task.status, _getStatusColor(task.status)),
                        const SizedBox(width: 8),
                        _buildBadge(context, task.priority, _getPriorityColor(task.priority)),
                        const SizedBox(width: 8),
                        _buildBadge(context, task.type, Colors.blueGrey),
                      ],
                    ),
                    const Divider(height: 32),

                    // Section 2: Meta
                    _buildMetaRow("Assigned To", "${task.assignedUser?.firstName ?? ''} ${task.assignedUser?.lastName ?? ''}"),
                    _buildMetaRow("Assigned By", "${task.assignedByUser?.firstName ?? ''} ${task.assignedByUser?.lastName ?? ''}"),
                    _buildMetaRow("Due Date", DateFormat('MMM dd, yyyy').format(task.dueDate)),
                    if (task.team != null) _buildMetaRow("Team", task.team!.name),
                    if (task.project != null) _buildMetaRow("Project", task.project!.name),
                    const Divider(height: 32),

                    // Section 3: Status Update
                    const Text("Update Status", style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    _buildStatusDropdown(context, task),
                    const Divider(height: 32),

                    // Section 4: Comments
                    TaskCommentSection(
                      comments: state.comments,
                      onAddComment: (content) {
                        context.read<TaskDetailBloc>().add(AddComment(content: content));
                      },
                      onDeleteComment: (commentId) {
                        context.read<TaskDetailBloc>().add(DeleteComment(commentId: commentId));
                      },
                      isSubmitting: state.isSubmittingComment,
                      currentUserId: getIt<User>().user!.id,
                    ),
                    const Divider(height: 32),

                    // Section 5: Attachments
                    TaskAttachmentSection(
                      attachments: state.attachments,
                      onAddAttachment: (fileId, fileName) {
                        context.read<TaskDetailBloc>().add(AddAttachment(fileId: fileId, fileName: fileName));
                      },
                      onRemoveAttachment: (attachmentId) {
                        context.read<TaskDetailBloc>().add(RemoveAttachment(attachmentId: attachmentId));
                      },
                      isUploading: state.isUploadingAttachment,
                      currentUserId: getIt<User>().user!.id,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBadge(BuildContext context, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildMetaRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white70)),
          Text(value, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildStatusDropdown(BuildContext context, TaskEntity task) {
    final List<String> statusOptions = ['Pending', 'In Progress', 'Blocked', 'Done'];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: ColorPallete.blackSecondary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButton<String>(
        value: statusOptions.contains(task.status) ? task.status : 'Pending',
        isExpanded: true,
        underline: const SizedBox(),
        items: statusOptions.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
        onChanged: (value) {
          if (value != null) {
            context.read<TaskDetailBloc>().add(UpdateTaskStatus(taskId: widget.taskId, status: value));
          }
        },
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Done': return Colors.green;
      case 'In Progress': return Colors.orange;
      case 'Blocked': return Colors.red;
      default: return Colors.grey;
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'High': return Colors.red;
      case 'Medium': return Colors.orange;
      case 'Low': return Colors.green;
      default: return Colors.grey;
    }
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Task"),
        content: const Text("Are you sure you want to delete this task?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              // We could add a DeleteTask event to TaskDetailBloc
              // or just use the existing TaskBloc if available.
              // For now, let's assume we handle it in TaskDetailBloc if needed.
              Navigator.pop(context);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
