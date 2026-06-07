import 'package:flutter/material.dart';
import 'package:hackathon/dependency_injection.g.dart';
import 'package:hackathon/globals/constants/color_pallete.dart';
import 'package:hackathon/globals/constants/user.dart';

class GreetingWidget extends StatelessWidget {
  const GreetingWidget({super.key});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    final user = getIt<User>().user;
    final organisation = getIt<User>().organisation;
    final greetingPrefix = _getGreeting();
    final firstName = user?.firstName ?? 'User';

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
            "$greetingPrefix, $firstName!",
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: ColorPallete.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            "Here's what's happening today.",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: ColorPallete.textPrimary.withOpacity(0.7),
                ),
          ),
          if (organisation != null) ...[
            const SizedBox(height: 4),
            Text(
              organisation.companyName,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: ColorPallete.textPrimary.withOpacity(0.5),
                  ),
            ),
          ],
        ],
      ),
    );
  }
}
