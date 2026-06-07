import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hackathon/features/chats/presentation/blocs/chat_bloc/chat_bloc_bloc.dart';
import 'package:hackathon/globals/constants/color_pallete.dart';
import 'package:intl/intl.dart';

class RecentChatsWidget extends StatelessWidget {
  const RecentChatsWidget({super.key});

  String _formatRelativeTime(DateTime? dateTime) {
    if (dateTime == null) return "";
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays >= 1) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours >= 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes >= 1) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorPallete.backgroundSecondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Recent Chats",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: ColorPallete.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              TextButton(
                onPressed: () => context.push('/chats'),
                child: const Text("View all", style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          BlocBuilder<ChatBlocBloc, ChatBlocState>(
            builder: (context, state) {
              if (state is ChatLoadingState) {
                return Column(
                  children: List.generate(3, (index) => _ShimmerChatTile()),
                );
              }

              if (state is ChatBlocError) {
                return Center(
                  child: TextButton(
                    onPressed: () => context.read<ChatBlocBloc>().add(GetChatsEvent()),
                    child: const Text("Retry loading chats"),
                  ),
                );
              }

              if (state is ChatBlocLoaded) {
                final chats = state.chats.take(5).toList();
                if (chats.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Center(child: Text("No chats yet", style: TextStyle(color: ColorPallete.textSecondary))),
                  );
                }

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: chats.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 4),
                  itemBuilder: (context, index) {
                    final chat = chats[index];
                    final chatName = chat.isGroup 
                        ? (chat.name ?? "Group Chat") 
                        : (chat.participants.isNotEmpty 
                            ? "${chat.participants.first.firstName ?? ''} ${chat.participants.first.lastName ?? ''}".trim()
                            : "Unknown User");
                    return ListTile(
                      onTap: () => context.push('/chats'),
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        backgroundColor: ColorPallete.redPrimary.withOpacity(0.2),
                        child: Text(
                          chatName.isNotEmpty ? chatName[0].toUpperCase() : "?",
                          style: const TextStyle(color: ColorPallete.textPrimary, fontSize: 14),
                        ),
                      ),
                      title: Text(
                        chatName,
                        style: const TextStyle(color: ColorPallete.textPrimary, fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      subtitle: Text(
                        chat.lastMessage ?? "No messages yet",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: ColorPallete.textPrimary.withOpacity(0.6), fontSize: 12),
                      ),
                      trailing: Text(
                        _formatRelativeTime(chat.lastMessageAt),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: ColorPallete.textPrimary.withOpacity(0.4),
                              fontSize: 10,
                            ),
                      ),
                    );
                  },
                );
              }

              return const SizedBox();
            },
          ),
        ],
      ),
    );
  }
}

class _ShimmerChatTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          CircleAvatar(radius: 20, backgroundColor: ColorPallete.textPrimary.withOpacity(0.05)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(width: 100, height: 10, decoration: BoxDecoration(color: ColorPallete.textPrimary.withOpacity(0.05), borderRadius: BorderRadius.circular(5))),
                const SizedBox(height: 6),
                Container(width: 150, height: 8, decoration: BoxDecoration(color: ColorPallete.textPrimary.withOpacity(0.05), borderRadius: BorderRadius.circular(4))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
