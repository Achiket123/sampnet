import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hackathon/dependency_injection.g.dart';
import 'package:hackathon/globals/constants/color_pallete.dart';
import 'package:hackathon/features/settings/domain/entities/task_type_entity.dart';
import 'package:hackathon/features/settings/presentation/blocs/settings_bloc/settings_bloc.dart';
import 'package:hackathon/features/settings/presentation/blocs/settings_bloc/settings_event.dart';
import 'package:hackathon/features/settings/presentation/blocs/settings_bloc/settings_state.dart';

class TaskTypeConfigPage extends StatefulWidget {
  const TaskTypeConfigPage({super.key});

  @override
  State<TaskTypeConfigPage> createState() => _TaskTypeConfigPageState();
}

class _TaskTypeConfigPageState extends State<TaskTypeConfigPage> {
  final List<TaskTypeConfig> _taskTypes = [];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SettingsBloc>()..add(LoadTaskTypesEvent()),
      child: BlocConsumer<SettingsBloc, SettingsState>(
        listener: (context, state) {
          if (state is TaskTypesLoaded) {
            setState(() {
              _taskTypes.clear();
              _taskTypes.addAll(state.taskTypes);
            });
          } else if (state is SettingsActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: ColorPallete.success,
              ),
            );
            context.read<SettingsBloc>().add(LoadTaskTypesEvent());
          } else if (state is SettingsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: ColorPallete.error,
              ),
            );
          }
        },
        builder: (context, state) {
          final bool isLoading = state is SettingsLoading;

          return Scaffold(
            backgroundColor: ColorPallete.backgroundPrimary,
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Task Types Configuration',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: ColorPallete.textPrimary,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Manage default workflow categories and task type classifications.',
                            style: TextStyle(
                              fontSize: 14,
                              color: ColorPallete.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorPallete.redPrimary,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () => _showAddEditDialog(context),
                        icon: const Icon(Icons.add, color: ColorPallete.textPrimary, size: 18),
                        label: const Text(
                          'Create Type',
                          style: TextStyle(color: ColorPallete.textPrimary, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  if (isLoading && _taskTypes.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(48.0),
                        child: CircularProgressIndicator(color: ColorPallete.redPrimary),
                      ),
                    )
                  else if (_taskTypes.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(40),
                      decoration: BoxDecoration(
                        color: ColorPallete.backgroundSecondary,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: ColorPallete.divider),
                      ),
                      child: const Center(
                        child: Text(
                          'No task types defined yet. Click "Create Type" to add one.',
                          style: TextStyle(color: ColorPallete.textSecondary),
                        ),
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _taskTypes.length,
                      itemBuilder: (context, index) {
                        final type = _taskTypes[index];
                        return _buildTaskTypeCard(context, type);
                      },
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTaskTypeCard(BuildContext context, TaskTypeConfig type) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ColorPallete.backgroundSecondary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorPallete.divider),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  type.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: ColorPallete.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  type.description.isNotEmpty ? type.description : 'No description provided.',
                  style: const TextStyle(
                    fontSize: 13,
                    color: ColorPallete.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.edit_outlined, color: ColorPallete.textSecondary),
                onPressed: () => _showAddEditDialog(context, type: type),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: ColorPallete.error),
                onPressed: () {
                  if (type.id != null) {
                    context.read<SettingsBloc>().add(DeleteTaskTypeEvent(type.id!));
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAddEditDialog(BuildContext context, {TaskTypeConfig? type}) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: type?.name ?? '');
    final descController = TextEditingController(text: type?.description ?? '');
    final isEdit = type != null;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: ColorPallete.backgroundPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: ColorPallete.divider),
        ),
        title: Text(
          isEdit ? 'Edit Task Type' : 'Create Task Type',
          style: const TextStyle(color: ColorPallete.textPrimary, fontWeight: FontWeight.bold),
        ),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Task Type Name',
                style: TextStyle(color: ColorPallete.textSecondary, fontSize: 13),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: nameController,
                style: const TextStyle(color: ColorPallete.textPrimary),
                decoration: InputDecoration(
                  fillColor: ColorPallete.backgroundSecondary,
                  filled: true,
                  hintText: 'e.g. Bug, Feature, Support',
                  hintStyle: const TextStyle(color: ColorPallete.textDisabled),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: ColorPallete.divider),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: ColorPallete.redPrimary),
                  ),
                ),
                validator: (v) => v!.isEmpty ? 'Name is required' : null,
              ),
              const SizedBox(height: 16),
              const Text(
                'Description',
                style: TextStyle(color: ColorPallete.textSecondary, fontSize: 13),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: descController,
                maxLines: 3,
                style: const TextStyle(color: ColorPallete.textPrimary),
                decoration: InputDecoration(
                  fillColor: ColorPallete.backgroundSecondary,
                  filled: true,
                  hintText: 'Describe what this task type signifies...',
                  hintStyle: const TextStyle(color: ColorPallete.textDisabled),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: ColorPallete.divider),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: ColorPallete.redPrimary),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel', style: TextStyle(color: ColorPallete.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorPallete.redPrimary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              if (formKey.currentState!.validate()) {
                final config = TaskTypeConfig(
                  id: type?.id,
                  name: nameController.text.trim(),
                  description: descController.text.trim(),
                );
                if (isEdit) {
                  context.read<SettingsBloc>().add(UpdateTaskTypeEvent(config));
                } else {
                  context.read<SettingsBloc>().add(CreateTaskTypeEvent(config));
                }
                Navigator.pop(dialogContext);
              }
            },
            child: Text(
              isEdit ? 'Save' : 'Create',
              style: const TextStyle(color: ColorPallete.textPrimary, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
