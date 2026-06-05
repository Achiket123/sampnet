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
  static const String routeName = "/task-detail/:taskId";
  final int taskId;

  const TaskDetailPage({super.key, required this.taskId});

  @override
  State<TaskDetailPage> createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider(
      create: (context) =>
          getIt<TaskDetailBloc>()..add(LoadTaskDetail(taskId: widget.taskId)),
      child: Scaffold(
        backgroundColor: const Color(0xFF121212), // Deep premium background
        appBar: AppBar(
          backgroundColor: Colors.red,
          elevation: 0,
          title: BlocBuilder<TaskDetailBloc, TaskDetailState>(
            builder: (context, state) {
              return Text(
                state.task?.title ?? "Task Details",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              );
            },
          ),
          actions: [
            BlocBuilder<TaskDetailBloc, TaskDetailState>(
              builder: (context, state) {
                final currentUserId = getIt<User>().user!.id;
                if (state.task != null &&
                    state.task!.assignedBy == currentUserId) {
                  return IconButton(
                    icon: const Icon(Icons.delete_outline,
                        color: Colors.redAccent),
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
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(state.taskError!)));
                }
                if (state.commentError != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.commentError!)));
                }
                if (state.attachmentError != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.attachmentError!)));
                }
              },
            ),
            BlocListener<UploadFileBloc, UploadFileState>(
              listener: (context, state) {
                if (state is UploadFileSuccess) {
                  context.read<TaskDetailBloc>().add(AddAttachment(
                        fileId: state.fileId,
                        fileName: state.fileName ?? "New Attachment",
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
                      Icon(Icons.error_outline,
                          size: 48, color: Colors.red.shade300),
                      const SizedBox(height: 16),
                      Text("Error: ${state.taskError}",
                          style: const TextStyle(color: Colors.white70)),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: theme.primaryColor),
                        onPressed: () => context
                            .read<TaskDetailBloc>()
                            .add(LoadTaskDetail(taskId: widget.taskId)),
                        icon: const Icon(Icons.refresh),
                        label: const Text("Retry"),
                      ),
                    ],
                  ),
                );
              }

              final task = state.task!;

              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- HEADER SECTION ---
                    Text(
                      task.title,
                      style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          height: 1.2),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      task.description ?? "No description provided",
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey.shade400,
                          height: 1.4),
                    ),
                    const SizedBox(height: 20),

                    // Badges row
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _buildBadge(task.status, _getStatusColor(task.status)),
                        _buildBadge(
                            task.priority, _getPriorityColor(task.priority)),
                        _buildBadge(task.type, Colors.blueGrey.shade400),
                      ],
                    ),
                    const SizedBox(height: 28),

                    // --- ASSIGNMENT & TIMELINE CARD ---
                    _buildSectionHeading("Details"),
                    Card(
                      color: const Color(0xFF1E1E1E),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      margin: EdgeInsets.zero,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            _buildUserRow(
                                "Assigned To",
                                task.assignedUser?.firstName,
                                task.assignedUser?.lastName,
                                task.assignedUser?.profilePic),
                            const Divider(color: Colors.white10, height: 24),
                            _buildUserRow(
                                "Assigned By",
                                task.assignedByUser?.firstName,
                                task.assignedByUser?.lastName,
                                task.assignedByUser?.profilePic),
                            const Divider(color: Colors.white10, height: 24),
                            _buildMetaInfoRow(
                                Icons.calendar_today_rounded,
                                "Due Date",
                                DateFormat('MMM dd, yyyy')
                                    .format(task.dueDate)),
                            if (task.team != null) ...[
                              const Divider(color: Colors.white10, height: 24),
                              _buildMetaInfoRow(Icons.group_work_rounded,
                                  "Team", task.team!.name),
                            ],
                            if (task.project != null) ...[
                              const Divider(color: Colors.white10, height: 24),
                              _buildMetaInfoRow(Icons.folder_open_rounded,
                                  "Project", task.project!.name),
                            ],
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),

                    // --- ACTIONS & STATUS UPDATE ---
                    _buildSectionHeading("Update Status"),
                    _buildStatusDropdown(context, task),
                    const SizedBox(height: 32),

                    // --- COMMENTS SECTION ---
                    TaskCommentSection(
                      comments: state.comments,
                      onAddComment: (content) {
                        context
                            .read<TaskDetailBloc>()
                            .add(AddComment(content: content));
                      },
                      onDeleteComment: (commentId) {
                        context
                            .read<TaskDetailBloc>()
                            .add(DeleteComment(commentId: commentId));
                      },
                      isSubmitting: state.isSubmittingComment,
                      currentUserId: getIt<User>().user!.id,
                    ),
                    const SizedBox(height: 32),

                    // --- ATTACHMENTS SECTION ---
                    TaskAttachmentSection(
                      attachments: state.attachments,
                      onAddAttachment: (fileId, fileName) {
                        context.read<TaskDetailBloc>().add(
                            AddAttachment(fileId: fileId, fileName: fileName));
                      },
                      onRemoveAttachment: (attachmentId) {
                        context
                            .read<TaskDetailBloc>()
                            .add(RemoveAttachment(attachmentId: attachmentId));
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

  Widget _buildSectionHeading(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, left: 4.0),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white54,
            letterSpacing: 0.5),
      ),
    );
  }

  Widget _buildBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color
            .withAlpha(25), // Modern equivalent of color.withValues(alpha: 0.1)
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withAlpha(120), width: 1),
      ),
      child: Text(
        label,
        style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3),
      ),
    );
  }

  Widget _buildMetaInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.white38),
        const SizedBox(width: 12),
        Text(label,
            style: const TextStyle(color: Colors.white54, fontSize: 14)),
        const Spacer(),
        Text(value,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildUserRow(
      String label, String? firstName, String? lastName, String? avatarUrl) {
    final fullName = "${firstName ?? ''} ${lastName ?? ''}".trim();
    return Row(
      children: [
        const Icon(Icons.assignment_ind_outlined,
            size: 20, color: Colors.white38),
        const SizedBox(width: 12),
        Text(label,
            style: const TextStyle(color: Colors.white54, fontSize: 14)),
        const Spacer(),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 12,
              backgroundColor: Colors.white12,
              backgroundImage: avatarUrl != null && avatarUrl.isNotEmpty
                  ? NetworkImage(avatarUrl)
                  : null,
              child: avatarUrl == null || avatarUrl.isEmpty
                  ? Text(fullName.isNotEmpty ? fullName[0].toUpperCase() : '?',
                      style: const TextStyle(fontSize: 10, color: Colors.white))
                  : null,
            ),
            const SizedBox(width: 8),
            Text(
              fullName.isNotEmpty ? fullName : "Unassigned",
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusDropdown(BuildContext context, TaskEntity task) {
    final List<String> statusOptions = [
      'Pending',
      'In Progress',
      'Blocked',
      'Done'
    ];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: statusOptions.contains(task.status) ? task.status : 'Pending',
          isExpanded: true,
          dropdownColor: const Color(0xFF1E1E1E),
          style: const TextStyle(
              color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
          icon: const Icon(Icons.keyboard_arrow_down_rounded,
              color: Colors.white54),
          items: statusOptions.map((s) {
            return DropdownMenuItem(
              value: s,
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                        color: _getStatusColor(s), shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 12),
                  Text(s),
                ],
              ),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              context
                  .read<TaskDetailBloc>()
                  .add(UpdateTaskStatus(taskId: widget.taskId, status: value));
            }
          },
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Done':
        return Colors.greenAccent;
      case 'In Progress':
        return Colors.orangeAccent;
      case 'Blocked':
        return Colors.redAccent;
      default:
        return Colors.grey;
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'High':
        return Colors.redAccent;
      case 'Medium':
        return Colors.amberAccent;
      case 'Low':
        return Colors.greenAccent;
      default:
        return Colors.grey;
    }
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Delete Task", style: TextStyle(color: Colors.white)),
        content: const Text(
            "Are you sure you want to delete this task? This action cannot be undone.",
            style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:
                const Text("Cancel", style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Delete",
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
