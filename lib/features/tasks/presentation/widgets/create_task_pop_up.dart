import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hackathon/dependency_injection.g.dart';
import 'package:hackathon/features/tasks/domain/entities/task_entity.dart';
import 'package:hackathon/features/tasks/domain/repositories/task_repository.dart';
import 'package:hackathon/features/tasks/presentation/blocs/create_task_bloc/create_task_bloc.dart';
import 'package:hackathon/features/tasks/presentation/blocs/get_emp_bloc/get_employees_bloc.dart';
import 'package:hackathon/features/tasks/presentation/blocs/get_project_bloc/get_project_bloc.dart';
import 'package:hackathon/features/tasks/presentation/blocs/task_bloc/task_bloc.dart';
import 'package:hackathon/features/team/presentation/blocs/team_bloc/team_bloc.dart';
import 'package:hackathon/features/settings/domain/use_cases/get_task_types_use_case.dart';
import 'package:hackathon/widgets/task_button.dart';
import 'package:hackathon/globals/constants/color_pallete.dart';
import 'package:hackathon/globals/constants/user.dart';
import 'package:intl/intl.dart';

class CreateTaskPopUp extends StatefulWidget {
  const CreateTaskPopUp({super.key});

  @override
  State<CreateTaskPopUp> createState() => _CreateTaskPopUpState();
}

class _CreateTaskPopUpState extends State<CreateTaskPopUp> {
  DateTime? dueDate;
  int? assignedToID;
  String assignedTo = 'Assigned To';
  String type = 'Bug';
  String priority = 'Medium';
  String typeOfTask = "Personal";
  String status = "Pending";
  String? selectedTag;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  late CreateTaskParams createTaskParams;
  int? teamID;
  int? projectID;

  final List<String> _taskTypes = [];
  bool _isLoadingTypes = true;

  @override
  void initState() {
    super.initState();
    _loadTaskTypes();
    BlocProvider.of<GetEmployeesBloc>(context)
        .add(GetEmployees(token: getIt<User>().employeeToken ?? getIt<User>().token!));
  }

  Future<void> _loadTaskTypes() async {
    final result = await getIt<GetTaskTypesUseCase>().call();
    result.fold(
      (failure) {
        setState(() {
          _taskTypes.clear();
          _taskTypes.addAll(['Bug', 'Feature', 'Story']);
          type = _taskTypes.first;
          _isLoadingTypes = false;
        });
      },
      (types) {
        setState(() {
          _taskTypes.clear();
          if (types.isEmpty) {
            _taskTypes.addAll(['Bug', 'Feature', 'Story']);
          } else {
            _taskTypes.addAll(types.map((t) => t.name).toList());
          }
          type = _taskTypes.contains(type)
              ? type
              : _taskTypes.isNotEmpty
                  ? _taskTypes.first
                  : 'Bug';
          _isLoadingTypes = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final taskStyle = Theme.of(context).textTheme.bodyMedium;
    return Container(
      constraints: const BoxConstraints(minWidth: 200, maxWidth: 600),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              constraints: const BoxConstraints(minWidth: 200, maxWidth: 200),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: ColorPallete.backgroundPrimary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(child: Text('Create Task')),
            ),
            Container(
              decoration: BoxDecoration(
                color: ColorPallete.backgroundSecondary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: TextFormField(
                        style: taskStyle,
                        controller: _titleController,
                        decoration: _buildInputDecoration('Title'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: TextFormField(
                        controller: _descriptionController,
                        maxLines: 7,
                        style: taskStyle,
                        decoration: _buildInputDecoration('Description'),
                      ),
                    ),
                    Wrap(
                      direction: Axis.horizontal,
                      spacing: 20,
                      verticalDirection: VerticalDirection.down,
                      children: [
                        dateWidget(context, taskStyle!, width),
                        BlocBuilder<GetEmployeesBloc, GetEmployeesState>(
                          builder: (context, state) {
                            if (state is GetEmployeesLoading) {
                              return const Center(child: Text('Loading...'));
                            } else if (state is GetEmployeesSuccess) {
                              return dropdownWidget(context, taskStyle, width, [
                                const DropdownMenuItem(
                                    value: 'Assigned To',
                                    child: Text('Assigned To')),
                                ...state.employees.map((e) => DropdownMenuItem(
                                    value: e.id.toString(),
                                    child:
                                        Text('${e.firstName} ${e.lastName}'))),
                              ], (value) {
                                setState(() {
                                  assignedToID = int.parse(value);
                                  assignedTo = value;
                                });
                              }, assignedTo);
                            }
                            return const SizedBox();
                          },
                        ),
                        if (_isLoadingTypes)
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            height: 40,
                            width: width * 0.2,
                            child: const Center(
                              child: CircularProgressIndicator.adaptive(),
                            ),
                          )
                        else
                          dropdownWidget(context, taskStyle, width, 
                            _taskTypes.map((t) => DropdownMenuItem(
                              value: t,
                              child: Text(t),
                            )).toList(), 
                            (value) {
                              setState(() {
                                type = value;
                              });
                            }, type),
                        dropdownWidget(context, taskStyle, width, [
                          const DropdownMenuItem(
                              value: 'Medium', child: Text('Medium')),
                          const DropdownMenuItem(
                              value: 'High', child: Text('High')),
                          const DropdownMenuItem(
                              value: 'Low', child: Text('Low')),
                        ], (value) {
                          setState(() {
                            priority = value;
                          });
                        }, priority),
                      ],
                    ),
                    Wrap(
                      children: [
                        tagWidget('Team Task', context, taskStyle, width, 0,
                            () {
                          setState(() {
                            typeOfTask = "Team Task";
                            teamID = null;
                            projectID = null;
                          });
                          BlocProvider.of<TeamBloc>(context)
                              .add(GetTeamEvent(token: getIt<User>().employeeToken ?? getIt<User>().token!));
                        }),
                        tagWidget('Project Task', context, taskStyle, width, 1,
                            () {
                          setState(() {
                            typeOfTask = "Project Task";
                            teamID = null;
                            projectID = null;
                          });
                          context
                              .read<GetProjectBloc>()
                              .add(GetProjects(token: getIt<User>().employeeToken ?? getIt<User>().token!));
                        }),
                        tagWidget('Personal Task', context, taskStyle, width, 2,
                            () {
                          setState(() {
                            typeOfTask = "Personal Task";
                            teamID = null;
                            projectID = null;
                          });
                        }),
                      ],
                    ),
                    BlocBuilder<GetProjectBloc, GetProjectState>(
                      builder: (context, state) {
                        if (state is GetProjectsSuccess) {
                          final projects = state.projects;

                          if (typeOfTask == "Project Task") {
                            return Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  color: ColorPallete.textPrimary,
                                  borderRadius: BorderRadius.circular(20)),
                              child: DropdownButton(
                                  value: projectID,
                                  borderRadius: BorderRadius.circular(20),
                                  dropdownColor: ColorPallete.textPrimary,
                                  items: projects
                                      .map((e) => DropdownMenuItem(
                                            value: e.id,
                                            child: Text(
                                              e.name,
                                              style: taskStyle.copyWith(
                                                  color: ColorPallete.textSecondary),
                                            ),
                                          ))
                                      .toSet()
                                      .toList(),
                                  onChanged: (val) {
                                    setState(() {
                                      projectID = val;
                                    });
                                  }),
                            );
                          } else {
                            return const SizedBox();
                          }
                        } else if (state is GetProjectsFailure) {
                          return Text(state.error.message);
                        } else {
                          return const SizedBox();
                        }
                      },
                    ),
                    BlocBuilder<TeamBloc, TeamState>(
                      builder: (context, state) {
                        if (state is TeamSuccessState) {
                          final teams = state.teams.toSet().toList();

                          if (typeOfTask == "Team Task") {
                            return Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  color: ColorPallete.textPrimary,
                                  borderRadius: BorderRadius.circular(20)),
                              child: DropdownButton(
                                  value: teamID,
                                  borderRadius: BorderRadius.circular(20),
                                  dropdownColor: ColorPallete.textPrimary,
                                  items: teams
                                      .map((e) => DropdownMenuItem(
                                            value: e.id,
                                            child: Text(
                                              e.name,
                                              style: taskStyle.copyWith(
                                                  color: ColorPallete.textSecondary),
                                            ),
                                          ))
                                      .toSet()
                                      .toList(),
                                  onChanged: (val) {
                                    setState(() {
                                      teamID = val;
                                    });
                                  }),
                            );
                          } else {
                            return const SizedBox();
                          }
                        } else {
                          return const SizedBox();
                        }
                      },
                    ),
                    BlocConsumer<CreateTaskBloc, CreateTaskState>(
                      listener: (context, state) {
                        if (state is CreateTaskSuccess) {
                          context.read<TaskBloc>().add(
                              FetchTasksEvent(token: getIt<User>().employeeToken ?? getIt<User>().token!));
                          ElegantNotification.success(
                            description: const Text(
                              "Task Created Successfully",
                              style:
                                  TextStyle(color: ColorPallete.backgroundPrimary),
                            ),
                            position: Alignment.bottomRight,
                            width: width * 0.5,
                          ).show(context);
                          Navigator.pop(context);
                        } else if (state is CreateTaskFailure) {
                          ElegantNotification.error(
                            description: Text(
                              state.error.message,
                              style: const TextStyle(
                                  color: ColorPallete.backgroundPrimary),
                            ),
                            position: Alignment.bottomRight,
                            width: width * 0.5,
                          ).show(context);
                        }
                      },
                      builder: (context, state) {
                        if (state is CreateTaskLoading) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        return CustomTextButton(
                          width: width * 0.2,
                          text: const Text('Create Task'),
                          onTap: () {
                            try {
                              debugPrint("${getIt<User>().user!.id}");
                              debugPrint("${getIt<User>().organisation!.id}");
                              debugPrint("${getIt<User>().employeeToken ?? getIt<User>().token}");

                              createTaskParams = CreateTaskParams(
                                  token: getIt<User>().employeeToken ?? getIt<User>().token!,
                                  task: TaskEntity(
                                      title: _titleController.text.trim(),
                                      description:
                                          _descriptionController.text.trim(),
                                      dueDate: dueDate!,
                                      assignedTo: assignedToID!,
                                      assignedBy: getIt<User>().user!.id,
                                      type: type,
                                      priority: priority,
                                      status: status,
                                      teamId: teamID,
                                      projectId: projectID,
                                      organisationId:
                                          getIt<User>().organisation!.id!,
                                      isPersonal:
                                          selectedTag == 'Personal Task'));
                              BlocProvider.of<CreateTaskBloc>(context)
                                  .add(CreateTask(params: createTaskParams));
                            } catch (e) {
                              debugPrint(e.toString());
                            }
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
    );
  }

  Widget dateWidget(
    BuildContext context,
    TextStyle taskStyle,
    double width,
  ) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () async {
          final selectedDate = await _showDatePicker(context);
          if (selectedDate != null) {
            dueDate = selectedDate;
          }
          setState(() {});
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          height: 40,
          width: width * 0.2,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: ColorPallete.textPrimary,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Row(
            children: [
              Text(
                  dueDate != null
                      ? DateFormat('dd/MM/yyyy').format(dueDate!)
                      : 'Due Date',
                  style: taskStyle.copyWith(
                      fontSize: width * 0.015,
                      color: ColorPallete.backgroundPrimary)),
              const Spacer(),
              const Icon(Icons.calendar_month,
                  color: ColorPallete.backgroundPrimary, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  Future<DateTime?> _showDatePicker(BuildContext context) async {
    return await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 365)));
  }

  Widget dropdownWidget(
      BuildContext context,
      TextStyle taskStyle,
      double width,
      List<DropdownMenuItem<String>> items,
      Function(String) onTap,
      String title) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      height: 40,
      width: width * 0.2,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: ColorPallete.textPrimary,
        borderRadius: BorderRadius.circular(5),
      ),
      child: DropdownButton(
        isExpanded: true,
        dropdownColor: ColorPallete.textPrimary,
        items: items,
        value: title,
        icon: const Icon(Icons.arrow_drop_down,
            color: ColorPallete.backgroundPrimary, size: 20),
        style: taskStyle.copyWith(
            fontSize: width * 0.015, color: ColorPallete.backgroundPrimary),
        onChanged: (value) {
          onTap(value!);
        },
      ),
    );
  }

  Widget tagWidget(String text, BuildContext context, TextStyle taskStyle,
      double width, int index, Function ontap) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedTag = text;
          });
          ontap();
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          height: 40,
          width: width * 0.133,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
              color: selectedTag == text
                  ? ColorPallete.redPrimary
                  : ColorPallete.textPrimary,
              borderRadius: BorderRadius.circular(5)),
          child: Center(
            child: Text(text,
                maxLines: 1,
                overflow: TextOverflow.clip,
                style: taskStyle.copyWith(
                    fontSize: width * 0.015,
                    color: selectedTag == text
                        ? ColorPallete.textPrimary
                        : ColorPallete.backgroundPrimary)),
          ),
        ),
      ),
    );
  }
}
