import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:html' as html;
import 'dart:typed_data';
import 'package:hackathon/dependency_injection.g.dart';
import 'package:hackathon/globals/constants/color_pallete.dart';
import 'package:hackathon/globals/constants/api_end_points.dart';
import 'package:hackathon/features/upload_files/presentation/bloc/upload_file_bloc.dart';
import 'package:hackathon/features/upload_files/domain/use_cases/upload_file_usecase.dart';
import 'package:hackathon/features/settings/presentation/blocs/profile_settings_bloc/profile_settings_bloc.dart';
import 'package:hackathon/features/settings/presentation/blocs/profile_settings_bloc/profile_settings_event.dart';
import 'package:hackathon/features/settings/presentation/blocs/profile_settings_bloc/profile_settings_state.dart';

class ProfileSettingsPage extends StatefulWidget {
  const ProfileSettingsPage({super.key});

  @override
  State<ProfileSettingsPage> createState() => _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends State<ProfileSettingsPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  String? _profilePicId;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<ProfileSettingsBloc>()..add(LoadProfileSettingsEvent()),
        ),
        BlocProvider(
          create: (context) => getIt<UploadFileBloc>(),
        ),
      ],
      child: BlocConsumer<ProfileSettingsBloc, ProfileSettingsState>(
        listener: (context, state) {
          if (state is ProfileLoaded) {
            _firstNameController.text = state.firstName;
            _lastNameController.text = state.lastName;
            _phoneController.text = state.phoneNumber;
            _emailController.text = state.email;
            _profilePicId = state.profilePic;
          } else if (state is ProfileActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: ColorPallete.success,
              ),
            );
          } else if (state is ProfileSettingsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: ColorPallete.error,
              ),
            );
          }
        },
        builder: (context, state) {
          final bool isLoading = state is ProfileSettingsLoading;

          return BlocListener<UploadFileBloc, UploadFileState>(
            listener: (context, uploadState) {
              if (uploadState is UploadFileSuccess) {
                setState(() {
                  _profilePicId = uploadState.url;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Profile picture uploaded successfully! Save changes to apply.'),
                    backgroundColor: ColorPallete.success,
                  ),
                );
              } else if (uploadState is UploadFileError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Failed to upload profile picture: ${uploadState.error.message}'),
                    backgroundColor: ColorPallete.error,
                  ),
                );
              }
            },
            child: Scaffold(
              backgroundColor: ColorPallete.backgroundPrimary,
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Profile Information',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: ColorPallete.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Update your personal profile details and contact details.',
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
                            BlocBuilder<UploadFileBloc, UploadFileState>(
                              builder: (context, uploadState) {
                                final isUploading = uploadState is UploadFileLoading;
                                return Center(
                                  child: Stack(
                                    children: [
                                      CircleAvatar(
                                        radius: 50,
                                        backgroundColor: ColorPallete.backgroundTertiary,
                                        backgroundImage: (_profilePicId != null && _profilePicId!.isNotEmpty)
                                            ? NetworkImage(_profilePicId!.startsWith('http')
                                                ? _profilePicId!
                                                : ApiConstants.getFileById(_profilePicId!))
                                            : null,
                                        child: (_profilePicId == null || _profilePicId!.isEmpty)
                                            ? const Icon(Icons.person, size: 50, color: ColorPallete.textSecondary)
                                            : null,
                                      ),
                                      if (isUploading)
                                        Positioned.fill(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.black.withOpacity(0.5),
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Center(
                                              child: CircularProgressIndicator(),
                                            ),
                                          ),
                                        ),
                                      if (!isUploading)
                                        Positioned(
                                          bottom: 0,
                                          right: 0,
                                          child: InkWell(
                                            onTap: () {
                                              html.FileUploadInputElement uploadInput =
                                                  html.FileUploadInputElement();
                                              uploadInput.accept = 'image/*';
                                              uploadInput.click();

                                              uploadInput.onChange.listen((e) {
                                                final files = uploadInput.files;
                                                if (files != null && files.length == 1) {
                                                  final file = files[0];
                                                  html.FileReader reader = html.FileReader();

                                                  reader.onLoadEnd.listen((e) {
                                                    if (!mounted) return;
                                                    final params = UploadFileParams(
                                                      file: (reader.result as Uint8List),
                                                      fileType: file.type,
                                                      fileName: file.name,
                                                      fileSize: file.size,
                                                    );

                                                    context
                                                        .read<UploadFileBloc>()
                                                        .add(UploadFileBlocEvent(file: params));
                                                  });

                                                  reader.readAsArrayBuffer(file);
                                                }
                                              });
                                            },
                                            child: const CircleAvatar(
                                              radius: 16,
                                              backgroundColor: ColorPallete.redPrimary,
                                              child: Icon(Icons.camera_alt, size: 14, color: ColorPallete.textPrimary),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 24),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildTextField(
                                    label: 'First Name',
                                    controller: _firstNameController,
                                    validator: (v) => v!.isEmpty ? 'First name required' : null,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _buildTextField(
                                    label: 'Last Name',
                                    controller: _lastNameController,
                                    validator: (v) => v!.isEmpty ? 'Last name required' : null,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            _buildTextField(
                              label: 'Email Address',
                              controller: _emailController,
                              readOnly: true,
                            ),
                            const SizedBox(height: 20),
                            _buildTextField(
                              label: 'Phone Number',
                              controller: _phoneController,
                              validator: (v) => v!.isEmpty ? 'Phone number required' : null,
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
                                          context.read<ProfileSettingsBloc>().add(
                                                UpdateProfileSettingsEvent(
                                                  firstName: _firstNameController.text.trim(),
                                                  lastName: _lastNameController.text.trim(),
                                                  phoneNumber: _phoneController.text.trim(),
                                                  profilePicFileId: _profilePicId,
                                                ),
                                              );
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
