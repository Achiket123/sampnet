import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hackathon/dependency_injection.g.dart';
import 'package:hackathon/globals/constants/color_pallete.dart';
import 'package:hackathon/features/settings/domain/entities/attendance_policy_entity.dart';
import 'package:hackathon/features/settings/presentation/blocs/settings_bloc/settings_bloc.dart';
import 'package:hackathon/features/settings/presentation/blocs/settings_bloc/settings_event.dart';
import 'package:hackathon/features/settings/presentation/blocs/settings_bloc/settings_state.dart';

class AttendancePolicyPage extends StatefulWidget {
  const AttendancePolicyPage({super.key});

  @override
  State<AttendancePolicyPage> createState() => _AttendancePolicyPageState();
}

class _AttendancePolicyPageState extends State<AttendancePolicyPage> {
  final _formKey = GlobalKey<FormState>();
  final _checkInController = TextEditingController();
  final _checkOutController = TextEditingController();
  final _gracePeriodController = TextEditingController();
  int? _existingId;

  @override
  void dispose() {
    _checkInController.dispose();
    _checkOutController.dispose();
    _gracePeriodController.dispose();
    super.dispose();
  }

  Future<void> _selectTime(BuildContext context, TextEditingController controller) async {
    TimeOfDay initialTime = const TimeOfDay(hour: 9, minute: 0);
    if (controller.text.isNotEmpty) {
      try {
        final parts = controller.text.split(':');
        initialTime = TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
      } catch (_) {}
    }

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: ColorPallete.redPrimary,
              onPrimary: ColorPallete.textPrimary,
              surface: ColorPallete.backgroundSecondary,
              onSurface: ColorPallete.textPrimary,
            ),
            dialogBackgroundColor: ColorPallete.backgroundPrimary,
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final hourStr = picked.hour.toString().padLeft(2, '0');
      final minuteStr = picked.minute.toString().padLeft(2, '0');
      setState(() {
        controller.text = '$hourStr:$minuteStr';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SettingsBloc>()..add(LoadAttendancePolicyEvent()),
      child: BlocConsumer<SettingsBloc, SettingsState>(
        listener: (context, state) {
          if (state is AttendancePolicyLoaded) {
            _existingId = state.policy.id;
            _checkInController.text = state.policy.checkInTime;
            _checkOutController.text = state.policy.checkOutTime;
            _gracePeriodController.text = state.policy.gracePeriodMins.toString();
          } else if (state is SettingsActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: ColorPallete.success,
              ),
            );
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
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Attendance Policy',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: ColorPallete.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Configure shifts, standard hours, and grace limits for automated attendance processing.',
                      style: TextStyle(
                        fontSize: 14,
                        color: ColorPallete.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: ColorPallete.backgroundSecondary,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: ColorPallete.divider),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Shift Start Time (Check-In)',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: ColorPallete.textSecondary,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    TextFormField(
                                      controller: _checkInController,
                                      readOnly: true,
                                      onTap: () => _selectTime(context, _checkInController),
                                      style: const TextStyle(color: ColorPallete.textPrimary),
                                      decoration: InputDecoration(
                                        fillColor: ColorPallete.backgroundPrimary,
                                        filled: true,
                                        suffixIcon: const Icon(Icons.access_time, color: ColorPallete.textSecondary),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                          borderSide: const BorderSide(color: ColorPallete.divider),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                          borderSide: const BorderSide(color: ColorPallete.redPrimary),
                                        ),
                                      ),
                                      validator: (v) => v!.isEmpty ? 'Check-in time required' : null,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Shift End Time (Check-Out)',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: ColorPallete.textSecondary,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    TextFormField(
                                      controller: _checkOutController,
                                      readOnly: true,
                                      onTap: () => _selectTime(context, _checkOutController),
                                      style: const TextStyle(color: ColorPallete.textPrimary),
                                      decoration: InputDecoration(
                                        fillColor: ColorPallete.backgroundPrimary,
                                        filled: true,
                                        suffixIcon: const Icon(Icons.access_time, color: ColorPallete.textSecondary),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                          borderSide: const BorderSide(color: ColorPallete.divider),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                          borderSide: const BorderSide(color: ColorPallete.redPrimary),
                                        ),
                                      ),
                                      validator: (v) => v!.isEmpty ? 'Check-out time required' : null,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Late Check-In Grace Period (Minutes)',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: ColorPallete.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _gracePeriodController,
                                keyboardType: TextInputType.number,
                                style: const TextStyle(color: ColorPallete.textPrimary),
                                decoration: InputDecoration(
                                  fillColor: ColorPallete.backgroundPrimary,
                                  filled: true,
                                  hintText: 'e.g. 15',
                                  hintStyle: const TextStyle(color: ColorPallete.textDisabled),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(color: ColorPallete.divider),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(color: ColorPallete.redPrimary),
                                  ),
                                ),
                                validator: (v) {
                                  if (v!.isEmpty) return 'Grace period required';
                                  if (int.tryParse(v) == null) return 'Must be a valid integer';
                                  return null;
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
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
                                      if (_formKey.currentState!.validate()) {
                                        final newPolicy = AttendancePolicyConfig(
                                          id: _existingId,
                                          checkInTime: _checkInController.text.trim(),
                                          checkOutTime: _checkOutController.text.trim(),
                                          gracePeriodMins: int.parse(_gracePeriodController.text.trim()),
                                        );
                                        context.read<SettingsBloc>().add(UpdateAttendancePolicyEvent(newPolicy));
                                      }
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
                                      'Save Policy',
                                      style: TextStyle(
                                        color: ColorPallete.textPrimary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
