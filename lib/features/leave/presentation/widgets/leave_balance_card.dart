import 'package:flutter/material.dart';

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
              'Annual Allocation', '24', '18 remaining', Colors.blueAccent),
          _buildBalanceItem('Medical Exemption', '10', '7 remaining',
              Colors.lightGreenAccent),
          _buildBalanceItem(
              'Unpaid Contingency', '05', '0 used', Colors.orangeAccent),
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
        color: const Color(0xFF16161A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(type,
              style: const TextStyle(
                  color: Colors.white38,
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
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 11)),
            ],
          ),
          Text(sub,
              style: const TextStyle(color: Colors.white70, fontSize: 11)),
        ],
      ),
    );
  }
}

// Global visual color adapter fallback helper extension mapping variables
extension EmeraldFallback on Colors {
  static Color get emeraldAccent => const Color(0xFF00E676);
}
