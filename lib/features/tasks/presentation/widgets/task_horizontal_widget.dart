import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hackathon/features/tasks/domain/entities/task_entity.dart';
import 'package:hackathon/features/tasks/domain/repositories/task_repository.dart';
import 'package:hackathon/features/tasks/presentation/blocs/task_bloc/task_bloc.dart';
import 'package:hackathon/globals/constants/color_pallete.dart';
import 'package:intl/intl.dart';

class TaskHorizontalWidget extends StatefulWidget {
  final TaskEntity task;
  const TaskHorizontalWidget({super.key, required this.task});

  @override
  State<TaskHorizontalWidget> createState() => _TaskHorizontalWidgetState();
}

class _TaskHorizontalWidgetState extends State<TaskHorizontalWidget> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    final dropDownStyle =
        Theme.of(context).textTheme.bodyMedium!.copyWith(color: ColorPallete.textPrimary);
    final textStyle =
        Theme.of(context).textTheme.bodyMedium!.copyWith(color: ColorPallete.textSecondary);
    return GestureDetector(
      onTap: () => context.push('/task-detail/${widget.task.id}'),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Draggable(
          feedback: Material(
            color: ColorPallete.transparent,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              color: ColorPallete.redPrimary,
              child: Text(
                widget.task.title,
                style: const TextStyle(color: ColorPallete.textPrimary),
              ),
            ),
          ),
          child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: ColorPallete.textPrimary,
          ),
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: ExpansionTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            collapsedIconColor: ColorPallete.backgroundPrimary,
            leading: const Icon(Icons.menu),
            iconColor: ColorPallete.backgroundPrimary,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.task.title, style: textStyle),
                Text(widget.task.description ?? 'No description',
                    style: textStyle.copyWith(fontSize: 10)),
              ],
            ),
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: ColorPallete.textPrimary,
                ),
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (widget.task.isPersonal)
                      Text(
                        "Type: Personal",
                        style: textStyle.copyWith(
                            fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    if (widget.task.team != null)
                      Text("Team: ${widget.task.team?.name}",
                          style: textStyle.copyWith(
                              fontSize: 10, fontWeight: FontWeight.bold)),
                    if (widget.task.project != null)
                      Text("Team: ${widget.task.project?.name}",
                          style: textStyle.copyWith(
                              fontSize: 10, fontWeight: FontWeight.bold)),
                    Text(
                        'Due Date: ${DateFormat('dd/MM/yyyy').format(widget.task.dueDate)}',
                        style: textStyle.copyWith(
                            fontSize: 10, fontWeight: FontWeight.bold)),
                    Text(
                        'Created At: ${DateFormat('dd/MM/yyyy').format(widget.task.createdAt ?? DateTime.now())}',
                        style: textStyle.copyWith(
                            fontSize: 10, fontWeight: FontWeight.bold)),
                    Text(
                        'Assigned By: ${widget.task.assignedByUser!.firstName} ${widget.task.assignedByUser!.lastName}',
                        style: textStyle.copyWith(
                            fontSize: 10, fontWeight: FontWeight.bold)),
                    Text(
                        'Assigned To: ${widget.task.assignedUser!.firstName} ${widget.task.assignedUser!.lastName}',
                        style: textStyle.copyWith(
                            fontSize: 10, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: ColorPallete.backgroundPrimary,
                ),
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Priority: ${widget.task.priority}'),
                    Text('Type: ${widget.task.type}'),
                  ],
                ),
              ),
              SizedBox(height: height * 0.01),
              Align(
                alignment: Alignment.bottomRight,
                child: _statusDropDown(width, height, dropDownStyle),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

  Container _statusDropDown(
      double width, double height, TextStyle dropDownStyle) {
    final List<String> statusOptions = [
      'In Progress',
      'Blocked',
      'Done',
      'Pending'
    ];

    // Ensure task status is valid, default to 'Pending' if not
    final String currentStatus =
        statusOptions.contains(widget.task.status) ? widget.task.status : 'Pending';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: ColorPallete.textSecondary,
        borderRadius: BorderRadius.circular(5),
      ),
      width: width * 0.20,
      height: height * 0.06,
      child: DropdownButton<String>(
        icon: const Icon(Icons.arrow_drop_down_outlined, size: 10),
        isExpanded: true,
        focusColor: ColorPallete.transparent,
        underline: const SizedBox(),
        value: currentStatus,
        style: dropDownStyle,
        items: statusOptions.map((String status) {
          return DropdownMenuItem<String>(
            value: status,
            onTap: () {
              // Status mutation is handled by the BLoC event
            },
            child: Text(status, style: dropDownStyle),
          );
        }).toList(),
        onChanged: (value) {
          if (value != null) {
            context.read<TaskBloc>().add(UpdateTaskEvent(
                params: UpdateTaskParams(id: widget.task.id!, status: value)));
          }
        },
      ),
    );
  }
}
