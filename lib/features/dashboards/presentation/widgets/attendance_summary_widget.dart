import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hackathon/features/attendence/presentation/blocs/bloc/attendence_bloc.dart';
import 'package:hackathon/features/attendence/presentation/pages/check_in_page.dart';
import 'package:hackathon/globals/constants/color_pallete.dart';
import 'package:intl/intl.dart';

class AttendanceSummaryWidget extends StatelessWidget {
  const AttendanceSummaryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorPallete.backgroundSecondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: BlocBuilder<AttendenceBloc, AttendenceState>(
        builder: (context, state) {
          if (state is AttendenceLoading) {
            return _ShimmerAttendance();
          }

          if (state is AttendenceGetSuccess) {
            final attendance = state.attendenceEntity;
            final hasCheckedIn = attendance.checkinTime != null;
            final hasCheckedOut = attendance.checkoutTime != null;

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Attendance",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: ColorPallete.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      !hasCheckedIn
                          ? "Not checked in today"
                          : hasCheckedOut
                              ? "Shift ended at ${DateFormat('HH:mm').format(attendance.checkoutTime!)}"
                              : "Checked in at ${DateFormat('HH:mm').format(attendance.checkinTime!)}",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: !hasCheckedIn ? ColorPallete.error : ColorPallete.statusColor('approved'),
                          ),
                    ),
                  ],
                ),
                if (!hasCheckedIn)
                  ElevatedButton.icon(
                    onPressed: () => context.push(CheckInPage.routePath),
                    icon: const Icon(Icons.login, size: 16),
                    label: const Text("Check In"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorPallete.redPrimary,
                      foregroundColor: ColorPallete.textPrimary,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                  )
                else if (!hasCheckedOut)
                  Icon(Icons.check_circle, color: ColorPallete.statusColor('approved'))
                else
                  const Icon(Icons.done_all, color: ColorPallete.redPrimary),
              ],
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}

class _ShimmerAttendance extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(width: 80, height: 12, decoration: BoxDecoration(color: ColorPallete.textPrimary.withOpacity(0.05), borderRadius: BorderRadius.circular(6))),
            const SizedBox(height: 8),
            Container(width: 120, height: 8, decoration: BoxDecoration(color: ColorPallete.textPrimary.withOpacity(0.05), borderRadius: BorderRadius.circular(4))),
          ],
        ),
        Container(width: 80, height: 32, decoration: BoxDecoration(color: ColorPallete.textPrimary.withOpacity(0.05), borderRadius: BorderRadius.circular(16))),
      ],
    );
  }
}
