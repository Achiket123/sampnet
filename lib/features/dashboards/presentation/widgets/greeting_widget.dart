import 'package:flutter/material.dart';
import 'package:hackathon/globals/constants/color_pallete.dart';

class GreetingWidget extends StatelessWidget {
  const GreetingWidget({super.key});

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
            "Good Morning, User!", // TODO: Get actual user name
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: ColorPallete.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            "Here's what's happening today.",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: ColorPallete.white.withOpacity(0.7),
                ),
          ),
        ],
      ),
    );
  }
}
