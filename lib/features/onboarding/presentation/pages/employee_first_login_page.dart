import 'package:flutter/material.dart';

class EmployeeFirstLoginPage extends StatelessWidget {
  const EmployeeFirstLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('First Login')),
      body: const Center(child: Text('Employee First Login Page')),
    );
  }
}
