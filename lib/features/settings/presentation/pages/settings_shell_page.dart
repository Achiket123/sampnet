import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hackathon/dependency_injection.g.dart';
import 'package:hackathon/features/tasks/presentation/blocs/task_bloc/task_bloc.dart';
import 'package:hackathon/features/tasks/presentation/widgets/create_task_pop_up.dart';
import 'package:hackathon/widgets/task_button.dart';
import 'package:hackathon/features/tasks/presentation/widgets/task_horizontal_widget.dart';
import 'package:hackathon/features/tasks/presentation/widgets/task_widget_box.dart';
import 'package:hackathon/features/tasks/presentation/widgets/task_widget_holder.dart';
import 'package:hackathon/globals/constants/user.dart';
import 'package:hackathon/widgets/custom_drawer.dart';
import 'package:hackathon/globals/constants/color_pallete.dart';
import 'package:hackathon/widgets/custom_app_bar.dart';
import 'package:hackathon/widgets/list_of_side_bar.dart';

final GlobalKey<ScaffoldState> _taskPageKey = GlobalKey<ScaffoldState>();

class SettingsShellPage extends StatefulWidget {
  static const String routePath = '/settings';
  const SettingsShellPage({super.key});

  @override
  State<SettingsShellPage> createState() => _SettingsShellPageState();
}

class _SettingsShellPageState extends State<SettingsShellPage> {
  String _initialValue = 'All';
  bool isDrawerOpen = false;

  @override
  void initState() {
    super.initState();
    // if(awaitgetIt.allReady())
    BlocProvider.of<TaskBloc>(context).add(FetchTasksEvent(
        token: getIt<User>().employeeToken ?? getIt<User>().token!));
  }

  @override
  Widget build(BuildContext context) {
    final taskStyle = Theme.of(context).textTheme.bodySmall;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ColorPallete.backgroundPrimary,
            ColorPallete.backgroundSecondary
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        key: _taskPageKey,
        drawer: CustomDrawer(
          selectedIndex: ListOfSideBar.sideBarItems.indexOf('Tasks'),
        ),
        backgroundColor: ColorPallete.transparent,
        body: ListView(
          children: [
            _appBar(context),
            _belowAppBar(width, taskStyle),
            _showEveryTasks(height, width, taskStyle),
            const Center(child: Text('YOUR TASKS')),
            _showOwnTasks(height, width),
          ],
        ),
      ),
    );
  }

  Container _showOwnTasks(double height, double width) {
    return Container(
      height: height,
      margin: EdgeInsets.symmetric(
          horizontal: width * 0.02, vertical: height * 0.02),
      padding: EdgeInsets.symmetric(vertical: height * 0.012),
      decoration: BoxDecoration(
        color: ColorPallete.backgroundSecondary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: BlocBuilder<TaskBloc, TaskState>(builder: (context, state) {
        if (state is TaskSuccess) {
          return ListView.builder(
              itemCount: state.tasks.length,
              itemBuilder: (context, index) {
                if (state.tasks[index].status != "To Do" &&
                    state.tasks[index].assignedTo == getIt<User>().user!.id) {
                  return TaskHorizontalWidget(
                    task: state.tasks[index],
                  );
                } else {
                  return const SizedBox.shrink();
                }
              });
        } else if (state is TaskError) {
          return const Text("Internal Error");
        } else if (state is TaskLoading) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        } else {
          return const Text("No Tasks");
        }
      }),
    );
  }

  Widget _showEveryTasks(double height, double width, TextStyle? taskStyle) {
    return Container(
      width: double.infinity,
      height: height * 0.7,
      margin: EdgeInsets.symmetric(
          horizontal: width * 0.02, vertical: height * 0.02),
      padding: EdgeInsets.symmetric(vertical: height * 0.012),
      decoration: BoxDecoration(
        color: ColorPallete.backgroundSecondary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          BlocConsumer<TaskBloc, TaskState>(
            listener: (context, state) {
              if (state is TaskError) {
                ElegantNotification.error(
                    description: const Text(
                  "data not found",
                  style: TextStyle(color: ColorPallete.backgroundPrimary),
                )).show(context);
              }
            },
            builder: (context, state) {
              if (state is TaskLoading) {
                return const Center(
                    child: CircularProgressIndicator.adaptive());
              }
              if (state is TaskSuccess) {
                debugPrint(
                  state.tasks.toString(),
                );
                for (var i in state.tasks) {
                  debugPrint(
                    i.status,
                  );
                }
                return TaskWidgetHolder(
                  text: Text('Pending',
                      style: taskStyle!.copyWith(fontSize: width * 0.015)),
                  children: [
                    for (var task in state.tasks)
                      if (task.status == "Pending" && _initialValue == "All")
                        TaskWidgetBox(task: task)
                      else if (task.status == "Pending" &&
                          _initialValue == "Team Tasks" &&
                          task.team != null)
                        TaskWidgetBox(
                          task: task,
                        )
                      else if (task.status == "Pending" &&
                          _initialValue == "Team Tasks" &&
                          task.project != null)
                        TaskWidgetBox(task: task)
                  ],
                );
              } else {
                return TaskWidgetHolder(
                  text: Text('Pending',
                      style: taskStyle!.copyWith(fontSize: width * 0.015)),
                  children: const [],
                );
              }
            },
          ),
          const VerticalDivider(
            color: ColorPallete.textPrimary,
            thickness: 2,
          ),
          BlocBuilder<TaskBloc, TaskState>(
            builder: (context, state) {
              if (state is TaskSuccess) {
                return TaskWidgetHolder(
                  text: Text('In Progress',
                      style: taskStyle!.copyWith(fontSize: width * 0.015)),
                  children: [
                    for (var task in state.tasks)
                      if (task.status == "In Progress" &&
                          _initialValue == "All")
                        TaskWidgetBox(task: task)
                      else if (task.status == "In Progress" &&
                          _initialValue == "Team Tasks" &&
                          task.team != null)
                        TaskWidgetBox(
                          task: task,
                        )
                      else if (task.status == "In Progress" &&
                          _initialValue == "Team Tasks" &&
                          task.project != null)
                        TaskWidgetBox(task: task)
                  ],
                );
              }
              return TaskWidgetHolder(
                text: Text('In Progress',
                    style: taskStyle!.copyWith(fontSize: width * 0.015)),
                children: const [],
              );
            },
          ),
          const VerticalDivider(
            color: ColorPallete.textPrimary,
            thickness: 2,
          ),
          BlocBuilder<TaskBloc, TaskState>(
            builder: (context, state) {
              if (state is TaskSuccess) {
                return TaskWidgetHolder(
                  text: Text('Done',
                      style: taskStyle!.copyWith(fontSize: width * 0.015)),
                  children: [
                    for (var task in state.tasks)
                      if (task.status == "Done" && _initialValue == "All")
                        TaskWidgetBox(task: task)
                      else if (task.status == "Done" &&
                          _initialValue == "Team Tasks" &&
                          task.team != null)
                        TaskWidgetBox(
                          task: task,
                        )
                      else if (task.status == "Done" &&
                          _initialValue == "Team Tasks" &&
                          task.project != null)
                        TaskWidgetBox(task: task)
                  ],
                );
              }
              return TaskWidgetHolder(
                text: Text('Done',
                    style: taskStyle!.copyWith(fontSize: width * 0.015)),
                children: const [],
              );
            },
          ),
          const VerticalDivider(
            color: ColorPallete.textPrimary,
            thickness: 2,
          ),
          BlocBuilder<TaskBloc, TaskState>(
            builder: (context, state) {
              if (state is TaskSuccess) {
                return TaskWidgetHolder(
                  text: Text('Blocked',
                      style: taskStyle!.copyWith(fontSize: width * 0.015)),
                  children: [
                    for (var task in state.tasks)
                      if (task.status == "Blocked" && _initialValue == "All")
                        TaskWidgetBox(task: task)
                      else if (task.status == "Blocked" &&
                          _initialValue == "Team Tasks" &&
                          task.team != null)
                        TaskWidgetBox(
                          task: task,
                        )
                      else if (task.status == "Blocked" &&
                          _initialValue == "Team Tasks" &&
                          task.project != null)
                        TaskWidgetBox(task: task)
                  ],
                );
              }
              return TaskWidgetHolder(
                text: Text('Blocked',
                    style: taskStyle!.copyWith(fontSize: width * 0.015)),
                children: const [],
              );
            },
          ),
        ],
      ),
    );
  }

  Padding _belowAppBar(double width, TextStyle? taskStyle) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: ColorPallete.textSecondary,
              borderRadius: BorderRadius.circular(10),
            ),
            width: width * 0.15,
            child: DropdownButton<String>(
              icon: const Icon(Icons.arrow_drop_down_outlined),
              isExpanded: true,
              focusColor: ColorPallete.transparent,
              underline: const SizedBox(),
              value: _initialValue,
              style: taskStyle,
              items: [
                DropdownMenuItem<String>(
                  value: 'All',
                  onTap: () {
                    setState(() {
                      _initialValue = 'All';
                    });
                  },
                  child: Text('All',
                      style: taskStyle!.copyWith(fontSize: width * 0.015)),
                ),
                DropdownMenuItem<String>(
                  value: 'Team Tasks',
                  onTap: () {
                    setState(() {
                      _initialValue = 'Team Tasks';
                    });
                  },
                  child: Text('Team Tasks',
                      style: taskStyle.copyWith(fontSize: width * 0.015)),
                ),
                DropdownMenuItem<String>(
                  value: 'Personal Tasks',
                  onTap: () {
                    setState(() {
                      _initialValue = 'Personal Tasks';
                    });
                  },
                  child: Text('Personal Tasks',
                      style: taskStyle.copyWith(fontSize: width * 0.015)),
                ),
                DropdownMenuItem<String>(
                  value: 'Project Tasks',
                  onTap: () {
                    setState(() {
                      _initialValue = 'Project Tasks';
                    });
                  },
                  child: Text('Project Tasks',
                      style: taskStyle.copyWith(fontSize: width * 0.015)),
                ),
              ],
              onChanged: (value) {},
            ),
          ),
          CustomTextButton(
            width: width * 0.15,
            text: Text(
              'Create Task',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: taskStyle.copyWith(fontSize: width * 0.015),
            ),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) => const Dialog(
                      backgroundColor: ColorPallete.transparent,
                      child: CreateTaskPopUp()));
            },
          ),
        ],
      ),
    );
  }

  CustomAppBar _appBar(BuildContext context) {
    return CustomAppBar(
      children: [
        Text(
          'TASK',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const Spacer(),
        IconButton(
          onPressed: () {
            _taskPageKey.currentState?.openDrawer();
          },
          icon: const Icon(
            Icons.menu,
            color: ColorPallete.textPrimary,
          ),
        ),
      ],
    );
  }
}
