import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hackathon/dependency_injection.g.dart';
import 'package:hackathon/features/projects/domain/entities/project_entity.dart';
import 'package:hackathon/features/projects/domain/entities/milestone_entity.dart';
import 'package:hackathon/features/projects/presentation/blocs/project_bloc/project_bloc.dart';
import 'package:hackathon/features/projects/presentation/blocs/project_bloc/project_event.dart';
import 'package:hackathon/features/projects/presentation/blocs/project_bloc/project_state.dart';
import 'package:hackathon/features/projects/presentation/widgets/project_status_badge.dart';
import 'package:hackathon/features/tasks/presentation/blocs/task_bloc/task_bloc.dart';
import 'package:hackathon/globals/constants/user.dart';
import 'package:hackathon/globals/constants/color_pallete.dart';
import 'package:intl/intl.dart';

class ProjectDetailPage extends StatefulWidget {
  static const String routePath = '/projects-detail';
  static const String routeName = 'projects-detail';
  final int projectId;

  const ProjectDetailPage({
    super.key,
    required this.projectId,
  });

  @override
  State<ProjectDetailPage> createState() => _ProjectDetailPageState();
}

class _ProjectDetailPageState extends State<ProjectDetailPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: ColorPallete.background2,
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: BlocProvider(
        create: (context) => getIt<ProjectsBloc>()..add(LoadProjectDetailEvent(widget.projectId)),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => context.pop(),
            ),
            title: const Text(
              'Project Details',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          body: BlocConsumer<ProjectsBloc, ProjectState>(
            listener: (context, state) {
              if (state is ProjectActionSuccess) {
                ElegantNotification.success(
                  title: const Text("Success"),
                  description: Text(state.message),
                ).show(context);
                context.read<ProjectsBloc>().add(LoadProjectDetailEvent(widget.projectId));
              } else if (state is ProjectError) {
                ElegantNotification.error(
                  title: const Text("Error"),
                  description: Text(state.message),
                ).show(context);
              }
            },
            builder: (context, state) {
              if (state is ProjectLoading) {
                return const Center(child: CircularProgressIndicator.adaptive(valueColor: AlwaysStoppedAnimation(Colors.white)));
              } else if (state is ProjectDetailLoaded) {
                final project = state.project;
                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.04,
                    vertical: height * 0.01,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeaderCard(context, project),
                      const SizedBox(height: 20),
                      _buildTabBar(),
                      const SizedBox(height: 16),
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            _buildMilestonesTab(context, project),
                            _buildTasksTab(context, project),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              } else if (state is ProjectError) {
                return _buildErrorState(context, state.message);
              } else {
                return const Center(child: CircularProgressIndicator.adaptive(valueColor: AlwaysStoppedAnimation(Colors.white)));
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard(BuildContext context, Project project) {
    // Calculate progress
    double progress = 0.0;
    if (project.milestones.isNotEmpty) {
      final completed = project.milestones.where((m) => m.status.toLowerCase() == 'completed').length;
      progress = completed / project.milestones.length;
    } else {
      switch (project.status.toLowerCase()) {
        case 'planning':
          progress = 0.15;
          break;
        case 'active':
          progress = 0.50;
          break;
        case 'completed':
          progress = 1.0;
          break;
        case 'on_hold':
        case 'paused':
          progress = 0.35;
          break;
        default:
          progress = 0.0;
      }
    }

    final dateRangeStr = '${DateFormat('MMMM dd, yyyy').format(project.startDate)} - ${DateFormat('MMMM dd, yyyy').format(project.endDate)}';

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF16161A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project.name,
                      style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      project.description.isNotEmpty ? project.description : 'No description provided.',
                      style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.4),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      ProjectStatusBadge(text: project.status),
                      const SizedBox(width: 8),
                      ProjectStatusBadge(text: project.priority, isPriority: true),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.people_outline_rounded, size: 16, color: Colors.white38),
                      const SizedBox(width: 6),
                      Text('Team ID: ${project.teamId}', style: const TextStyle(color: Colors.white38, fontSize: 13)),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(color: Colors.white10),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.calendar_month_rounded, size: 16, color: Colors.white54),
                  const SizedBox(width: 8),
                  Text(
                    dateRangeStr,
                    style: const TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              Row(
                children: [
                  const Text(
                    'Progress: ',
                    style: TextStyle(color: Colors.white38, fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${(progress * 100).toInt()}%',
                    style: const TextStyle(color: Colors.tealAccent, fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white.withAlpha(15),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.tealAccent),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF16161A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: TabBar(
        controller: _tabController,
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        indicator: BoxDecoration(
          color: Colors.white.withAlpha(15),
          borderRadius: BorderRadius.circular(10),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white38,
        tabs: const [
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.flag_outlined, size: 18),
                SizedBox(width: 8),
                Text('Milestones', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.assignment_outlined, size: 18),
                SizedBox(width: 8),
                Text('Tasks', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMilestonesTab(BuildContext parentContext, Project project) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${project.milestones.length} Milestones',
              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              icon: const Icon(Icons.add, size: 16),
              label: const Text('Add Milestone', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              onPressed: () => _showMilestoneDialog(parentContext, project.id, null),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Expanded(
          child: project.milestones.isEmpty
              ? _buildEmptyTabState(Icons.flag_outlined, 'No milestones defined', 'Define major project milestones to track execution progress.')
              : ListView.builder(
                  itemCount: project.milestones.length,
                  itemBuilder: (context, index) {
                    final milestone = project.milestones[index];
                    return _buildMilestoneTile(parentContext, milestone);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildMilestoneTile(BuildContext parentContext, Milestone milestone) {
    final cleanStatus = milestone.status.toLowerCase();
    final isCompleted = cleanStatus == 'completed';
    
    Color statusColor;
    if (isCompleted) {
      statusColor = const Color(0xFF34D399); // emerald-400
    } else if (milestone.isOverdue) {
      statusColor = const Color(0xFFF87171); // red-400
    } else {
      statusColor = const Color(0xFFFACC15); // yellow-400
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF16161A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: milestone.isOverdue && !isCompleted ? Colors.redAccent.withAlpha(50) : Colors.white10,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isCompleted ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
            color: isCompleted ? const Color(0xFF34D399) : Colors.white38,
            size: 24,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  milestone.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    decoration: isCompleted ? TextDecoration.lineThrough : null,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  milestone.description.isNotEmpty ? milestone.description : 'No details provided.',
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.calendar_today_rounded, size: 11, color: milestone.isOverdue && !isCompleted ? Colors.redAccent : Colors.white38),
                    const SizedBox(width: 4),
                    Text(
                      'Due: ${DateFormat('MMM dd, yyyy').format(milestone.dueDate)}',
                      style: TextStyle(
                        color: milestone.isOverdue && !isCompleted ? Colors.redAccent : Colors.white54,
                        fontSize: 11,
                        fontWeight: milestone.isOverdue && !isCompleted ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    if (milestone.isOverdue && !isCompleted) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(color: const Color(0xFF7F1D1D), borderRadius: BorderRadius.circular(4)),
                        child: const Text('OVERDUE', style: TextStyle(color: Color(0xFFF87171), fontSize: 9, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withAlpha(20),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: statusColor.withAlpha(50)),
            ),
            child: Text(
              milestone.status.toUpperCase(),
              style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 8),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded, color: Colors.white54),
            color: const Color(0xFF16161A),
            onSelected: (val) {
              if (val == 'edit') {
                _showMilestoneDialog(parentContext, milestone.projectId, milestone);
              } else if (val == 'delete') {
                _confirmDeleteMilestone(parentContext, milestone);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit_outlined, size: 16, color: Colors.white70),
                    SizedBox(width: 8),
                    Text('Edit Details', style: TextStyle(color: Colors.white70)),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline_rounded, size: 16, color: Colors.redAccent),
                    SizedBox(width: 8),
                    Text('Delete Milestone', style: TextStyle(color: Colors.redAccent)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTasksTab(BuildContext context, Project project) {
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        if (state is TaskLoading) {
          return const Center(child: CircularProgressIndicator.adaptive());
        } else if (state is TaskSuccess) {
          final projectTasks = state.tasks.where((t) => t.projectId == project.id).toList();

          if (projectTasks.isEmpty) {
            return _buildEmptyTabState(Icons.assignment_outlined, 'No tasks linked to project', 'Create tasks and link them to this project to keep your workflow synchronized.');
          }

          return ListView.builder(
            itemCount: projectTasks.length,
            itemBuilder: (context, index) {
              final task = projectTasks[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF16161A),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white10),
                ),
                child: Row(
                  children: [
                    Icon(
                      task.type.toLowerCase() == 'bug' ? Icons.bug_report_outlined : Icons.assignment_outlined,
                      color: task.type.toLowerCase() == 'bug' ? Colors.redAccent : Colors.tealAccent,
                      size: 20,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            task.title,
                            style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            task.description ?? 'No details provided.',
                            style: const TextStyle(color: Colors.white54, fontSize: 12),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Text('Priority: ${task.priority}', style: const TextStyle(color: Colors.white38, fontSize: 11)),
                              const SizedBox(width: 12),
                              Text('Assigned User ID: ${task.assignedTo}', style: const TextStyle(color: Colors.white38, fontSize: 11)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(10),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        task.status,
                        style: const TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        } else {
          return _buildEmptyTabState(Icons.assignment_outlined, 'Tasks data unavailable', 'Ensure you have permissions to load workspace tasks.');
        }
      },
    );
  }

  void _showMilestoneDialog(BuildContext parentContext, int projectId, Milestone? milestoneToEdit) {
    final formKey = GlobalKey<FormState>();
    final titleController = TextEditingController(text: milestoneToEdit?.title ?? '');
    final descController = TextEditingController(text: milestoneToEdit?.description ?? '');
    
    DateTime selectedDueDate = milestoneToEdit?.dueDate ?? DateTime.now().add(const Duration(days: 7));
    String selectedStatus = milestoneToEdit?.status ?? 'pending';

    showDialog<bool>(
      context: parentContext,
      builder: (dialogCtx) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: const Color(0xFF0F0F11),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Colors.white10),
          ),
          title: Text(
            milestoneToEdit == null ? 'Add Milestone' : 'Edit Milestone',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('TITLE', style: TextStyle(color: Colors.white38, fontSize: 9, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: titleController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Milestone target name',
                      hintStyle: const TextStyle(color: Colors.white24),
                      filled: true,
                      fillColor: const Color(0xFF16161A),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.white10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.white38),
                      ),
                    ),
                    validator: (val) => (val == null || val.trim().isEmpty) ? 'Title is required' : null,
                  ),
                  const SizedBox(height: 12),

                  const Text('DETAILS', style: TextStyle(color: Colors.white38, fontSize: 9, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: descController,
                    style: const TextStyle(color: Colors.white),
                    maxLines: 2,
                    decoration: InputDecoration(
                      hintText: 'Scope description',
                      hintStyle: const TextStyle(color: Colors.white24),
                      filled: true,
                      fillColor: const Color(0xFF16161A),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.white10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.white38),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: selectedDueDate,
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2101),
                              builder: (context, child) => Theme(
                                data: ThemeData.dark().copyWith(
                                  colorScheme: const ColorScheme.dark(
                                    primary: Colors.white,
                                    onPrimary: Colors.black,
                                    surface: Color(0xFF16161A),
                                    onSurface: Colors.white,
                                  ),
                                ),
                                child: child!,
                              ),
                            );
                            if (picked != null) {
                              setState(() {
                                selectedDueDate = picked;
                              });
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF16161A),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.white10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('DUE DATE', style: TextStyle(color: Colors.white38, fontSize: 9, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                Text(DateFormat('MMM dd, yyyy').format(selectedDueDate), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('STATUS', style: TextStyle(color: Colors.white38, fontSize: 9, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            DropdownButtonFormField<String>(
                              value: selectedStatus,
                              dropdownColor: const Color(0xFF16161A),
                              style: const TextStyle(color: Colors.white, fontSize: 13),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: const Color(0xFF16161A),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(color: Colors.white10),
                                ),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              ),
                              items: const [
                                DropdownMenuItem(value: 'pending', child: Text('PENDING')),
                                DropdownMenuItem(value: 'in_progress', child: Text('IN PROGRESS')),
                                DropdownMenuItem(value: 'completed', child: Text('COMPLETED')),
                                DropdownMenuItem(value: 'cancelled', child: Text('CANCELLED')),
                              ],
                              onChanged: (val) => setState(() => selectedStatus = val!),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final orgId = getIt<User>().organisation?.id ?? 0;
                  
                  final milestone = Milestone(
                    id: milestoneToEdit?.id ?? 0,
                    projectId: projectId,
                    title: titleController.text.trim(),
                    description: descController.text.trim(),
                    dueDate: selectedDueDate,
                    status: selectedStatus,
                    isOverdue: selectedDueDate.isBefore(DateTime.now()) && selectedStatus != 'completed',
                    organisationId: orgId,
                  );

                  final bloc = parentContext.read<ProjectsBloc>();
                  if (!bloc.isClosed) {
                    if (milestoneToEdit == null) {
                      bloc.add(CreateMilestoneEvent(milestone));
                    } else {
                      bloc.add(UpdateMilestoneEvent(milestone));
                    }
                  }
                  Navigator.pop(context, true);
                }
              },
              child: Text(milestoneToEdit == null ? 'Add' : 'Save', style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDeleteMilestone(BuildContext parentContext, Milestone milestone) {
    showDialog<bool>(
      context: parentContext,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF0F0F11),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Colors.white10),
        ),
        title: const Text('Delete Milestone', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: Text('Are you sure you want to delete "${milestone.title}"?', style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    ).then((confirmed) {
      if (confirmed == true && parentContext.mounted) {
        final bloc = parentContext.read<ProjectsBloc>();
        if (!bloc.isClosed) {
          bloc.add(DeleteMilestoneEvent(
            projectId: milestone.projectId,
            milestoneId: milestone.id,
          ));
        }
      }
    });
  }

  Widget _buildEmptyTabState(IconData icon, String title, String subText) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: Colors.white24),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(color: Colors.white70, fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Text(
                subText,
                style: const TextStyle(color: Colors.white38, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline_rounded, size: 64, color: Colors.redAccent),
          const SizedBox(height: 16),
          const Text('Error Loading Details', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(message, style: const TextStyle(color: Colors.white54, fontSize: 13), textAlign: TextAlign.center),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white10,
              side: const BorderSide(color: Colors.white24),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              context.read<ProjectsBloc>().add(LoadProjectDetailEvent(widget.projectId));
            },
            child: const Text('Retry', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
