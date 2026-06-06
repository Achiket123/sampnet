
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/people_entities.dart';
import '../blocs/people_list_bloc/people_list_bloc.dart';
import '../blocs/people_list_bloc/people_list_event.dart';

class AddContactDialog extends StatefulWidget {
  const AddContactDialog({super.key});

  @override
  State<AddContactDialog> createState() => _AddContactDialogState();
}

class _AddContactDialogState extends State<AddContactDialog> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Contact'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(controller: _firstNameController, decoration: const InputDecoration(labelText: 'First Name')),
            TextFormField(controller: _lastNameController, decoration: const InputDecoration(labelText: 'Last Name')),
            TextFormField(controller: _emailController, decoration: const InputDecoration(labelText: 'Email')),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
            final newContact = PeopleContactEntity(
      id: 0, // Assigned by server
      organisationId: 1, // Should be managed by your Auth/User service
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      email: _emailController.text,
      phone: '', 
      tags: [],
      customFields: {},
      status: 'active',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

            // Dispatch the event
            context.read<PeopleListBloc>().add(PeopleListContactCreated(newContact));
            
            Navigator.pop(context); 
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}