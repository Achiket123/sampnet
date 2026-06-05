import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hackathon/features/projects/presentation/widgets/create_project_dialog.dart';

class EditProjectPage extends StatelessWidget {
  const EditProjectPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F11),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: const Center(
        child: CreateProjectDialog(),
      ),
    );
  }
}
