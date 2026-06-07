import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hackathon/features/employees/presentation/blocs/add_employee_bloc/add_employee_bloc.dart';
import 'package:hackathon/features/employees/presentation/blocs/add_employee_bloc/add_employee_event.dart';
import 'package:hackathon/features/employees/presentation/blocs/add_employee_bloc/add_employee_state.dart';
import 'package:hackathon/features/employees/presentation/blocs/employees_list_bloc/employees_list_bloc.dart';
import 'package:hackathon/features/employees/presentation/blocs/employees_list_bloc/employees_list_event.dart';
import 'package:hackathon/globals/constants/user.dart';
import 'package:hackathon/dependency_injection.g.dart';
import 'package:hackathon/globals/constants/color_pallete.dart';

class AddEmployeeModal extends StatelessWidget {
  const AddEmployeeModal({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AddEmployeeBloc>(),
      child: Builder(
        builder: (modalContext) {
          return BlocListener<AddEmployeeBloc, AddEmployeeState>(
            listener: (listenerContext, state) {
              if (state.status == AddEmployeeStatus.submitted) {
                final orgId = getIt<User>().organisation?.id;
                if (orgId != null) {
                  modalContext.read<EmployeesListBloc>().add(EmployeesListLoadRequested(orgId));
                }
                Navigator.pop(modalContext);
              } else if (state.status == AddEmployeeStatus.error) {
                ScaffoldMessenger.of(modalContext).showSnackBar(
                  SnackBar(content: Text(state.failureMessage ?? 'Error adding employee')),
                );
              }
            },
            child: Container(
              padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(modalContext).viewInsets.bottom + 20),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 30, 30, 30),
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Add New Employee',
                        style: TextStyle(color: ColorPallete.textPrimary, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: ColorPallete.textSecondary),
                        onPressed: () {
                          modalContext.read<AddEmployeeBloc>().add(AddEmployeeFormReset());
                          Navigator.pop(modalContext);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildField(
                    modalContext,
                    label: 'First Name',
                    onChanged: (val) => modalContext.read<AddEmployeeBloc>().add(AddEmployeeFormFirstNameChanged(val)),
                    errorSelector: (state) => state.firstNameError,
                  ),
                  _buildField(
                    modalContext,
                    label: 'Last Name',
                    onChanged: (val) => modalContext.read<AddEmployeeBloc>().add(AddEmployeeFormLastNameChanged(val)),
                    errorSelector: (state) => state.lastNameError,
                  ),
                  _buildField(
                    modalContext,
                    label: 'Email',
                    onChanged: (val) => modalContext.read<AddEmployeeBloc>().add(AddEmployeeFormEmailChanged(val)),
                    errorSelector: (state) => state.emailError,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  _buildField(
                    modalContext,
                    label: 'Phone Number',
                    onChanged: (val) => modalContext.read<AddEmployeeBloc>().add(AddEmployeeFormPhoneChanged(val)),
                    errorSelector: (state) => state.phoneError,
                    keyboardType: TextInputType.phone,
                  ),
                  _buildField(
                    modalContext,
                    label: 'Employment ID',
                    onChanged: (val) => modalContext.read<AddEmployeeBloc>().add(AddEmployeeFormEmploymentIdChanged(val)),
                    errorSelector: (state) => state.employmentIdError,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 30),
                  BlocBuilder<AddEmployeeBloc, AddEmployeeState>(
                    builder: (builderContext, state) {
                      final isSubmitting = state.status == AddEmployeeStatus.submitting;
                      return SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: isSubmitting || !state.isFormValid
                              ? null
                              : () => modalContext.read<AddEmployeeBloc>().add(AddEmployeeSubmitRequested()),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorPallete.redPrimary,
                            foregroundColor: ColorPallete.textPrimary,
                            disabledBackgroundColor: ColorPallete.redPrimary.withValues(alpha: 0.3),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: isSubmitting
                              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: ColorPallete.textPrimary))
                              : const Text('Add Employee', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildField(
    BuildContext context, {
    required String label,
    required Function(String) onChanged,
    required String? Function(AddEmployeeState) errorSelector,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          onChanged: onChanged,
          keyboardType: keyboardType,
          style: const TextStyle(color: ColorPallete.textPrimary),
          decoration: InputDecoration(
            labelText: label,
          ),
        ),
        BlocBuilder<AddEmployeeBloc, AddEmployeeState>(
          buildWhen: (prev, curr) => errorSelector(prev) != errorSelector(curr),
          builder: (context, state) {
            final error = errorSelector(state);
            if (error == null) return const SizedBox(height: 16);
            return Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 8),
              child: Text(error, style: const TextStyle(color: ColorPallete.error, fontSize: 12)),
            );
          },
        ),
      ],
    );
  }
}
