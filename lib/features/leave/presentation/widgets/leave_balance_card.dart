import 'package:flutter/material.dart';
import 'package:hackathon/globals/constants/color_pallete.dart';

class LeaveBalanceCard extends StatelessWidget {
  const LeaveBalanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        physics: const BouncingScrollPhysics(),
        children: [
          _buildBalanceItem(
              'Annual Allocation', '24', '18 remaining', ColorPallete.redPrimary),
          _buildBalanceItem('Medical Exemption', '10', '7 remaining',
              ColorPallete.statusColor('approved')),
          _buildBalanceItem(
              'Unpaid Contingency', '05', '0 used', ColorPallete.statusColor('pending')),
        ],
      ),
    );
  }

  Widget _buildBalanceItem(String type, String count, String sub, Color color) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ColorPallete.backgroundPrimary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ColorPallete.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(type,
              style: const TextStyle(
                  color: ColorPallete.textDisabled,
                  fontSize: 11,
                  fontWeight: FontWeight.w600),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(count,
                  style: TextStyle(
                      color: color, fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(width: 4),
              Text('days',
                  style: TextStyle(color: ColorPallete.textSecondary, fontSize: 11)),
            ],
          ),
          Text(sub,
              style: const TextStyle(color: ColorPallete.textSecondary, fontSize: 11)),
        ],
      ),
    );
  }
}

// Global visual color adapter fallback helper extension mapping variables
extension EmeraldFallback on Colors {
  static Color get emeraldAccent => const Color(0xFF00E676);
}
