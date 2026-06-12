import 'package:flutter/material.dart';
import 'package:hackathon/dependency_injection.g.dart';
import 'package:hackathon/globals/constants/settings_permissions.dart';
import 'package:hackathon/globals/constants/user.dart';

class RoleGuardWidget extends StatelessWidget {
  final SettingsSection section;
  final Widget child;
  final Widget? readOnlyChild;

  const RoleGuardWidget({
    super.key,
    required this.section,
    required this.child,
    this.readOnlyChild,
  });

  @override
  Widget build(BuildContext context) {
    final role = getIt<User>().role;
    
    if (!canView(section, role)) {
      return const SizedBox.shrink();
    }
    
    if (!canEdit(section, role)) {
      if (readOnlyChild != null) {
        return readOnlyChild!;
      }
      return IgnorePointer(
        ignoring: true,
        child: Opacity(
          opacity: 0.6,
          child: child,
        ),
      );
    }
    
    return child;
  }
}

