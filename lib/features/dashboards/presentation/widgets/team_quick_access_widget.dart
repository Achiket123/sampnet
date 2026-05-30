import 'package:flutter/material.dart';
import 'package:hackathon/globals/constants/color_pallete.dart';

class TeamQuickAccessWidget extends StatelessWidget {
  const TeamQuickAccessWidget({super.key});

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
            "Quick Access - Teams",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: ColorPallete.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 80,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              separatorBuilder: (context, index) => const SizedBox(width: 16),
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.blueAccent.withOpacity(0.3),
                      child: Text(
                        "T${index + 1}",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Team ${index + 1}",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: ColorPallete.white,
                          ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
