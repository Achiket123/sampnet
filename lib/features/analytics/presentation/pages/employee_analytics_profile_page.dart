import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hackathon/dependency_injection.g.dart';
import 'package:hackathon/features/analytics/domain/entities/employee_analytics_entity.dart';
import 'package:hackathon/features/analytics/presentation/blocs/org_analytics_bloc/org_analytics_bloc.dart';
import 'package:hackathon/globals/constants/color_pallete.dart';
import 'package:hackathon/globals/constants/user.dart';
import 'package:hackathon/features/dashboards/presentation/widgets/side_bar_widget.dart';
import 'package:hackathon/features/dashboards/presentation/widgets/app_bar.dart';
import 'package:intl/intl.dart';

class EmployeeAnalyticsProfilePage extends StatefulWidget {
  final String employeeId;

  const EmployeeAnalyticsProfilePage({super.key, required this.employeeId});

  @override
  State<EmployeeAnalyticsProfilePage> createState() => _EmployeeAnalyticsProfilePageState();
}

class _EmployeeAnalyticsProfilePageState extends State<EmployeeAnalyticsProfilePage> {
  late OrgAnalyticsBloc _analyticsBloc;
  final User _user = getIt<User>();

  @override
  void initState() {
    super.initState();
    _analyticsBloc = getIt<OrgAnalyticsBloc>();
    _analyticsBloc.add(LoadEmployeeAnalyticsDetail(
      employeeId: int.parse(widget.employeeId),
      orgId: _user.organisation?.id ?? 0,
      period: 'month',
    ));
  }

  @override
  void dispose() {
    _analyticsBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final swidth = MediaQuery.of(context).size.width;
    final sheight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: ColorPallete.backgroundPrimary,
      body: Row(
        children: [

          Expanded(
            child: Column(
              children: [
                DashAppBar(swidth: swidth, isdashboard: false, text: 'Employee Profile Analytics'),
                Expanded(
                  child: BlocProvider.value(
                    value: _analyticsBloc,
                    child: BlocBuilder<OrgAnalyticsBloc, OrgAnalyticsState>(
                      builder: (context, state) {
                        if (state is OrgAnalyticsLoading || state is OrgAnalyticsInitial) {
                          return const Center(child: CircularProgressIndicator(color: ColorPallete.redPrimary));
                        } else if (state is EmployeeAnalyticsDetailLoaded) {
                          return _buildProfileDashboard(state.summary);
                        } else if (state is OrgAnalyticsError) {
                          return Center(child: Text(state.message, style: const TextStyle(color: ColorPallete.redPrimary)));
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildCompactHeader(EmployeeAnalyticsSummaryEntity summary) {
    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: ColorPallete.redPrimary.withOpacity(0.1),
          child: Text(summary.employeeInfo.user.fullName[0], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(summary.employeeInfo.user.fullName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(summary.employeeInfo.type, style: const TextStyle(fontSize: 12, color: ColorPallete.textSecondary)),
          ],
        ),
      ],
    );
  }

  Widget _buildProfileDashboard(EmployeeAnalyticsSummaryEntity summary) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Simplified Header
          _buildCompactHeader(summary),
          const SizedBox(height: 24),

          // Compact Stats Strip (Uses Wrap for responsiveness)
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildCompactMetric("Present", "${summary.attendance.presentDays}", Icons.check_circle_outline, Colors.green),
              _buildCompactMetric("Leaves", "${summary.leave.totalLeavesInPeriod}", Icons.hotel, Colors.orange),
              _buildCompactMetric("Completion", "${summary.tasks.completionRate.toInt()}%", Icons.task_alt, Colors.blue),
              _buildCompactMetric("Overdue", "${summary.tasks.overdue}", Icons.warning_amber, Colors.red),
              _buildCompactMetric("Avg hrs", "${(summary.attendance.averageDurationMinutes/60).toStringAsFixed(1)}h", Icons.timer, Colors.purple),
            ],
          ),
          const SizedBox(height: 24),

          // Two-Column Layout with better usage of space
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildAttendanceDetails(summary)),
              const SizedBox(width: 16),
              Expanded(child: _buildLeaveDetails(summary)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildCompactMetric(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: ColorPallete.backgroundSecondary,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: ColorPallete.divider.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 8),
          Text(title, style: const TextStyle(fontSize: 12, color: ColorPallete.textSecondary)),
          const SizedBox(width: 8),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }

  

  Widget _buildAttendanceDetails(EmployeeAnalyticsSummaryEntity summary) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ColorPallete.backgroundSecondary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorPallete.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Attendance Details", style: TextStyle(color: ColorPallete.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _buildDetailRow("Attendance Rate", "${summary.attendance.attendanceRate.toStringAsFixed(1)}%"),
          _buildDetailRow("Average Check-in", summary.attendance.averageCheckInTime),
          _buildDetailRow("Average Duration", "${summary.attendance.averageDurationMinutes ~/ 60}h ${summary.attendance.averageDurationMinutes % 60}m"),
          _buildDetailRow("Absent Days", "${summary.attendance.absentDays}"),
        ],
      ),
    );
  }

  Widget _buildLeaveDetails(EmployeeAnalyticsSummaryEntity summary) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ColorPallete.backgroundSecondary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorPallete.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Leaves By Type", style: TextStyle(color: ColorPallete.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          if (summary.leave.leavesByType.isEmpty)
            const Text("No leaves recorded.", style: TextStyle(color: ColorPallete.textSecondary)),
          ...summary.leave.leavesByType.entries.map((e) {
            return _buildDetailRow(e.key, "${e.value} days");
          }),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: ColorPallete.textSecondary)),
          Text(value, style: const TextStyle(color: ColorPallete.textPrimary, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
