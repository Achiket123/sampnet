import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hackathon/features/projects/presentation/widgets/create_project_dialog.dart';
import 'package:hackathon/globals/constants/color_pallete.dart';

class EditProjectPage extends StatelessWidget {
  const EditProjectPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPallete.backgroundPrimary,
      appBar: AppBar(
        backgroundColor: ColorPallete.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: ColorPallete.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: const Center(
        child: CreateProjectDialog(),
      ),
    );
  }
}
