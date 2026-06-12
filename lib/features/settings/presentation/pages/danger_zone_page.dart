import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hackathon/dependency_injection.g.dart';
import 'package:hackathon/globals/constants/color_pallete.dart';
import 'package:hackathon/globals/constants/user.dart';
import 'package:hackathon/features/settings/presentation/blocs/settings_bloc/settings_bloc.dart';
import 'package:hackathon/features/settings/presentation/blocs/settings_bloc/settings_event.dart';
import 'package:hackathon/features/settings/presentation/blocs/settings_bloc/settings_state.dart';

class DangerZonePage extends StatefulWidget {
  const DangerZonePage({super.key});

  @override
  State<DangerZonePage> createState() => _DangerZonePageState();
}

class _DangerZonePageState extends State<DangerZonePage> {
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
            // Optionally redirect to home or login after company deletion
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
                    'Danger Zone',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: ColorPallete.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Irreversible and destructive actions for organization and account managers.',
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
                      border: Border.all(color: ColorPallete.error.withOpacity(0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Delete Organisation',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: ColorPallete.error,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Once you delete an organisation, there is no going back. All employee records, chats, folders, documents, leaves, and analytics history will be permanently erased.',
                          style: TextStyle(
                            fontSize: 13,
                            color: ColorPallete.textSecondary,
                          ),
                        ),
                        const Divider(color: ColorPallete.divider, height: 40),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorPallete.error,
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: isLoading
                                ? null
                                : () => _showDeleteConfirmation(context),
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
                                    'Delete Organisation',
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
          );
        },
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext parentContext) {
    final companyCode = getIt<User>().organisation?.companyCode ?? '';
    final codeController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: parentContext,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: ColorPallete.backgroundPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: ColorPallete.divider),
        ),
        title: const Text(
          'Are you absolutely sure?',
          style: TextStyle(color: ColorPallete.error, fontWeight: FontWeight.bold),
        ),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'This action cannot be undone. Please type the company code to confirm deletion:',
                style: TextStyle(color: ColorPallete.textPrimary, fontSize: 13),
              ),
              const SizedBox(height: 12),
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: ColorPallete.backgroundSecondary,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    companyCode,
                    style: const TextStyle(
                      color: ColorPallete.textPrimary,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: codeController,
                style: const TextStyle(color: ColorPallete.textPrimary),
                decoration: InputDecoration(
                  fillColor: ColorPallete.backgroundSecondary,
                  filled: true,
                  hintText: 'Enter company code',
                  hintStyle: const TextStyle(color: ColorPallete.textDisabled),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: ColorPallete.divider),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: ColorPallete.error),
                  ),
                ),
                validator: (v) {
                  if (v != companyCode) {
                    return 'Code does not match';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel', style: TextStyle(color: ColorPallete.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorPallete.error,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              if (formKey.currentState!.validate()) {
                parentContext.read<SettingsBloc>().add(DeleteOrganisationEvent());
                Navigator.pop(dialogContext);
              }
            },
            child: const Text(
              'I understand, delete this company',
              style: TextStyle(color: ColorPallete.textPrimary, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
