import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hackathon/dependency_injection.g.dart';
import 'package:hackathon/features/attendence/presentation/blocs/bloc/attendence_bloc.dart';
import 'package:hackathon/features/attendence/presentation/pages/check_in_page.dart';
import 'package:hackathon/features/attendence/presentation/pages/check_out_page.dart';
import 'package:hackathon/globals/constants/api_end_points.dart';
import 'package:hackathon/globals/constants/color_pallete.dart';
import 'package:hackathon/globals/constants/styles.dart';
import 'package:hackathon/features/dashboards/presentation/widgets/custom_button.dart';
import 'package:hackathon/features/notifications/presentation/widgets/notification_bell_widget.dart';
import 'package:hackathon/features/search/presentation/widgets/search_overlay_widget.dart';
import 'package:hackathon/globals/constants/user.dart';

class DashAppBar extends StatefulWidget {
  final bool isdashboard;
  final String? text;

  const DashAppBar({
    super.key,
    required this.swidth,
    this.isdashboard = true,
    this.text,
  });

  final double swidth;

  @override
  State<DashAppBar> createState() => _DashAppBarState();
}

class _DashAppBarState extends State<DashAppBar> {
  final AttendenceBloc attendenceBloc = getIt<AttendenceBloc>();

  @override
  void initState() {
    super.initState();
    debugPrint(
      "INIT STATE",
    );
    attendenceBloc.add(AttendenceGetEvent(userId: getIt<User>().user!.id));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 10),
        width: widget.swidth,
        height: 60,
        decoration: const BoxDecoration(
            color: ColorPallete.error,
            boxShadow: [
              BoxShadow(color: ColorPallete.backgroundPrimary, blurRadius: 15),
            ],
            borderRadius: BorderRadius.all(Radius.circular(15))),
        child: widget.isdashboard
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          CustomAttendanceButton(
                            attendenceBloc: attendenceBloc,
                            onTap: () {
                              context.push(CheckInPage.routePath);
                            },
                            text: "CHECK-IN",
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          CustomAttendanceButton(
                            attendenceBloc: attendenceBloc,
                            onTap: () {
                              context.push(CheckOutPage.routePath);
                            },
                            text: "CHECK-OUT",
                          ),
                        ],
                      ),
                    ),
                    const SearchOverlayWidget(),
                    const SizedBox(width: 15),
                    Text(
                      getIt<User>().user!.firstName,
                    ),
                    const NotificationBellWidget(),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: ColorPallete.backgroundPrimary,
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: getIt<User>().user!.profilePic.isEmpty
                              ? Center(
                                  child: Text(
                                    getIt<User>().user!.firstName.isNotEmpty
                                        ? getIt<User>().user!.firstName[0].toUpperCase()
                                        : '?',
                                    style: const TextStyle(
                                      color: ColorPallete.textPrimary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(40),
                                      image: DecorationImage(
                                          image: NetworkImage(
                                            getIt<User>().user!.profilePic.startsWith('http')
                                                ? getIt<User>().user!.profilePic
                                                : ApiConstants.getFileById(
                                                    getIt<User>().user!.profilePic),
                                          ),
                                          fit: BoxFit.cover)),
                                ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            : Center(
                child: Text(
                  widget.text!,
                  style: textTheme.bodyMedium,
                ),
              ));
  }
}

class CirlceClipper extends CustomClipper<Rect> {
  final double radius;
  CirlceClipper({required this.radius});
  @override
  Rect getClip(Size size) {
    return Rect.fromPoints(Offset.zero, Offset(radius, radius));
  }

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) {
    return true;
  }
}
