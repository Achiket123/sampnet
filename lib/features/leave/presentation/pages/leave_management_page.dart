import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hackathon/dependency_injection.g.dart';
import 'package:hackathon/features/leave/domain/entities/leave_entity.dart';
import 'package:hackathon/features/leave/presentation/blocs/leave_bloc/leave_bloc.dart';
import 'package:hackathon/features/leave/presentation/blocs/leave_bloc/leave_event.dart';
import 'package:hackathon/features/leave/presentation/blocs/leave_bloc/leave_state.dart';
import 'package:hackathon/features/leave/presentation/pages/leave_request_page.dart';
import 'package:hackathon/features/leave/presentation/widgets/leave_balance_card.dart'; // Import your provided balance card component
import 'package:hackathon/globals/constants/user.dart';
import 'package:intl/intl.dart';

class LeaveManagementPage extends StatefulWidget {
  static const routePath = '/leave-management';
  static const routeName = 'leave-management';
  const LeaveManagementPage({super.key});

  @override
  State<LeaveManagementPage> createState() => _LeaveManagementPageState();
}

class _LeaveManagementPageState extends State<LeaveManagementPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<LeaveBloc>()..add(const GetMyLeavesEvent()),
      // CRITICAL FIX: Add a Builder here to provide a context *below* the BlocProvider
      child: Builder(builder: (context) {
        return Scaffold(
          backgroundColor: const Color(0xFF0F0F11),
          appBar: AppBar(
            backgroundColor: Colors.red,
            elevation: 0,
            title: const Text('Leave Balance',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.white)),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(50),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(
                    05,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  indicator: BoxDecoration(
                    color: const Color(0xFF16161A),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white10),
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white38,
                  tabs: const [
                    Tab(text: 'My Account'),
                    Tab(text: 'Team Matrix'),
                  ],
                ),
              ),
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: const [
              _MyLeavesTab(),
              _TeamLeavesTab(),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            backgroundColor: Colors.white,
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (innerContext) => BlocProvider.value(
                  value: BlocProvider.of<LeaveBloc>(context),
                  child: const LeaveRequestPage(),
                ),
              ),
            ),
            label: const Text('Request Absence',
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold)),
            icon: const Icon(Icons.add_circle_outline_rounded,
                color: Colors.black),
          ),
        );
      }),
    );
  }
}

class _MyLeavesTab extends StatelessWidget {
  const _MyLeavesTab();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LeaveBloc, LeaveState>(
      builder: (context, state) {
        if (state is LeaveLoading) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }

        final List<Leave> leaves =
            (state is MyLeavesLoaded) ? state.leaves : [];

        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            const SliverToBoxAdapter(child: LeaveBalanceCard()),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              sliver: SliverToBoxAdapter(
                child: Text('HISTORICAL TIMELINE',
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade600,
                        letterSpacing: 1.1)),
              ),
            ),
            leaves.isEmpty
                ? const SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                          padding: EdgeInsets.all(40.0),
                          child: Text('No allocations recorded',
                              style: TextStyle(color: Colors.white38))),
                    ),
                  )
                : SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) =>
                            _LeaveListItem(leave: leaves[index]),
                        childCount: leaves.length,
                      ),
                    ),
                  ),
          ],
        );
      },
    );
  }
}

class _TeamLeavesTab extends StatefulWidget {
  const _TeamLeavesTab();

  @override
  State<_TeamLeavesTab> createState() => _TeamLeavesTabState();
}

class _TeamLeavesTabState extends State<_TeamLeavesTab> {
  @override
  void initState() {
    super.initState();
    final orgId = getIt<User>().organisation?.id;
    if (orgId != null) {
      context
          .read<LeaveBloc>()
          .add(GetOrganisationLeavesEvent(organisationId: orgId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LeaveBloc, LeaveState>(
      builder: (context, state) {
        if (state is LeaveLoading) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }

        final List<Leave> teamLeaves =
            (state is OrganisationLeavesLoaded) ? state.leaves : [];

        if (teamLeaves.isEmpty) {
          return const Center(
              child: Text('No active organizational leaves found',
                  style: TextStyle(color: Colors.white38)));
        }

        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          itemCount: teamLeaves.length,
          itemBuilder: (context, index) =>
              _LeaveListItem(leave: teamLeaves[index], isManagerView: true),
        );
      },
    );
  }
}

class _LeaveListItem extends StatelessWidget {
  final Leave leave;
  final bool isManagerView;

  const _LeaveListItem({required this.leave, this.isManagerView = false});

  Color _getStatusColor() {
    switch (leave.status.toLowerCase()) {
      case 'approved':
        return Colors.greenAccent;
      case 'rejected':
        return Colors.redAccent;
      case 'cancelled':
        return Colors.grey;
      default:
        return Colors.orangeAccent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor();
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
          color: const Color(0xFF16161A),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withAlpha(05),
          )),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: isManagerView && leave.status.toLowerCase() == 'pending'
              ? () => _showActionDialog(context)
              : null,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            leave.leaveType.toUpperCase(),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 15,
                                letterSpacing: 0.3),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(6)),
                            child: Text(
                              leave.status.toUpperCase(),
                              style: TextStyle(
                                  color: statusColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.date_range_rounded,
                              size: 14, color: Colors.white38),
                          const SizedBox(width: 6),
                          Text(
                            '${DateFormat('MMM d').format(leave.startDate)} - ${DateFormat('MMM d, yyyy').format(leave.endDate)}',
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 13),
                          ),
                        ],
                      ),
                      if (leave.reason.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Text('Reason: ${leave.reason}',
                            style: TextStyle(
                                color: Colors.grey.shade500, fontSize: 13),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                      ],
                      if (leave.managerNote.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Text('Note: ${leave.managerNote}',
                            style: TextStyle(
                                color: statusColor.withOpacity(0.7),
                                fontSize: 12,
                                fontStyle: FontStyle.italic)),
                      ],
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('${leave.totalDays}',
                        style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            height: 1.0)),
                    Text(leave.totalDays == 1 ? 'day' : 'days',
                        style: const TextStyle(
                            fontSize: 12, color: Colors.white38)),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showActionDialog(BuildContext context) {
    final noteController = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF16161A),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Colors.white10)),
        title: const Text('Process Leave Request',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: TextField(
          controller: noteController,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: 'Manager Note (Optional)',
            labelStyle: const TextStyle(color: Colors.white38),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.white10)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.blueAccent)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              context.read<LeaveBloc>().add(RejectLeaveEvent(
                  leaveId: leave.id, managerNote: noteController.text));
              Navigator.pop(dialogContext);
            },
            child: const Text('Reject Request',
                style: TextStyle(
                    color: Colors.redAccent, fontWeight: FontWeight.bold)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8))),
            onPressed: () {
              context.read<LeaveBloc>().add(ApproveLeaveEvent(
                  leaveId: leave.id, managerNote: noteController.text));
              Navigator.pop(dialogContext);
            },
            child: const Text('Approve',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
