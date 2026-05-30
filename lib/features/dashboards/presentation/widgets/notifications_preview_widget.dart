import 'package:flutter/material.dart';
import 'package:hackathon/globals/constants/color_pallete.dart';

class NotificationsPreviewWidget extends StatelessWidget {
  const NotificationsPreviewWidget({super.key});

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
                "Notifications",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: ColorPallete.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const Icon(Icons.notifications_none, color: ColorPallete.white, size: 20),
            ],
          ),
          const SizedBox(height: 12),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 2,
            separatorBuilder: (context, index) => const Divider(color: Colors.white10),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(
                  "You were assigned a new task: 'Design UI for Dashboard'",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: ColorPallete.white.withOpacity(0.8),
                      ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
