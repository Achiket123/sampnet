import 'package:flutter/material.dart';
import 'package:hackathon/features/auth/domain/entity/user_entity.dart';
import 'package:hackathon/features/team/data/models/team_member.dart';
import 'package:hackathon/globals/constants/assets.dart';
import 'package:hackathon/globals/constants/color_pallete.dart';
import 'package:hackathon/globals/models/employee_model.dart';
import 'package:hackathon/globals/models/team_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class UserTeamWidget extends StatelessWidget {
  final TeamMember userEntity;
  const UserTeamWidget({super.key, required this.userEntity});
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      margin: const EdgeInsets.all(10),
      constraints: BoxConstraints(minHeight: screenHeight * 0.2),
      decoration: BoxDecoration(
        color: ColorPallete.blackSecondary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text("${userEntity.user?.firstName} ${userEntity.user?.lastName}"),
            subtitle: Text(userEntity.user?.email ?? ""),
            trailing: const CircleAvatar(
              backgroundImage: AssetImage(ImageAssets.chatProfile),
            ),
          ),
          const Padding(padding: EdgeInsets.all(10), child: Text("I am the One")),
        ],
      ),
    );
  }
}
