import 'package:flutter/material.dart';
import 'package:hackathon/features/attendence/presentation/pages/attendance_service.dart';

final AttendanceService attendanceService = AttendanceService();

showWorkInProgerss(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) => Dialog(
            child: SizedBox(
              height: 100,
              child:
                  const Center(child: Text("Work is Under Progress For this Page")),
            ),
          ));
}
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
