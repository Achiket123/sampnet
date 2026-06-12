import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hackathon/dependency_injection.g.dart';
import 'package:hackathon/globals/constants/color_pallete.dart';
import 'package:hackathon/features/settings/domain/entities/leave_policy_entity.dart';
import 'package:hackathon/features/settings/presentation/blocs/settings_bloc/settings_bloc.dart';
import 'package:hackathon/features/settings/presentation/blocs/settings_bloc/settings_event.dart';
import 'package:hackathon/features/settings/presentation/blocs/settings_bloc/settings_state.dart';

class LeavePolicyConfigPage extends StatefulWidget {
  const LeavePolicyConfigPage({super.key});

  @override
  State<LeavePolicyConfigPage> createState() => _LeavePolicyConfigPageState();
}

class _LeavePolicyConfigPageState extends State<LeavePolicyConfigPage> {
  final List<LeaveTypeConfig> _policies = [];
  bool _initialized = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SettingsBloc>()..add(LoadLeavePoliciesEvent()),
      child: BlocConsumer<SettingsBloc, SettingsState>(
        listener: (context, state) {
          if (state is LeavePoliciesLoaded && !_initialized) {
            setState(() {
              _policies.clear();
              _policies.addAll(state.policies.map((p) => LeaveTypeConfig(
                    id: p.id,
                    leaveType: p.leaveType,
                    maxDays: p.maxDays,
                    description: p.description,
                  )));
              _initialized = true;
            });
          } else if (state is SettingsActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: ColorPallete.success,
              ),
            );
            _initialized = false; // Trigger reload of fresh data
            context.read<SettingsBloc>().add(LoadLeavePoliciesEvent());
          } else if (state is SettingsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: ColorPallete.error,
              ),
            );
          }
        },
        builder: (context, state) {
          final bool isLoading = state is SettingsLoading;

          return Scaffold(
            backgroundColor: ColorPallete.backgroundPrimary,
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Leave Policies',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: ColorPallete.textPrimary,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Define maximum leave day limits and details for each leave category type.',
                            style: TextStyle(
                              fontSize: 14,
                              color: ColorPallete.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorPallete.redPrimary,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            _policies.add(LeaveTypeConfig(
                              leaveType: 'New Leave Type',
                              maxDays: 10,
                              description: 'Description of the leave policy benefits.',
                            ));
                          });
                        },
                        icon: const Icon(Icons.add, color: ColorPallete.textPrimary, size: 18),
                        label: const Text(
                          'Add Type',
                          style: TextStyle(color: ColorPallete.textPrimary, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  if (isLoading && _policies.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(48.0),
                        child: CircularProgressIndicator(color: ColorPallete.redPrimary),
                      ),
                    )
                  else
                    Column(
                      children: [
                        ..._policies.asMap().entries.map((entry) {
                          final int index = entry.key;
                          final LeaveTypeConfig policy = entry.value;
                          return _buildPolicyCard(context, index, policy);
                        }),
                        if (_policies.isNotEmpty) ...[
                          const SizedBox(height: 20),
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ColorPallete.redPrimary,
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: isLoading
                                  ? null
                                  : () {
                                      context.read<SettingsBloc>().add(UpdateLeavePoliciesEvent(_policies));
                                    },
                              child: isLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(ColorPallete.textPrimary),
                                      ),
                                    )
                                  : const Text(
                                      'Save Policies',
                                      style: TextStyle(
                                        color: ColorPallete.textPrimary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ],
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPolicyCard(BuildContext context, int index, LeaveTypeConfig policy) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ColorPallete.backgroundSecondary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorPallete.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  policy.leaveType.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: ColorPallete.textPrimary,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: ColorPallete.error),
                onPressed: () {
                  setState(() {
                    _policies.removeAt(index);
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Leave Type Name',
                      style: TextStyle(fontSize: 12, color: ColorPallete.textSecondary),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      initialValue: policy.leaveType,
                      style: const TextStyle(color: ColorPallete.textPrimary, fontSize: 14),
                      decoration: InputDecoration(
                        fillColor: ColorPallete.backgroundPrimary,
                        filled: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: const BorderSide(color: ColorPallete.divider),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: const BorderSide(color: ColorPallete.redPrimary),
                        ),
                      ),
                      onChanged: (val) {
                        _policies[index] = LeaveTypeConfig(
                          id: policy.id,
                          leaveType: val,
                          maxDays: policy.maxDays,
                          description: policy.description,
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Max Days Per Year',
                      style: TextStyle(fontSize: 12, color: ColorPallete.textSecondary),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      initialValue: policy.maxDays.toString(),
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: ColorPallete.textPrimary, fontSize: 14),
                      decoration: InputDecoration(
                        fillColor: ColorPallete.backgroundPrimary,
                        filled: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: const BorderSide(color: ColorPallete.divider),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: const BorderSide(color: ColorPallete.redPrimary),
                        ),
                      ),
                      onChanged: (val) {
                        final parsed = int.tryParse(val) ?? policy.maxDays;
                        _policies[index] = LeaveTypeConfig(
                          id: policy.id,
                          leaveType: policy.leaveType,
                          maxDays: parsed,
                          description: policy.description,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Policy Description',
                style: TextStyle(fontSize: 12, color: ColorPallete.textSecondary),
              ),
              const SizedBox(height: 6),
              TextFormField(
                initialValue: policy.description,
                maxLines: 2,
                style: const TextStyle(color: ColorPallete.textPrimary, fontSize: 14),
                decoration: InputDecoration(
                  fillColor: ColorPallete.backgroundPrimary,
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: const BorderSide(color: ColorPallete.divider),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: const BorderSide(color: ColorPallete.redPrimary),
                  ),
                ),
                onChanged: (val) {
                  _policies[index] = LeaveTypeConfig(
                    id: policy.id,
                    leaveType: policy.leaveType,
                    maxDays: policy.maxDays,
                    description: val,
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
