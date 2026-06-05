import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hackathon/dependency_injection.g.dart';
import 'package:hackathon/features/tasks/presentation/blocs/task_bloc/task_bloc.dart';
import 'package:hackathon/features/tasks/presentation/widgets/create_task_pop_up.dart';
import 'package:hackathon/globals/constants/color_pallete.dart';
import 'package:hackathon/globals/constants/user.dart';
import 'package:intl/intl.dart';

class MyTasksSummaryWidget extends StatelessWidget {
  const MyTasksSummaryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorPallete.background2[0].withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TaskLoading) {
            return _ShimmerTaskSummary();
          }

          if (state is TaskSuccess) {
            final tasks = state.tasks;
            final pendingCount = tasks.where((t) => t.status == 'Pending').length;
            final inProgressCount = tasks.where((t) => t.status == 'In Progress').length;
            final blockedCount = tasks.where((t) => t.status == 'Blocked').length;
            final doneCount = tasks.where((t) => t.status == 'Done').length;

            final upcomingTasks = tasks
                .where((t) => t.status != 'Done')
                .toList()
              ..sort((a, b) => a.dueDate.compareTo(b.dueDate));
            final top3Upcoming = upcomingTasks.take(3).toList();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "My Tasks",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: ColorPallete.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    TextButton(
                      onPressed: () => context.push('/task'),
                      child: const Text("View All", style: TextStyle(fontSize: 12)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _TaskStat(label: "Pending", count: pendingCount.toString(), color: Colors.orangeAccent),
                    _TaskStat(label: "Active", count: inProgressCount.toString(), color: Colors.blueAccent),
                    _TaskStat(label: "Blocked", count: blockedCount.toString(), color: Colors.redAccent),
                    _TaskStat(label: "Done", count: doneCount.toString(), color: Colors.greenAccent),
                  ],
                ),
                if (top3Upcoming.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  Text(
                    "Upcoming Deadlines",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: ColorPallete.white.withOpacity(0.5),
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  ...top3Upcoming.map((task) => _UpcomingTaskTile(task: task)),
                ] else if (tasks.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Center(
                      child: Column(
                        children: [
                          const Text("No tasks assigned", style: TextStyle(color: Colors.white54, fontSize: 12)),
                          const SizedBox(height: 8),
                          ElevatedButton.icon(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => const CreateTaskPopUp(),
                              );
                            },
                            icon: const Icon(Icons.add, size: 14),
                            label: const Text("Create Task", style: TextStyle(fontSize: 12)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white10,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            );
          }

          if (state is TaskError) {
            return Center(
              child: TextButton(
                onPressed: () => context.read<TaskBloc>().add(FetchTasksEvent(token: getIt<User>().token!)),
                child: const Text("Retry loading tasks"),
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}

class _TaskStat extends StatelessWidget {
  final String label;
  final String count;
  final Color color;

  const _TaskStat({
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          count,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: ColorPallete.white.withOpacity(0.7),
                fontSize: 10,
              ),
        ),
      ],
    );
  }
}

class _UpcomingTaskTile extends StatelessWidget {
  final dynamic task;

  const _UpcomingTaskTile({required this.task});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push('/task-detail/${task.id}'),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: task.priority == 'High' ? Colors.redAccent : Colors.blueAccent,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                task.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white, fontSize: 13),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              DateFormat('dd MMM').format(task.dueDate),
              style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShimmerTaskSummary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(3, (index) => Column(
            children: [
              Container(width: 30, height: 24, decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(4))),
              const SizedBox(height: 8),
              Container(width: 50, height: 10, decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(5))),
            ],
          )),
        ),
      ],
    );
  }
}
