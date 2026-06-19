import 'package:flutter/material.dart';
import 'package:hackathon/dependency_injection.g.dart';
import 'package:hackathon/features/chats/domain/entities/chat_entity.dart';
import 'package:hackathon/globals/constants/color_pallete.dart';
import 'package:hackathon/globals/constants/user.dart';
import 'package:intl/intl.dart';

class ChatTiles extends StatelessWidget {
  const ChatTiles({
    super.key,
    required this.chatEntity,
  });
  final ChatEntity chatEntity;
  @override
  Widget build(BuildContext context) {
    final sheight = MediaQuery.sizeOf(context).height;
    final swidth = MediaQuery.sizeOf(context).width;
    final textStyle = Theme.of(context)
        .textTheme
        .bodyMedium!
        .copyWith(color: ColorPallete.backgroundPrimary, fontSize: swidth * 0.01);
    return Badge(
      backgroundColor: ColorPallete.error,
      smallSize: 10,
      child: Container(
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: ColorPallete.textPrimary.withOpacity(0.02),
            borderRadius: BorderRadius.circular(5)),
        child: ListTile(
          leading: (() {
            final currentUserId = getIt<User>().user?.id;
            final otherParticipants = chatEntity.participants.where((p) => p.userId != currentUserId);
            final otherParticipant = otherParticipants.isNotEmpty
                ? otherParticipants.first
                : (chatEntity.participants.isNotEmpty ? chatEntity.participants.first : null);
            final avatar = otherParticipant?.avatarUrl;
            if (avatar != null && avatar.isNotEmpty) {
              return CircleAvatar(
                backgroundImage: NetworkImage(avatar),
              );
            }
            
            String initials = "";
            if (chatEntity.isGroup) {
              final groupName = chatEntity.name ?? '';
              if (groupName.isNotEmpty) {
                final parts = groupName.trim().split(RegExp(r'\s+'));
                initials = parts.map((p) => p.isNotEmpty ? p[0].toUpperCase() : '').take(2).join();
              }
              if (initials.isEmpty) initials = "G";
            } else {
              final firstName = otherParticipant?.firstName ?? '';
              final lastName = otherParticipant?.lastName ?? '';
              initials = "${firstName.isNotEmpty ? firstName[0] : ''}${lastName.isNotEmpty ? lastName[0] : ''}".toUpperCase();
              if (initials.isEmpty) {
                initials = "U";
              }
            }
            
            return CircleAvatar(
              backgroundColor: ColorPallete.redPrimary,
              child: Text(
                initials,
                style: const TextStyle(
                  color: ColorPallete.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          })(),
          mouseCursor: SystemMouseCursors.click,
          title: Text(
            chatEntity.isGroup 
                ? chatEntity.name ?? "Group Chat" 
                : (chatEntity.participants.isNotEmpty 
                    ? (() {
                        final currentUserId = getIt<User>().user?.id;
                        final otherParticipants = chatEntity.participants.where((p) => p.userId != currentUserId);
                        final otherParticipant = otherParticipants.isNotEmpty
                            ? otherParticipants.first
                            : chatEntity.participants.first;
                        final name = "${otherParticipant.firstName ?? ''} ${otherParticipant.lastName ?? ''}".trim();
                        return name.isNotEmpty ? name : "Unknown User";
                      })()
                    : "Unknown User"),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textStyle,
          ),
          trailing: Text(
            chatEntity.lastMessageAt != null ?
            Intl()
                .date(DateFormat.HOUR24_MINUTE)
                .format(chatEntity.lastMessageAt!) : '',
            style: textStyle.copyWith(fontSize: 10),
          ),
        ),
      ),
    );
  }
}
