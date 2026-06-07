import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hackathon/dependency_injection.g.dart';
import 'package:hackathon/features/calendar/domain/entities/calendar_event_entity.dart';
import 'package:hackathon/features/tasks/domain/entities/task_entity.dart';
import 'package:hackathon/features/tasks/domain/repositories/task_repository.dart';
import 'package:hackathon/features/tasks/presentation/blocs/create_task_bloc/create_task_bloc.dart';
import 'package:hackathon/features/tasks/presentation/blocs/get_emp_bloc/get_employees_bloc.dart';
import 'package:hackathon/globals/constants/color_pallete.dart';
import 'package:hackathon/globals/constants/user.dart';
import 'package:hackathon/widgets/task_button.dart';
import 'package:intl/intl.dart';

class CreateEventDialog extends StatefulWidget {
  final DateTime initialDateTime;
  final String token;
  final CalendarViewType viewType;
  final VoidCallback onSuccess;

  const CreateEventDialog({
    super.key,
    required this.initialDateTime,
    required this.token,
    required this.viewType,
    required this.onSuccess,
  });

  @override
  State<CreateEventDialog> createState() => _CreateEventDialogState();
}

class _CreateEventDialogState extends State<CreateEventDialog> {
  late final GetEmployeesBloc _getEmployeesBloc;
  late final CreateTaskBloc _createTaskBloc;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  late DateTime _dueDate;
  int? _assignedToID;
  String _eventType = 'Meeting'; // Default to meeting as requested
  String _priority = 'Medium';
  late bool _isPersonal;

  @override
  void initState() {
    super.initState();
    _getEmployeesBloc = getIt<GetEmployeesBloc>();
    _createTaskBloc = getIt<CreateTaskBloc>();
    
    _dueDate = widget.initialDateTime;
    _isPersonal = widget.viewType == CalendarViewType.personal;
    _assignedToID = getIt<User>().user?.id;

    _getEmployeesBloc.add(GetEmployees(token: widget.token));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _getEmployeesBloc.close();
    _createTaskBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final taskStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(color: ColorPallete.textPrimary);

    return Dialog(
      backgroundColor: ColorPallete.backgroundSecondary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: const BoxConstraints(minWidth: 320, maxWidth: 500),
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Schedule Event',
                      style: TextStyle(
                        color: ColorPallete.textPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: ColorPallete.textSecondary),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Title Input
                TextFormField(
                  style: taskStyle,
                  controller: _titleController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                  decoration: _buildInputDecoration('Title (e.g. Daily Sync)'),
                ),
                const SizedBox(height: 12),

                // Description Input
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 3,
                  style: taskStyle,
                  decoration: _buildInputDecoration('Description (optional)'),
                ),
                const SizedBox(height: 16),

                // Date and Time info box
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: ColorPallete.backgroundPrimary.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: ColorPallete.textPrimary.withOpacity(0.08)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.access_time_filled, color: ColorPallete.error, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          DateFormat('MMMM d, yyyy  •  hh:mm a').format(_dueDate),
                          style: const TextStyle(color: ColorPallete.textPrimary, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Event Type and Priority Row
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Event Type', style: TextStyle(color: ColorPallete.textPrimary.withOpacity(0.60), fontSize: 12)),
                          const SizedBox(height: 6),
                          _buildDropdown(
                            value: _eventType,
                            items: ['Meeting', 'Notification', 'Appraisal', 'Task'],
                            onChanged: (val) {
                              setState(() {
                                _eventType = val;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Priority', style: TextStyle(color: ColorPallete.textPrimary.withOpacity(0.60), fontSize: 12)),
                          const SizedBox(height: 6),
                          _buildDropdown(
                            value: _priority,
                            items: ['Low', 'Medium', 'High'],
                            onChanged: (val) {
                              setState(() {
                                _priority = val;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Assignee & Personal checkbox Row
                if (widget.viewType == CalendarViewType.team) ...[
                  Text('Assign To', style: TextStyle(color: ColorPallete.textPrimary.withOpacity(0.60), fontSize: 12)),
                  const SizedBox(height: 6),
                  BlocBuilder<GetEmployeesBloc, GetEmployeesState>(
                    bloc: _getEmployeesBloc,
                    builder: (context, state) {
                      if (state is GetEmployeesLoading) {
                        return Container(
                          height: 45,
                          alignment: Alignment.center,
                          child: const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: ColorPallete.error),
                          ),
                        );
                      } else if (state is GetEmployeesSuccess) {
                        final employees = state.employees;
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: ColorPallete.backgroundPrimary,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: ColorPallete.textPrimary.withOpacity(0.08)),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<int>(
                              isExpanded: true,
                              dropdownColor: ColorPallete.backgroundSecondary,
                              value: _assignedToID,
                              style: const TextStyle(color: ColorPallete.textPrimary),
                              items: employees.map((e) {
                                return DropdownMenuItem<int>(
                                  value: e.id,
                                  child: Text('${e.firstName} ${e.lastName}'),
                                );
                              }).toList(),
                              onChanged: (val) {
                                setState(() {
                                  _assignedToID = val;
                                });
                              },
                            ),
                          ),
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                  const SizedBox(height: 12),
                ],

                // Action buttons
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancel', style: TextStyle(color: ColorPallete.textPrimary.withOpacity(0.60))),
                    ),
                    const SizedBox(width: 12),
                    BlocConsumer<CreateTaskBloc, CreateTaskState>(
                      bloc: _createTaskBloc,
                      listener: (context, state) {
                        if (state is CreateTaskSuccess) {
                          ElegantNotification.success(
                            description: const Text(
                              "Event scheduled successfully",
                              style: TextStyle(color: ColorPallete.backgroundPrimary),
                            ),
                            position: Alignment.bottomRight,
                            width: width * 0.45,
                          ).show(context);
                          widget.onSuccess();
                          Navigator.pop(context);
                        } else if (state is CreateTaskFailure) {
                          ElegantNotification.error(
                            description: Text(
                              state.error.message,
                              style: const TextStyle(color: ColorPallete.backgroundPrimary),
                            ),
                            position: Alignment.bottomRight,
                            width: width * 0.45,
                          ).show(context);
                        }
                      },
                      builder: (context, state) {
                        if (state is CreateTaskLoading) {
                          return const SizedBox(
                            width: 32,
                            height: 32,
                            child: CircularProgressIndicator(color: ColorPallete.error),
                          );
                        }
                        return CustomTextButton(
                          width: 130,
                          text: const Text('Save Event', style: TextStyle(color: ColorPallete.textPrimary, fontWeight: FontWeight.bold)),
                          onTap: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              final orgId = getIt<User>().organisation?.id ?? 0;
                              final userId = getIt<User>().user?.id ?? 0;

                              final params = CreateTaskParams(
                                token: widget.token,
                                task: TaskEntity(
                                  title: _titleController.text.trim(),
                                  description: _descriptionController.text.trim(),
                                  dueDate: _dueDate,
                                  assignedTo: _assignedToID ?? userId,
                                  assignedBy: userId,
                                  type: _eventType.toLowerCase(),
                                  priority: _priority,
                                  status: 'Pending',
                                  organisationId: orgId,
                                  isPersonal: _isPersonal,
                                ),
                              );
                              _createTaskBloc.add(CreateTask(params: params));
                            }
                          },
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: ColorPallete.backgroundPrimary,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: ColorPallete.textPrimary.withOpacity(0.08)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          dropdownColor: ColorPallete.backgroundSecondary,
          value: value,
          style: const TextStyle(color: ColorPallete.textPrimary),
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: (val) {
            if (val != null) onChanged(val);
          },
        ),
      ),
    );
  }
}
