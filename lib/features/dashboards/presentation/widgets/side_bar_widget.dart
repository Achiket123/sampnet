import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hackathon/features/chats/presentation/pages/chat_page.dart';
import 'package:hackathon/features/dashboards/presentation/pages/dashboard.dart';
import 'package:hackathon/features/dashboards/presentation/widgets/custom_button.dart';
import 'package:hackathon/features/tasks/presentation/pages/task_page.dart';
import 'package:hackathon/features/team/presentation/pages/team_page.dart';
import 'package:hackathon/globals/constants/styles.dart';
import 'package:hackathon/widgets/list_of_side_bar.dart';

// ignore: must_be_immutable
class SideBarWidget extends StatefulWidget {
  final double sheight;
  final double swidth;
  int? selectedIndex;
  SideBarWidget({
    super.key,
    required this.sheight,
    required this.swidth,
    this.selectedIndex = 0,
  });

  @override
  State<SideBarWidget> createState() => _SideBarWidgetState();
}

class _SideBarWidgetState extends State<SideBarWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.swidth / 4,
      height: widget.sheight * 1.1,
      // margin: const EdgeInsets.only(right: 30),
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 35, 35, 35),
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(10), bottomRight: Radius.circular(10)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: [
          for (int i = 0; i < ListOfSideBar.sideBarItems.length; i++)
            DashBoardButton(
              isSelected: widget.selectedIndex == i,
              text: ListOfSideBar.sideBarItems[i],
              onTap: (index) {
                if (index == 0) {
                  context.go(Dashboard.routePath);
                } else if (index == 2) {
                  context.go(TaskPage.routePath);
                } else if (index == 1) {
                  context.go(ChatPage.routePath);
                } else if (index == 3) {
                  context.go(TeamPage.routePath);
                } else {
                  _changeIndex(index);
                }
              },
              index: i,
            ),
          const SizedBox(
            height: 40,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Divider(
              thickness: 2,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "About",
                style: textTheme.bodySmall,
              ),
              Text(
                "Docs",
                style: textTheme.bodySmall,
              ),
              Text(
                "Theme",
                style: textTheme.bodySmall,
              ),
            ],
          )
        ],
      ),
    );
  }

  _changeIndex(int index) {
    setState(() {
      widget.selectedIndex = index;
    });
  }
}
