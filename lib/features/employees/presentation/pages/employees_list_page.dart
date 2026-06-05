import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hackathon/dependency_injection.g.dart';
import 'package:hackathon/features/employees/domain/entities/employee_entity.dart';
import 'package:hackathon/features/employees/presentation/blocs/employees_list_bloc/employees_list_bloc.dart';
import 'package:hackathon/features/employees/presentation/blocs/employees_list_bloc/employees_list_event.dart';
import 'package:hackathon/features/employees/presentation/blocs/employees_list_bloc/employees_list_state.dart';
import 'package:hackathon/features/employees/presentation/pages/employee_profile_page.dart';
import 'package:hackathon/features/employees/presentation/widgets/add_employee_modal.dart';
import 'package:hackathon/features/employees/presentation/widgets/edit_employee_modal.dart';
import 'package:hackathon/features/employees/presentation/widgets/employee_card_widget.dart';
import 'package:hackathon/features/employees/presentation/widgets/employee_search_bar.dart';
import 'package:hackathon/features/employees/presentation/widgets/promote_to_manager_dialog.dart';
import 'package:hackathon/features/chats/domain/entities/chat_entity.dart';
import 'package:hackathon/features/chats/presentation/pages/chat_page.dart';
import 'package:hackathon/globals/constants/user.dart';

class EmployeesListPage extends StatefulWidget {
  static const String routePath = '/employees';
  static const String routeName = 'employees';
  const EmployeesListPage({super.key});

  @override
  State<EmployeesListPage> createState() => _EmployeesListPageState();
}

class _EmployeesListPageState extends State<EmployeesListPage> {
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final user = getIt<User>();
    final orgId = user.organisation?.id;
    final userRole = getIt<User>().role;

    return BlocProvider(
      create: (context) => getIt<EmployeesListBloc>()..add(EmployeesListLoadRequested(orgId ?? 0)),
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: const Color.fromARGB(255, 20, 20, 20),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text('Employees', style: TextStyle(fontWeight: FontWeight.bold)),
          actions: [
            if (userRole == 'boss' || userRole == 'manager')
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: TextButton.icon(
                  onPressed: () => _showAddModal(context),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add Employee'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: const BorderSide(color: Colors.white10),
                    ),
                  ),
                ),
              ),
          ],
        ),
        body: BlocListener<EmployeesListBloc, EmployeesListState>(
          listener: (context, state) {
            if (state.status == EmployeesListStatus.deleteError || state.status == EmployeesListStatus.promoteError) {
              ElegantNotification.error(
                title: const Text("Error"),
                description: Text(state.failureMessage ?? "Something went wrong"),
              ).show(context);
            }
          },
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: EmployeeSearchBar(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    BlocBuilder<EmployeesListBloc, EmployeesListState>(
                      builder: (context, state) {
                        return Text(
                          '${state.displayedEmployees.length} members',
                          style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 13),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: BlocBuilder<EmployeesListBloc, EmployeesListState>(
                  builder: (context, state) {
                    if (state.status == EmployeesListStatus.loading && state.allEmployees.isEmpty) {
                      return _buildSkeleton();
                    }

                    if (state.displayedEmployees.isEmpty) {
                      return _buildEmptyState(context, state.searchQuery);
                    }

                    return RefreshIndicator(
                      onRefresh: () async {
                        context.read<EmployeesListBloc>().add(EmployeesListRefreshRequested(orgId ?? 0));
                      },
                      child: ListView.builder(
                        itemCount: state.displayedEmployees.length,
                        itemBuilder: (context, index) {
                          final employee = state.displayedEmployees[index];
                          return EmployeeCardWidget(
                            employee: employee,
                            userRole: userRole,
                            isDeleting: state.deletingEmployeeId == employee.userId,
                            onTap: () {
                              final currentUserId = getIt<User>().user?.id;
                              if (userRole == 'boss' || userRole == 'manager' || employee.userId == currentUserId) {
                                context.push('${EmployeeProfilePage.routePath}/${employee.userId}');
                              } else {
                                ElegantNotification.error(
                                  title: const Text('Access Denied'),
                                  description: const Text('You do not have permission to view other employee details.'),
                                ).show(context);
                              }
                            },
                            onAction: (action) => _handleAction(context, action, employee, userRole, orgId ?? 0),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    },
  ),
);
}

  void _showAddModal(BuildContext parentContext) {
    showModalBottomSheet(
      context: parentContext,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BlocProvider.value(
        value: parentContext.read<EmployeesListBloc>(),
        child: const AddEmployeeModal(),
      ),
    ).then((_) {
       // Refresh handled by modal's listener calling loadRequested
    });
  }

  void _handleAction(BuildContext context, String action, EmployeeEntity employee, String userRole, int orgId) async {
    switch (action) {
      case 'profile':
        context.push('${EmployeeProfilePage.routePath}/${employee.userId}');
        break;
      case 'chat':
        final chat = ChatEntity(
          id: employee.userId,
          firstName: employee.user.firstName,
          lastName: employee.user.lastName,
          email: employee.user.email,
          numberOfMessage: 0,
          lastMessageTimestamp: DateTime.now(),
          lastMessage: '',
        );
        context.push(ChatPage.routePath, extra: chat);
        break;
      case 'make_manager':
        final result = await showDialog<Map<String, String>>(
          context: context,
          builder: (context) => PromoteToManagerDialog(employee: employee),
        );
        if (result != null && context.mounted) {
          context.read<EmployeesListBloc>().add(EmployeeMakeManagerRequested(
            employeeId: employee.userId,
            organisationId: orgId,
            type: result['type'] ?? '',
            salary: result['salary'] ?? '',
          ));
        }
        break;
      case 'edit':
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (sheetContext) => BlocProvider.value(
            value: context.read<EmployeesListBloc>(),
            child: EditEmployeeModal(employee: employee),
          ),
        );
        break;
      case 'delete':
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Remove Employee'),
            content: Text('Are you sure you want to remove ${employee.user.fullName} from the organisation?'),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Remove', style: TextStyle(color: Colors.redAccent)),
              ),
            ],
          ),
        );
        if (confirmed == true && context.mounted) {
          context.read<EmployeesListBloc>().add(EmployeeDeleteRequested(employee.userId));
        }
        break;
    }
  }

  Widget _buildSkeleton() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Container(
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white10,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, String query) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline, size: 64, color: Colors.white.withValues(alpha: 0.1)),
          const SizedBox(height: 16),
          Text(
            query.isEmpty ? 'No employees yet' : 'No results found',
            style: const TextStyle(color: Colors.white70, fontSize: 16),
          ),
          if (query.isNotEmpty)
            TextButton(
              onPressed: () => context.read<EmployeesListBloc>().add(EmployeesSearchCleared()),
              child: const Text('Clear search'),
            ),
        ],
      ),
    );
  }
}
