import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hackathon/features/employees/domain/entities/employee_entity.dart';
import 'package:hackathon/features/employees/presentation/blocs/employees_list_bloc/employees_list_bloc.dart';
import 'package:hackathon/features/employees/presentation/blocs/employees_list_bloc/employees_list_event.dart';

class EditEmployeeModal extends StatefulWidget {
  final EmployeeEntity employee;
  final bool isOwnProfile;
  const EditEmployeeModal({super.key, required this.employee, this.isOwnProfile = false});

  @override
  State<EditEmployeeModal> createState() => _EditEmployeeModalState();
}

class _EditEmployeeModalState extends State<EditEmployeeModal> {
  late TextEditingController _typeController;
  late TextEditingController _salaryController;
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _typeController = TextEditingController(text: widget.employee.type);
    _salaryController = TextEditingController(text: widget.employee.salary);
    _firstNameController = TextEditingController(text: widget.employee.user.firstName);
    _lastNameController = TextEditingController(text: widget.employee.user.lastName);
    _phoneController = TextEditingController(text: widget.employee.user.phoneNumber);
  }

  @override
  void dispose() {
    _typeController.dispose();
    _salaryController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20),
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 30, 30, 30),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.isOwnProfile ? 'Edit Profile' : 'Edit ${widget.employee.user.firstName}',
                style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white70),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (widget.isOwnProfile) ...[
            TextField(
              controller: _firstNameController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'First Name',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white10)),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _lastNameController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Last Name',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white10)),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _phoneController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white10)),
              ),
            ),
          ] else ...[
            TextField(
              controller: _typeController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Designation / Type',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white10)),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _salaryController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Salary',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white10)),
              ),
            ),
          ],
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                context.read<EmployeesListBloc>().add(EmployeeUpdateRequested(
                  employeeId: widget.employee.userId,
                  type: widget.isOwnProfile ? widget.employee.type : _typeController.text,
                  salary: widget.isOwnProfile ? widget.employee.salary : _salaryController.text,
                  firstName: widget.isOwnProfile ? _firstNameController.text : null,
                  lastName: widget.isOwnProfile ? _lastNameController.text : null,
                  phoneNumber: widget.isOwnProfile ? _phoneController.text : null,
                ));
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Save Changes', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}
