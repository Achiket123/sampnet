import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hackathon/dependency_injection.g.dart';
import 'package:hackathon/features/employees/domain/entities/employee_entity.dart';
import 'package:hackathon/features/employees/presentation/blocs/employee_profile_bloc/employee_profile_bloc.dart';
import 'package:hackathon/features/employees/presentation/blocs/employee_profile_bloc/employee_profile_state.dart';
import 'package:hackathon/features/employees/presentation/blocs/employees_list_bloc/employees_list_bloc.dart';
import 'package:hackathon/features/employees/presentation/widgets/edit_employee_modal.dart';
import 'package:hackathon/globals/constants/user.dart';
import 'package:intl/intl.dart';
import 'package:hackathon/globals/constants/color_pallete.dart';

class EmployeeProfilePage extends StatefulWidget {
  final int employeeId;
  static const String routePath = '/employees/profile';
  static const String routeName = 'employee-profile';
  
  const EmployeeProfilePage({super.key, required this.employeeId});

  @override
  State<EmployeeProfilePage> createState() => _EmployeeProfilePageState();
}

class _EmployeeProfilePageState extends State<EmployeeProfilePage> {
  @override
  Widget build(BuildContext context) {
    final user = getIt<User>();
    final userRole = user.role;
    final currentUserId = user.user?.id;

    return BlocProvider(
      create: (context) => getIt<EmployeeProfileBloc>()..add(EmployeeProfileLoadRequested(widget.employeeId)),
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 20, 20, 20),
        appBar: AppBar(
          backgroundColor: ColorPallete.transparent,
          elevation: 0,
          title: const Text('Profile'),
        ),
        body: BlocListener<EmployeeProfileBloc, EmployeeProfileState>(
          listener: (context, state) {
            if (state is EmployeeProfileDeleted) {
              Navigator.pop(context);
            }
          },
          child: BlocBuilder<EmployeeProfileBloc, EmployeeProfileState>(
            builder: (context, state) {
              if (state is EmployeeProfileLoading) {
                return _buildSkeleton();
              }
              if (state is EmployeeProfileError) {
                return Center(child: Text(state.message, style: const TextStyle(color: ColorPallete.error)));
              }
              if (state is EmployeeProfileLoaded) {
                final employee = state.employee;
                final isOwnProfile = currentUserId == employee.userId;

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: ColorPallete.redPrimary.withValues(alpha: 0.1),
                        backgroundImage: employee.user.profilePic.isNotEmpty
                            ? NetworkImage(employee.user.profilePic)
                            : null,
                        child: employee.user.profilePic.isEmpty
                            ? Text(
                                employee.user.initials,
                                style: const TextStyle(fontSize: 32, color: ColorPallete.redPrimary, fontWeight: FontWeight.bold),
                              )
                            : null,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        employee.user.fullName,
                        style: const TextStyle(color: ColorPallete.textPrimary, fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        employee.roleDisplayLabel,
                        style: TextStyle(color: ColorPallete.textPrimary.withValues(alpha: 0.5), fontSize: 16),
                      ),
                      const SizedBox(height: 32),
                      _buildDetailRow('Email', employee.user.email, Icons.email_outlined),
                      _buildDetailRow('Phone', employee.user.phoneNumber, Icons.phone_outlined),
                      _buildDetailRow('Employment ID', employee.employmentId.toString(), Icons.badge_outlined),
                      _buildDetailRow('Organisation', employee.organisationName, Icons.business_outlined),
                      _buildDetailRow('Last Login', DateFormat('MMM dd, yyyy HH:mm').format(employee.lastLoginAt), Icons.login_outlined),
                      if (isOwnProfile || userRole == 'boss' || userRole == 'manager')
                        _buildDetailRow('Salary', employee.salary, Icons.payments_outlined),
                      
                      if (isOwnProfile || userRole == 'boss' || userRole == 'manager')
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => _showEditModal(context, employee, isOwnProfile),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: ColorPallete.textPrimary,
                                  side: const BorderSide(color: ColorPallete.divider),
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                child: Text(isOwnProfile ? 'Edit Profile' : 'Edit Employee'),
                              ),
                            ),
                            if (!isOwnProfile && (userRole == 'boss' || userRole == 'manager')) ...[
                              const SizedBox(width: 16),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () => _showDeleteConfirmation(context, employee),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: ColorPallete.error.withValues(alpha: 0.1),
                                    foregroundColor: ColorPallete.error,
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                  child: const Text('Remove'),
                                ),
                              ),
                            ],
                          ],
                        ),
                      if (userRole == 'boss' || userRole == 'manager') ...[
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              context.push('/analytics/employee/${employee.userId}');
                            },
                            icon: const Icon(Icons.analytics_outlined),
                            label: const Text('View Employee Analytics'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorPallete.redPrimary.withValues(alpha: 0.1),
                              foregroundColor: ColorPallete.redPrimary,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: ColorPallete.textPrimary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: ColorPallete.textSecondary, size: 20),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(color: ColorPallete.textPrimary.withValues(alpha: 0.3), fontSize: 12)),
              const SizedBox(height: 2),
              Text(value.isNotEmpty ? value : 'Not set', style: const TextStyle(color: ColorPallete.textPrimary, fontSize: 15)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSkeleton() {
    return const Center(child: CircularProgressIndicator());
  }

  void _showEditModal(BuildContext context, EmployeeEntity employee, bool isOwnProfile) async {
    final bloc = context.read<EmployeeProfileBloc>();
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: ColorPallete.transparent,
      builder: (sheetContext) => BlocProvider<EmployeesListBloc>(
        create: (context) => getIt<EmployeesListBloc>(),
        child: EditEmployeeModal(employee: employee, isOwnProfile: isOwnProfile),
      ),
    );
    bloc.add(EmployeeProfileLoadRequested(widget.employeeId));
  }

  void _showDeleteConfirmation(BuildContext context, EmployeeEntity employee) async {
    final bloc = context.read<EmployeeProfileBloc>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color.fromARGB(255, 30, 30, 30),
        title: const Text('Remove Employee'),
        content: Text('Are you sure you want to remove ${employee.user.fullName} from the organisation?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Remove', style: TextStyle(color: ColorPallete.error)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      bloc.add(EmployeeProfileDeleteRequested(employee.userId));
    }
  }
}
