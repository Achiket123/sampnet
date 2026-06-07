import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hackathon/dependency_injection.g.dart';
import 'package:hackathon/features/analytics/domain/entities/employee_analytics_entity.dart';
import 'package:hackathon/features/analytics/presentation/blocs/org_analytics_bloc/org_analytics_bloc.dart';
import 'package:hackathon/globals/constants/color_pallete.dart';
import 'package:hackathon/globals/constants/user.dart';
import 'package:hackathon/features/dashboards/presentation/widgets/side_bar_widget.dart';
import 'package:hackathon/features/dashboards/presentation/widgets/app_bar.dart';
import 'package:intl/intl.dart';

class OrgAnalyticsDashboardPage extends StatefulWidget {
  const OrgAnalyticsDashboardPage({super.key});

  @override
  State<OrgAnalyticsDashboardPage> createState() => _OrgAnalyticsDashboardPageState();
}

class _OrgAnalyticsDashboardPageState extends State<OrgAnalyticsDashboardPage> {
  late OrgAnalyticsBloc _analyticsBloc;
  final User _user = getIt<User>();

  @override
  void initState() {
    super.initState();
    _analyticsBloc = getIt<OrgAnalyticsBloc>();
    _analyticsBloc.add(LoadOrgAnalyticsMonitor(_user.organisation?.id ?? 0));
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
                DashAppBar(swidth: swidth, isdashboard: false, text: 'Organization Analytics'),
                Expanded(
                  child: BlocProvider.value(
                    value: _analyticsBloc,
                    child: BlocBuilder<OrgAnalyticsBloc, OrgAnalyticsState>(
                      builder: (context, state) {
                        if (state is OrgAnalyticsLoading || state is OrgAnalyticsInitial) {
                          return const Center(child: CircularProgressIndicator(color: ColorPallete.redPrimary));
                        } else if (state is OrgMonitorLoaded) {
                          return _buildMonitorDashboard(state.monitorData);
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

  Widget _buildMonitorDashboard(List<EmployeeMonitorResponseEntity> data) {
    if (data.isEmpty) {
      return const Center(child: Text("No employees found.", style: TextStyle(color: ColorPallete.textSecondary)));
    }

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Employee Performance Monitor",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: ColorPallete.textPrimary),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.5,
              ),
              itemCount: data.length,
              itemBuilder: (context, index) {
                final empData = data[index];
                return _buildEmployeeCard(empData);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeeCard(EmployeeMonitorResponseEntity empData) {
    final emp = empData.employeeInfo;
    final snap = empData.snapshot;

    Color statusColor;
    switch (snap.status) {
      case 'active':
        statusColor = Colors.green;
        break;
      case 'idle':
        statusColor = Colors.orange;
        break;
      default:
        statusColor = Colors.grey;
    }

    return InkWell(
      onTap: () {
        context.push('/analytics/employee/${emp.userId}');
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: ColorPallete.backgroundSecondary,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: ColorPallete.divider),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: ColorPallete.redPrimary.withOpacity(0.2),
                  child: Text(
                    emp.user.fullName.substring(0, 1).toUpperCase(),
                    style: const TextStyle(color: ColorPallete.redPrimary, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(emp.user.fullName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: ColorPallete.textPrimary)),
                      Text(emp.type, style: const TextStyle(color: ColorPallete.textSecondary, fontSize: 12)),
                    ],
                  ),
                ),
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle),
                ),
              ],
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatItem("Attendance", "${snap.attendanceRateThisMonth.toStringAsFixed(0)}%"),
                _buildStatItem("Leaves Pending", "${snap.leavesPending}"),
                _buildStatItem("Tasks Overdue", "${snap.tasksOverdue}", isAlert: snap.tasksOverdue > 0),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              "Last Seen: ${snap.lastSeen != null ? DateFormat('MMM dd, yyyy HH:mm').format(snap.lastSeen!.toLocal()) : 'Never'}",
              style: const TextStyle(color: ColorPallete.textSecondary, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, {bool isAlert = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: ColorPallete.textSecondary, fontSize: 12)),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: isAlert ? ColorPallete.redPrimary : ColorPallete.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
