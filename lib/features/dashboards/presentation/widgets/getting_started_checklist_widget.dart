import 'package:flutter/material.dart';
import 'package:hackathon/globals/constants/color_pallete.dart';

class GettingStartedChecklistWidget extends StatelessWidget {
  const GettingStartedChecklistWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorPallete.background2[0].withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Getting Started",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: ColorPallete.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          _ChecklistItem(text: "Complete your profile", isDone: true),
          _ChecklistItem(text: "Join your first team", isDone: false),
          _ChecklistItem(text: "Create your first task", isDone: false),
        ],
      ),
    );
  }
}

class _ChecklistItem extends StatelessWidget {
  final String text;
  final bool isDone;

  const _ChecklistItem({required this.text, required this.isDone});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(
            isDone ? Icons.check_circle : Icons.radio_button_unchecked,
            color: isDone ? Colors.greenAccent : Colors.white24,
            size: 18,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: isDone ? ColorPallete.white.withOpacity(0.5) : ColorPallete.white,
              decoration: isDone ? TextDecoration.lineThrough : null,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
