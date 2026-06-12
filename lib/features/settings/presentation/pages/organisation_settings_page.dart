import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hackathon/dependency_injection.g.dart';
import 'package:hackathon/globals/constants/color_pallete.dart';
import 'package:hackathon/features/settings/domain/entities/org_settings_entity.dart';
import 'package:hackathon/features/settings/presentation/blocs/settings_bloc/settings_bloc.dart';
import 'package:hackathon/features/settings/presentation/blocs/settings_bloc/settings_event.dart';
import 'package:hackathon/features/settings/presentation/blocs/settings_bloc/settings_state.dart';

class OrganisationSettingsPage extends StatefulWidget {
  const OrganisationSettingsPage({super.key});

  @override
  State<OrganisationSettingsPage> createState() => _OrganisationSettingsPageState();
}

class _OrganisationSettingsPageState extends State<OrganisationSettingsPage> {
  final _formKey = GlobalKey<FormState>();
  
  final _companyNameController = TextEditingController();
  final _companyCodeController = TextEditingController();
  final _contactNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _officeAddressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _countryController = TextEditingController();
  final _industryController = TextEditingController();
  final _billingAddressController = TextEditingController();
  final _companySizeController = TextEditingController();
  
  int? _existingId;
  int? _existingLogo;

  @override
  void dispose() {
    _companyNameController.dispose();
    _companyCodeController.dispose();
    _contactNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _officeAddressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _postalCodeController.dispose();
    _countryController.dispose();
    _industryController.dispose();
    _billingAddressController.dispose();
    _companySizeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SettingsBloc>()..add(LoadOrgSettingsEvent()),
      child: BlocConsumer<SettingsBloc, SettingsState>(
        listener: (context, state) {
          if (state is OrgSettingsLoaded) {
            final settings = state.settings;
            _existingId = settings.id;
            _existingLogo = settings.companyLogo;
            _companyNameController.text = settings.companyName;
            _companyCodeController.text = settings.companyCode;
            _contactNameController.text = settings.primaryContactName;
            _emailController.text = settings.primaryEmail;
            _phoneController.text = settings.phoneNumber;
            _officeAddressController.text = settings.officeAddress;
            _cityController.text = settings.city;
            _stateController.text = settings.state;
            _postalCodeController.text = settings.postalCode;
            _countryController.text = settings.country;
            _industryController.text = settings.industry;
            _billingAddressController.text = settings.billingAddress;
            _companySizeController.text = settings.companySize;
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
                      'Organisation Settings',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: ColorPallete.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Manage the global settings and corporate profile information for your company.',
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
                                child: _buildTextField(
                                  label: 'Company Name',
                                  controller: _companyNameController,
                                  validator: (v) => v!.isEmpty ? 'Company name required' : null,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildTextField(
                                  label: 'Company Unique Code',
                                  controller: _companyCodeController,
                                  readOnly: true,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: _buildTextField(
                                  label: 'Primary Contact Name',
                                  controller: _contactNameController,
                                  validator: (v) => v!.isEmpty ? 'Contact name required' : null,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildTextField(
                                  label: 'Primary Email',
                                  controller: _emailController,
                                  validator: (v) => v!.isEmpty ? 'Primary email required' : null,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: _buildTextField(
                                  label: 'Phone Number',
                                  controller: _phoneController,
                                  validator: (v) => v!.isEmpty ? 'Phone number required' : null,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildTextField(
                                  label: 'Industry',
                                  controller: _industryController,
                                  validator: (v) => v!.isEmpty ? 'Industry required' : null,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: _buildTextField(
                                  label: 'Company Size',
                                  controller: _companySizeController,
                                  validator: (v) => v!.isEmpty ? 'Company size required' : null,
                                ),
                              ),
                              const SizedBox(width: 16),
                              const Expanded(child: SizedBox()),
                            ],
                          ),
                          const SizedBox(height: 20),
                          _buildTextField(
                            label: 'Office Address',
                            controller: _officeAddressController,
                            validator: (v) => v!.isEmpty ? 'Office address required' : null,
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: _buildTextField(
                                  label: 'City',
                                  controller: _cityController,
                                  validator: (v) => v!.isEmpty ? 'City required' : null,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildTextField(
                                  label: 'State / Region',
                                  controller: _stateController,
                                  validator: (v) => v!.isEmpty ? 'State required' : null,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: _buildTextField(
                                  label: 'Postal Code',
                                  controller: _postalCodeController,
                                  validator: (v) => v!.isEmpty ? 'Postal code required' : null,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildTextField(
                                  label: 'Country',
                                  controller: _countryController,
                                  validator: (v) => v!.isEmpty ? 'Country required' : null,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          _buildTextField(
                            label: 'Billing Address',
                            controller: _billingAddressController,
                            validator: (v) => v!.isEmpty ? 'Billing address required' : null,
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
                                        final newSettings = OrgSettings(
                                          id: _existingId,
                                          companyName: _companyNameController.text.trim(),
                                          companyCode: _companyCodeController.text.trim(),
                                          primaryContactName: _contactNameController.text.trim(),
                                          primaryEmail: _emailController.text.trim(),
                                          phoneNumber: _phoneController.text.trim(),
                                          officeAddress: _officeAddressController.text.trim(),
                                          city: _cityController.text.trim(),
                                          state: _stateController.text.trim(),
                                          postalCode: _postalCodeController.text.trim(),
                                          country: _countryController.text.trim(),
                                          companyLogo: _existingLogo,
                                          industry: _industryController.text.trim(),
                                          billingAddress: _billingAddressController.text.trim(),
                                          companySize: _companySizeController.text.trim(),
                                        );
                                        context.read<SettingsBloc>().add(UpdateOrgSettingsEvent(newSettings));
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
                                      'Save Changes',
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

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    bool readOnly = false,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: ColorPallete.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          readOnly: readOnly,
          validator: validator,
          style: TextStyle(
            color: readOnly ? ColorPallete.textSecondary : ColorPallete.textPrimary,
            fontSize: 15,
          ),
          decoration: InputDecoration(
            fillColor: readOnly ? ColorPallete.backgroundTertiary : ColorPallete.backgroundPrimary,
            filled: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: ColorPallete.divider),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: ColorPallete.redPrimary),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: ColorPallete.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: ColorPallete.error),
            ),
          ),
        ),
      ],
    );
  }
}
