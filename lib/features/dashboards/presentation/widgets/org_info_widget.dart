import 'package:flutter/material.dart';
import 'package:hackathon/globals/constants/color_pallete.dart';

class OrgInfoWidget extends StatelessWidget {
  const OrgInfoWidget({super.key});

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
            "Organization Overview",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: ColorPallete.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _OrgStat(label: "Employees", value: "42"),
              const SizedBox(width: 24),
              _OrgStat(label: "Active Projects", value: "8"),
            ],
          ),
        ],
      ),
    );
  }
}

class _OrgStat extends StatelessWidget {
  final String label;
  final String value;

  const _OrgStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: ColorPallete.textPrimary,
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: ColorPallete.textPrimary.withOpacity(0.6),
              ),
        ),
      ],
    );
  }
}
