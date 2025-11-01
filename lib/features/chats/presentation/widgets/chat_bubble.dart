import 'package:flutter/material.dart';
import 'package:hackathon/features/chats/domain/entities/message_entity.dart';
import 'package:hackathon/globals/constants/color_pallete.dart';
import 'package:hackathon/globals/constants/user.dart';

class ChatBubble extends StatelessWidget {
  final MessageEntity chatMessageEntity;

  const ChatBubble({super.key, required this.chatMessageEntity});

  @override
  Widget build(BuildContext context) {
    final isSender = chatMessageEntity.senderId == User.user.id.toString();
    final testStyle = Theme.of(context)
        .textTheme
        .bodySmall!
        .copyWith(color: ColorPallete.blackPrimary, fontSize: 16);
    return ListTile(
      title: Align(
        alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
        child: Text(isSender ? "You" : chatMessageEntity.senderName),
      ),
      subtitle: Align(
        alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          constraints: BoxConstraints(
            maxWidth:
                MediaQuery.of(context).size.width * 0.5, // 70% of screen width
          ),
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.symmetric(vertical: 2.5),
          decoration: BoxDecoration(
            color: ColorPallete.offWhite2,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            chatMessageEntity.message,
            style: testStyle,
          ),
        ),
      ),
    );
  }
}
