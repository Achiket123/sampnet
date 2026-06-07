import 'package:flutter/material.dart';
import 'package:hackathon/globals/constants/color_pallete.dart';

class AttendanceStatusWidget extends StatelessWidget {
  const AttendanceStatusWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorPallete.backgroundSecondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Attendance",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: ColorPallete.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                "Not Checked In", // TODO: Get actual status
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: ColorPallete.error,
                    ),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Navigate to attendance page
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorPallete.redPrimary,
              foregroundColor: ColorPallete.textPrimary,
            ),
            child: const Text("Check In"),
          ),
        ],
      ),
    );
  }
}
