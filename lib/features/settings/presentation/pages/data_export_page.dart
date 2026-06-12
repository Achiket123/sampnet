import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hackathon/dependency_injection.g.dart';
import 'package:hackathon/globals/constants/color_pallete.dart';
import 'package:hackathon/features/settings/presentation/blocs/settings_bloc/settings_bloc.dart';
import 'package:hackathon/features/settings/presentation/blocs/settings_bloc/settings_event.dart';
import 'package:hackathon/features/settings/presentation/blocs/settings_bloc/settings_state.dart';

class DataExportPage extends StatefulWidget {
  const DataExportPage({super.key});

  @override
  State<DataExportPage> createState() => _DataExportPageState();
}

class _DataExportPageState extends State<DataExportPage> {
  String _selectedFormat = 'JSON';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SettingsBloc>(),
      child: BlocConsumer<SettingsBloc, SettingsState>(
        listener: (context, state) {
          if (state is SettingsActionSuccess) {
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Data Export',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: ColorPallete.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Export your organization\'s complete data records, including audit logs, employee directories, and leaves history.',
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
                        const Text(
                          'Export Format',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: ColorPallete.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _buildFormatRadio('JSON', 'Structured JSON backup data (Ideal for system imports).'),
                            const SizedBox(width: 16),
                            _buildFormatRadio('CSV', 'Comma-separated spreadsheet data (Ideal for Excel analysis).'),
                          ],
                        ),
                        const Divider(color: ColorPallete.divider, height: 40),
                        const Text(
                          'Included Data Tables',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: ColorPallete.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildDataRow(Icons.people_outline, 'Employee Records', 'Full active and inactive staff listings.'),
                        _buildDataRow(Icons.calendar_month_outlined, 'Attendance Sync Logs', 'Daily checkins, checkouts, and device records.'),
                        _buildDataRow(Icons.beach_access_outlined, 'Absence & Leaves History', 'Approved, pending, and rejected leave requests.'),
                        _buildDataRow(Icons.settings_outlined, 'Corporate Configurations', 'Permissions matrices, policies and settings histories.'),
                        const SizedBox(height: 30),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton.icon(
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
                                    context.read<SettingsBloc>().add(ExportOrgDataEvent());
                                  },
                            icon: isLoading
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(ColorPallete.textPrimary),
                                    ),
                                  )
                                : const Icon(Icons.download, color: ColorPallete.textPrimary, size: 18),
                            label: Text(
                              isLoading ? 'Processing Export...' : 'Request Download',
                              style: const TextStyle(
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
          );
        },
      ),
    );
  }

  Widget _buildFormatRadio(String format, String subtitle) {
    final bool isSelected = _selectedFormat == format;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedFormat = format;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected ? ColorPallete.redSubtle : ColorPallete.backgroundPrimary,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? ColorPallete.redPrimary : ColorPallete.divider,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    format,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: ColorPallete.textPrimary,
                    ),
                  ),
                  Icon(
                    isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                    color: isSelected ? ColorPallete.redPrimary : ColorPallete.textSecondary,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: ColorPallete.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDataRow(IconData icon, String title, String desc) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: ColorPallete.redPrimary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: ColorPallete.textPrimary),
                ),
                Text(
                  desc,
                  style: const TextStyle(fontSize: 12, color: ColorPallete.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
