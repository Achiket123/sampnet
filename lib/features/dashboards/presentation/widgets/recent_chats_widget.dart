import 'package:flutter/material.dart';
import 'package:hackathon/globals/constants/color_pallete.dart';

class RecentChatsWidget extends StatelessWidget {
  const RecentChatsWidget({super.key});

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
            "Recent Chats",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: ColorPallete.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 3,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const CircleAvatar(
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                title: Text(
                  "User ${index + 1}",
                  style: const TextStyle(color: ColorPallete.white),
                ),
                subtitle: Text(
                  "Last message snippet...",
                  style: TextStyle(color: ColorPallete.white.withOpacity(0.6)),
                ),
                trailing: Text(
                  "12:34 PM",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: ColorPallete.white.withOpacity(0.4),
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
