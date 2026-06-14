import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hackathon/dependency_injection.g.dart';
import 'package:hackathon/features/leave/presentation/blocs/leave_bloc/leave_bloc.dart';
import 'package:hackathon/features/leave/presentation/blocs/leave_bloc/leave_event.dart';
import 'package:hackathon/features/leave/presentation/blocs/leave_bloc/leave_state.dart';
import 'package:hackathon/features/settings/domain/use_cases/get_leave_policies_use_case.dart';
import 'package:hackathon/globals/constants/user.dart';
import 'package:intl/intl.dart';
import 'package:hackathon/globals/constants/color_pallete.dart';

class LeaveRequestPage extends StatefulWidget {
  static const routePath = '/leave-request';
  static const routeName = 'leave-request';
  const LeaveRequestPage({super.key});

  @override
  State<LeaveRequestPage> createState() => _LeaveRequestPageState();
}

class _LeaveRequestPageState extends State<LeaveRequestPage> {
  final _formKey = GlobalKey<FormState>();
  final _reasonController = TextEditingController();
  String _selectedLeaveType = 'annual';
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 1));

  final List<String> _leaveTypes = [];
  bool _isLoadingTypes = true;

  @override
  void initState() {
    super.initState();
    _loadLeaveTypes();
  }

  Future<void> _loadLeaveTypes() async {
    final result = await getIt<GetLeavePoliciesUseCase>().call();
    result.fold(
      (failure) {
        setState(() {
          _leaveTypes.clear();
          _leaveTypes.addAll([
            'annual',
            'sick',
            'unpaid',
            'maternity',
            'paternity',
            'emergency'
          ]);
          _selectedLeaveType = _leaveTypes.first;
          _isLoadingTypes = false;
        });
      },
      (policies) {
        setState(() {
          _leaveTypes.clear();
          if (policies.isEmpty) {
            _leaveTypes.addAll([
              'annual',
              'sick',
              'unpaid',
              'maternity',
              'paternity',
              'emergency'
            ]);
          } else {
            _leaveTypes.addAll(policies.map((p) => p.leaveType).toList());
          }
          _selectedLeaveType = _leaveTypes.contains(_selectedLeaveType)
              ? _selectedLeaveType
              : _leaveTypes.isNotEmpty
                  ? _leaveTypes.first
                  : 'annual';
          _isLoadingTypes = false;
        });
      },
    );
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _startDate : _endDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      builder: (context, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(
              primary: ColorPallete.textPrimary,
              onPrimary: ColorPallete.textSecondary,
              surface: ColorPallete.backgroundPrimary),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
          if (_endDate.isBefore(_startDate)) {
            _endDate = _startDate.add(const Duration(days: 1));
          }
        } else {
          _endDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPallete.backgroundPrimary,
      appBar: AppBar(
        backgroundColor: ColorPallete.error,
        elevation: 0,
        leading: IconButton(
            icon: const Icon(Icons.close_rounded, color: ColorPallete.textPrimary),
            onPressed: () => Navigator.pop(context)),
        title: const Text('Time Off Request',
            style: TextStyle(fontWeight: FontWeight.bold, color: ColorPallete.textPrimary)),
      ),
      body: BlocListener<LeaveBloc, LeaveState>(
        listener: (context, state) {
          if (state is LeaveRequestSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Leave request submitted!')));
            Navigator.pop(context);
          } else if (state is LeaveError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                const SizedBox(height: 12),
                if (_isLoadingTypes)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Center(
                      child: CircularProgressIndicator.adaptive(),
                    ),
                  )
                else
                  DropdownButtonFormField<String>(
                    value: _selectedLeaveType,
                    dropdownColor: ColorPallete.backgroundPrimary,
                    style: const TextStyle(color: ColorPallete.textPrimary, fontSize: 15),
                    decoration: const InputDecoration(
                      labelText: 'Absence Framework Type',
                      prefixIcon: Icon(Icons.category_rounded,
                          color: ColorPallete.textSecondary),
                    ),
                    items: _leaveTypes.map((type) {
                      return DropdownMenuItem(
                          value: type,
                          child: Text(type.isNotEmpty
                              ? type[0].toUpperCase() + type.substring(1)
                              : ''));
                    }).toList(),
                    onChanged: (value) =>
                        setState(() => _selectedLeaveType = value!),
                  ),
                const SizedBox(height: 20),

                // Formatted Time Selectors Containers
                Row(
                  children: [
                    Expanded(
                        child: _buildDateCard('START DATE', _startDate,
                            () => _selectDate(context, true))),
                    const SizedBox(width: 12),
                    Expanded(
                        child: _buildDateCard('END DATE', _endDate,
                            () => _selectDate(context, false))),
                  ],
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _reasonController,
                  style: const TextStyle(color: ColorPallete.textPrimary),
                  decoration: const InputDecoration(
                    labelText: 'Reason Statement',
                    alignLabelWithHint: true,
                  ),
                  maxLines: 4,
                  validator: (value) => (value == null || value.isEmpty)
                      ? 'Please provide a valid rationale'
                      : null,
                ),
                const SizedBox(height: 32),
                BlocBuilder<LeaveBloc, LeaveState>(
                  builder: (context, state) {
                    if (state is LeaveLoading) {
                      return const Center(
                          child: CircularProgressIndicator.adaptive());
                    }
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorPallete.textPrimary,
                        minimumSize: const Size(double.infinity, 52),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final orgId = getIt<User>().organisation?.id;
                          if (orgId == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Target workspace missing')));
                            return;
                          }
                          context.read<LeaveBloc>().add(RequestLeaveEvent(
                                organisationId: orgId,
                                leaveType: _selectedLeaveType,
                                startDate: _startDate,
                                endDate: _endDate,
                                reason: _reasonController.text,
                              ));
                        }
                      },
                      child: const Text('Transmit Request File',
                          style: TextStyle(
                              color: ColorPallete.textSecondary,
                              fontWeight: FontWeight.w800,
                              fontSize: 15)),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateCard(String title, DateTime date, VoidCallback tap) {
    return InkWell(
      onTap: tap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
            color: ColorPallete.backgroundPrimary,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: ColorPallete.divider)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    fontSize: 10,
                    color: ColorPallete.textDisabled,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5)),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(DateFormat('MMM dd, yyyy').format(date),
                    style: const TextStyle(
                        color: ColorPallete.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 14)),
                const Icon(Icons.calendar_month_rounded,
                    size: 16, color: ColorPallete.textSecondary),
              ],
            )
          ],
        ),
      ),
    );
  }
}
