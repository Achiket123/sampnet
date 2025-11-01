
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
    attendenceBloc.add(AttendenceGetEvent(userId: User.user.id));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 10),
        width: widget.swidth,
        height: 60,
        decoration: const BoxDecoration(
            color: Colors.red,
            boxShadow: [
              BoxShadow(color: ColorPallete.blackPrimary, blurRadius: 15),
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
                    Text(
                      User.user.firstName,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: ColorPallete.white,
                          borderRadius: BorderRadius.circular(6)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "You have a Notification",
                            style: textTheme.displayMedium!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text("You have a Notification",
                              overflow: TextOverflow.clip,
                              style: textTheme.displayMedium!
                                  .copyWith(fontSize: 8))
                        ],
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const CircleAvatar(
                          child: Icon(Icons.notification_add),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              image: DecorationImage(
                                  image: NetworkImage(
                                    ApiConstants.getFileById(
                                        User.user.profilePic),
                                  ),
                                  fit: BoxFit.cover)),
                          height: 40,
                          width: 40,
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
