import 'package:flutter/material.dart';
import 'package:hackathon/globals/constants/color_pallete.dart';

class UpcomingDeadlinesWidget extends StatelessWidget {
  const UpcomingDeadlinesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorPallete.backgroundSecondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Upcoming Deadlines",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: ColorPallete.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 2,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              return Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: ColorPallete.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: ColorPallete.error.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        "Project Proposal Submission",
                        style: const TextStyle(color: ColorPallete.textPrimary, fontSize: 13),
                      ),
                    ),
                    Text(
                      "In 2 days",
                      style: const TextStyle(color: ColorPallete.error, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
