import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hackathon/features/chats/presentation/pages/chat_page.dart';
import 'package:hackathon/features/dashboards/presentation/pages/dashboard.dart';
import 'package:hackathon/features/dashboards/presentation/widgets/custom_button.dart';
import 'package:hackathon/features/employees/presentation/pages/employees_list_page.dart';
import 'package:hackathon/features/leave/presentation/pages/leave_management_page.dart';
import 'package:hackathon/features/tasks/presentation/pages/task_page.dart';
import 'package:hackathon/features/team/presentation/pages/team_page.dart';
import 'package:hackathon/features/projects/presentation/pages/projects_list_page.dart';
import 'package:hackathon/features/research/presentation/pages/research_list_page.dart';
import 'package:hackathon/features/people/presentation/pages/people_list_page.dart';
import 'package:hackathon/globals/constants/styles.dart';
import 'package:hackathon/widgets/list_of_side_bar.dart';
import 'package:hackathon/dependency_injection.g.dart';
import 'package:hackathon/globals/constants/user.dart';
import 'package:hackathon/features/employees/presentation/pages/employee_profile_page.dart';
import 'package:hackathon/features/resources/presentation/pages/resources_page.dart';
import 'package:hackathon/features/calendar/presentation/pages/personal_calendar_page.dart';

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
                } else if (index == 4) {
                  context.go(LeaveManagementPage.routePath);
                } else if (index == 5) {
                  context.go(ResourcesPage.routePath);
                } else if (index == 6) {
                  final userRole = getIt<User>().role;
                  if (userRole == 'employee') {
                    final userId = getIt<User>().user?.id ?? 0;
                    context.go('${EmployeeProfilePage.routePath}/$userId');
                  } else {
                    context.go(EmployeesListPage.routePath);
                  }
                } else if (index == 7) {
                  context.go(ResearchListPage.routePath);
                } else if (index == 8) {
                  context.go(ProjectsListPage.routePath);
                } else if (index == 9) {
                  context.go(PersonalCalendarPage.routePath);
                } else if (index == 10) {
                  context.go('/analytics');
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
