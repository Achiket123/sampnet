import 'package:flutter/material.dart';

class ColorPallete {
  // Backgrounds
  static const backgroundPrimary = Color(0xFF0A0A0A);
  static const backgroundSecondary = Color(0xFF141414);
  static const backgroundTertiary = Color(0xFF1E1E1E);

  // Reds
  static const redPrimary = Color(0xFFE13226);
  static const redDark = Color(0xFFAA2016);
  static const redSubtle = Color(0x1AE13226); // 10% opacity red

  // Texts
  static const textPrimary = Color(0xFFFFFFFF);
  static const textSecondary = Color(0xFFB0B0B0);
  static const textMuted = Color(0x80B0B0B0); // 50% opacity textSecondary
  static const textDisabled = Color(0xFF555555);

  // Miscellaneous
  static const divider = Color(0xFF2A2A2A);
  static const transparent = Colors.transparent;

  // Semantic Status Colors
  static const success = Color(0xFF2ECC71);
  static const warning = Color(0xFFF39C12);
  static const error = Color(0xFFE13226); // Same as redPrimary

  /// Standardized status color mapping
  static Color statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
      case 'completed':
      case 'present':
        return success;
      case 'pending':
      case 'in-progress':
        return warning;
      case 'rejected':
      case 'overdue':
      case 'absent':
        return error;
      case 'cancelled':
      case 'inactive':
        return textDisabled;
      default:
        debugPrint('Warning: Unmapped status string "$status" used in ColorPallete.statusColor()');
        return textSecondary;
    }
  }
}
