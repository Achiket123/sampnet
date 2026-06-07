import 'package:flutter/material.dart';
import 'package:hackathon/globals/constants/color_pallete.dart';

class ProjectStatusBadge extends StatelessWidget {
  final String text;
  final bool isPriority;

  const ProjectStatusBadge({
    super.key,
    required this.text,
    this.isPriority = false,
  });

  @override
  Widget build(BuildContext context) {
    final cleanText = text.trim().toLowerCase();
    
    Color textColor;
    Color bgColor;
    
    if (isPriority) {
      switch (cleanText) {
        case 'low':
          textColor = const Color(0xFF4ADE80); // Tailwind green-400
          bgColor = const Color(0xFF14532D);   // Tailwind green-950
          break;
        case 'medium':
          textColor = const Color(0xFFFACC15); // Yellow-400
          bgColor = const Color(0xFF713F12);   // Yellow-950
          break;
        case 'high':
          textColor = const Color(0xFFFB923C); // Orange-400
          bgColor = const Color(0xFF7C2D12);   // Orange-950
          break;
        case 'critical':
          textColor = const Color(0xFFF87171); // Red-400
          bgColor = const Color(0xFF7F1D1D);   // Red-950
          break;
        default:
          textColor = ColorPallete.textSecondary;
          bgColor = const Color(0xFF1E293B);   // Slate-800
      }
    } else {
      switch (cleanText) {
        case 'planning':
          textColor = const Color(0xFF60A5FA); // Blue-400
          bgColor = const Color(0xFF1E3A8A);   // Blue-950
          break;
        case 'active':
          textColor = const Color(0xFF2DD4BF); // Teal-400
          bgColor = const Color(0xFF115E59);   // Teal-950
          break;
        case 'on_hold':
        case 'on hold':
        case 'paused':
          textColor = const Color(0xFFF59E0B); // Amber-500
          bgColor = const Color(0xFF78350F);   // Amber-950
          break;
        case 'completed':
          textColor = const Color(0xFF34D399); // Emerald-400
          bgColor = const Color(0xFF064E3B);   // Emerald-950
          break;
        case 'cancelled':
          textColor = const Color(0xFFF87171); // Red-400
          bgColor = const Color(0xFF7F1D1D);   // Red-950
          break;
        default:
          textColor = ColorPallete.textSecondary;
          bgColor = const Color(0xFF1E293B);
      }
    }

    final displayText = text.replaceAll('_', ' ').split(' ').map((word) {
      if (word.isEmpty) return '';
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: textColor.withAlpha(50),
          width: 1,
        ),
      ),
      child: Text(
        displayText,
        style: TextStyle(
          color: textColor,
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}
