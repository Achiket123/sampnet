import 'package:flutter/material.dart';
import 'package:hackathon/globals/constants/color_pallete.dart';

class MyTasksSummaryWidget extends StatelessWidget {
  const MyTasksSummaryWidget({super.key});

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "My Tasks",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: ColorPallete.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                "View All",
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.blueAccent,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _TaskStat(label: "To Do", count: "5", color: Colors.grey),
              _TaskStat(label: "In Progress", count: "3", color: Colors.blue),
              _TaskStat(label: "Done", count: "12", color: Colors.green),
            ],
          ),
        ],
      ),
    );
  }
}

class _TaskStat extends StatelessWidget {
  final String label;
  final String count;
  final Color color;

  const _TaskStat({
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          count,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: ColorPallete.white.withOpacity(0.7),
              ),
        ),
      ],
    );
  }
}
