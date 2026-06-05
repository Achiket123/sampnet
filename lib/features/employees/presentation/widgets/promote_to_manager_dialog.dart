import 'package:flutter/material.dart';
import 'package:hackathon/features/employees/domain/entities/employee_entity.dart';

class PromoteToManagerDialog extends StatefulWidget {
  final EmployeeEntity employee;
  const PromoteToManagerDialog({super.key, required this.employee});

  @override
  State<PromoteToManagerDialog> createState() => _PromoteToManagerDialogState();
}

class _PromoteToManagerDialogState extends State<PromoteToManagerDialog> {
  late TextEditingController _typeController;
  late TextEditingController _salaryController;

  @override
  void initState() {
    super.initState();
    _typeController = TextEditingController(text: 'Engineering Manager');
    _salaryController = TextEditingController();
  }

  @override
  void dispose() {
    _typeController.dispose();
    _salaryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color.fromARGB(255, 30, 30, 30),
      title: Text('Promote ${widget.employee.user.firstName}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _typeController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: 'Role/Title',
              labelStyle: TextStyle(color: Colors.white70),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _salaryController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: 'Salary (Optional)',
              labelStyle: TextStyle(color: Colors.white70),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context, {
              'type': _typeController.text,
              'salary': _salaryController.text,
            });
          },
          child: const Text('Promote'),
        ),
      ],
    );
  }
}
