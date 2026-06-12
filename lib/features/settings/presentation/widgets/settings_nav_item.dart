import 'package:flutter/material.dart';
import 'package:hackathon/globals/constants/color_pallete.dart';
import 'package:hackathon/globals/constants/settings_permissions.dart';

class SettingsNavItem extends StatefulWidget {
  final IconData icon;
  final String title;
  final SettingsSection section;
  final bool isSelected;
  final VoidCallback onTap;

  const SettingsNavItem({
    super.key,
    required this.icon,
    required this.title,
    required this.section,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<SettingsNavItem> createState() => _SettingsNavItemState();
}

class _SettingsNavItemState extends State<SettingsNavItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final bool active = widget.isSelected;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: active
              ? ColorPallete.redSubtle
              : _isHovered
                  ? ColorPallete.backgroundTertiary
                  : ColorPallete.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: InkWell(
            onTap: widget.onTap,
            hoverColor: ColorPallete.transparent,
            splashColor: ColorPallete.redPrimary.withOpacity(0.1),
            highlightColor: ColorPallete.redPrimary.withOpacity(0.1),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Icon(
                    widget.icon,
                    size: 20,
                    color: active
                        ? ColorPallete.redPrimary
                        : _isHovered
                            ? ColorPallete.textPrimary
                            : ColorPallete.textSecondary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: active ? FontWeight.bold : FontWeight.w500,
                        color: active
                            ? ColorPallete.textPrimary
                            : _isHovered
                                ? ColorPallete.textPrimary
                                : ColorPallete.textSecondary,
                      ),
                    ),
                  ),
                  if (active)
                    Container(
                      width: 4,
                      height: 16,
                      decoration: BoxDecoration(
                        color: ColorPallete.redPrimary,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
