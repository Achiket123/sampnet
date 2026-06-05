import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hackathon/dependency_injection.g.dart';
import 'package:hackathon/features/leave/presentation/blocs/leave_bloc/leave_bloc.dart';
import 'package:hackathon/features/leave/presentation/blocs/leave_bloc/leave_event.dart';
import 'package:hackathon/features/leave/presentation/blocs/leave_bloc/leave_state.dart';
import 'package:hackathon/globals/constants/user.dart';
import 'package:intl/intl.dart';

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

  final List<String> _leaveTypes = [
    'annual',
    'sick',
    'unpaid',
    'maternity',
    'paternity',
    'emergency'
  ];

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _startDate : _endDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      builder: (context, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(
              primary: Colors.white,
              onPrimary: Colors.black,
              surface: Color(0xFF16161A)),
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
      backgroundColor: const Color(0xFF0F0F11),
      appBar: AppBar(
        backgroundColor: Colors.red,
        elevation: 0,
        leading: IconButton(
            icon: const Icon(Icons.close_rounded, color: Colors.white),
            onPressed: () => Navigator.pop(context)),
        title: const Text('Time Off Request',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
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
                DropdownButtonFormField<String>(
                  value: _selectedLeaveType,
                  dropdownColor: const Color(0xFF16161A),
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                  decoration: InputDecoration(
                    labelText: 'Absence Framework Type',
                    labelStyle: const TextStyle(color: Colors.white38),
                    prefixIcon: const Icon(Icons.category_rounded,
                        color: Colors.white54),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: Colors.white10)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: Colors.white38)),
                  ),
                  items: _leaveTypes.map((type) {
                    return DropdownMenuItem(
                        value: type,
                        child: Text(type[0].toUpperCase() + type.substring(1)));
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
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Reason Statement',
                    labelStyle: const TextStyle(color: Colors.white38),
                    alignLabelWithHint: true,
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: Colors.white10)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: Colors.white38)),
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
                        backgroundColor: Colors.white,
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
                              color: Colors.black,
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
            color: const Color(0xFF16161A),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    fontSize: 10,
                    color: Colors.white38,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5)),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(DateFormat('MMM dd, yyyy').format(date),
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14)),
                const Icon(Icons.calendar_month_rounded,
                    size: 16, color: Colors.white54),
              ],
            )
          ],
        ),
      ),
    );
  }
}
