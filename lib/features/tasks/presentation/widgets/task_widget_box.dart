import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hackathon/features/tasks/domain/entities/task_entity.dart';
import 'package:hackathon/features/tasks/domain/repositories/task_repository.dart';
import 'package:hackathon/features/tasks/presentation/blocs/task_bloc/task_bloc.dart';
import 'package:hackathon/globals/constants/color_pallete.dart';

class TaskWidgetBox extends StatefulWidget {
  final TaskEntity task;
  const TaskWidgetBox({super.key, required this.task});

  @override
  State<TaskWidgetBox> createState() => _TaskWidgetBoxState();
}

class _TaskWidgetBoxState extends State<TaskWidgetBox> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final taskStyle = Theme.of(context).textTheme.bodyMedium;
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    final dropDownStyle = taskStyle!
        .copyWith(fontSize: width * 0.005, overflow: TextOverflow.clip);
    return Draggable(
      feedback: Material(
        color: ColorPallete.transparent,
        child: AnimatedContainer(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          width: width * 0.2,
          curve: Curves.easeInBack,
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 63, 63, 63),
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.only(bottom: 10, top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.task.title,
                style: taskStyle,
              ),
              ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                leading: _statusDropDown(width, height, dropDownStyle),
                title: Text(widget.task.type,
                    style: taskStyle.copyWith(
                        fontSize: width * 0.015, color: ColorPallete.error)),
                trailing: Icon(Icons.menu,
                    size: height * 0.025,
                    color: widget.task.priority == 'High'
                        ? ColorPallete.error
                        : widget.task.priority == 'Medium'
                            ? ColorPallete.warning
                            : ColorPallete.success),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Text('Created at: ${widget.task.createdAt}'),
                  Text(
                    'Due date: ${widget.task.dueDate.day}/${widget.task.dueDate.month}/${widget.task.dueDate.year}',
                    style: taskStyle.copyWith(fontSize: width * 0.0065),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      child: GestureDetector(
        onTap: () => context.push('/task-detail/${widget.task.id}'),
        child: MouseRegion(
          onEnter: (_) => setState(() => isHovered = true),
          onExit: (_) => setState(() => isHovered = false),
          cursor: SystemMouseCursors.click,
          child: Transform.scale(
            scale: isHovered ? 1.05 : 1,
            child: AnimatedContainer(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              width: width * 0.2,
              curve: Curves.easeInBack,
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 63, 63, 63),
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.only(bottom: 10, top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.task.title,
                    style: taskStyle,
                  ),
                  ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    leading: _statusDropDown(width, height, dropDownStyle),
                    title: Text(widget.task.type,
                        style: taskStyle.copyWith(
                            fontSize: width * 0.015, color: ColorPallete.error)),
                    trailing: Icon(Icons.menu,
                        size: height * 0.025,
                        color: widget.task.priority == 'High'
                            ? ColorPallete.error
                            : widget.task.priority == 'Medium'
                                ? ColorPallete.warning
                                : ColorPallete.success),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Text('Created at: ${widget.task.createdAt}'),
                      Text(
                        'Due date: ${widget.task.dueDate.day}/${widget.task.dueDate.month}/${widget.task.dueDate.year}',
                        style: taskStyle.copyWith(fontSize: width * 0.0065),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container _statusDropDown(
      double width, double height, TextStyle dropDownStyle) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: ColorPallete.textSecondary,
        borderRadius: BorderRadius.circular(2),
      ),
      width: width * 0.05,
      height: height * 0.025,
      child: DropdownButton<String>(
        icon: const Icon(Icons.arrow_drop_down_outlined, size: 10),
        isExpanded: true,
        focusColor: ColorPallete.transparent,
        underline: const SizedBox(),
        value: widget.task.status,
        style: dropDownStyle,
        items: [
          DropdownMenuItem<String>(
            value: 'In Progress',
            onTap: () {
              // Status mutation is handled by the BLoC event
            },
            child: Text('In Progress', style: dropDownStyle),
          ),
          DropdownMenuItem<String>(
            value: 'Blocked',
            onTap: () {
              // Status mutation is handled by the BLoC event
            },
            child: Text('Blocked', style: dropDownStyle),
          ),
          DropdownMenuItem<String>(
            value: 'Done',
            onTap: () {
              // Status mutation is handled by the BLoC event
            },
            child: Text('Done', style: dropDownStyle),
          ),
          DropdownMenuItem<String>(
            value: 'Pending',
            onTap: () {
              // Status mutation is handled by the BLoC event
            },
            child: Text('Pending', style: dropDownStyle),
          ),
        ],
        onChanged: (value) {
          context.read<TaskBloc>().add(UpdateTaskEvent(
              params: UpdateTaskParams(id: widget.task.id!, status: value)));
        },
      ),
    );
  }
}
