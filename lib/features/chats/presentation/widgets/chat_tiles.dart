import 'package:flutter/material.dart';
import 'package:hackathon/features/chats/domain/entities/chat_entity.dart';
import 'package:hackathon/globals/constants/assets.dart';
import 'package:hackathon/globals/constants/color_pallete.dart';
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
        .copyWith(color: ColorPallete.blackPrimary, fontSize: swidth * 0.01);
    return Badge(
      backgroundColor: Colors.red,
      smallSize: 10,
      child: Container(
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: ColorPallete.offWhite2,
            borderRadius: BorderRadius.circular(5)),
        child: ListTile(
          leading: const CircleAvatar(
            backgroundImage: AssetImage(ImageAssets.chat),
          ),
          mouseCursor: SystemMouseCursors.click,
          title: Text(
            "${chatEntity.firstName} ${chatEntity.lastName}",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textStyle,
          ),
          trailing: Text(
            chatEntity.lastMessageTimestamp!=null?
            Intl()
                .date(DateFormat.HOUR24_MINUTE)
                .format(chatEntity.lastMessageTimestamp!):'',
            style: textStyle.copyWith(fontSize: 10),
          ),
        ),
      ),
    );
  }
}
