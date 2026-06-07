import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hackathon/dependency_injection.g.dart';
import 'package:hackathon/features/auth/domain/usecase/auth_params.dart';
import 'package:hackathon/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:hackathon/features/company/presentation/pages/register_company_page.dart';
import 'package:hackathon/features/dashboards/presentation/pages/dashboard.dart';
import 'package:hackathon/features/upload_files/domain/use_cases/upload_file_usecase.dart';
import 'package:hackathon/features/upload_files/presentation/bloc/upload_file_bloc.dart';
import 'package:hackathon/globals/constants/assets.dart';
import 'package:hackathon/globals/constants/color_pallete.dart';
import 'package:hackathon/globals/constants/user.dart';
import 'package:hackathon/widgets/auth_button.dart';
import 'package:hackathon/widgets/auth_custom_text_form_field.dart';
import 'package:intl/intl.dart';
import 'dart:html';

class SignUpDialog extends StatefulWidget {
  const SignUpDialog({super.key});

  @override
  State<SignUpDialog> createState() => SignUpDialogState();
}

class SignUpDialogState extends State<SignUpDialog> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  Uint8List? uploadedImage;
  DateTime? pickedDate;
  int? fileId;

  @override
  Widget build(BuildContext context) {
    final swidth = MediaQuery.of(context).size.width;
    // final sheight = MediaQuery.of(context).size.height;
    return Material(
      shadowColor: ColorPallete.transparent,
      surfaceTintColor: ColorPallete.transparent,
      borderRadius: BorderRadius.circular(10),
      color: ColorPallete.transparent,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              constraints: BoxConstraints(
                maxWidth: swidth / 1.2,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              // margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  transform: GradientRotation(pi / 4),
                  colors: [ColorPallete.backgroundPrimary, ColorPallete.backgroundSecondary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              width: swidth / 1.2,
              child: Form(
                key: formKey,
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 20,
                  runSpacing: 20,
                  children: [
                    Center(
                      child: SelectableText(
                        "We are glad to have you onboard!",
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(overflow: TextOverflow.ellipsis),
                      ),
                    ),
                    _buildAvatar(context),
                    const Center(
                      child: Text("Upload Profile Picture"),
                    ),
                    AuthCustomTextFormField(
                      width: swidth / 5,
                      controller: firstNameController,
                      label: "First Name",
                      hintText: "Enter your first name",
                    ),
                    AuthCustomTextFormField(
                      width: swidth / 5,
                      controller: lastNameController,
                      label: "Last Name",
                      hintText: "Enter your last name",
                    ),
                    AuthCustomTextFormField(
                      width: swidth / 5,
                      controller: emailController,
                      label: "Email",
                      hintText: "Enter your email",
                    ),
                    AuthCustomTextFormField(
                      width: swidth / 5,
                      controller: phoneNumberController,
                      label: "Phone Number",
                      hintText: "Enter your phone number",
                    ),
                    AuthCustomTextFormField(
                      width: swidth / 5,
                      controller: passwordController,
                      label: "Password",
                      hintText: "Enter your password",
                      obscureText: _obscurePassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: ColorPallete.textPrimary,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    AuthCustomTextFormField(
                      width: swidth / 5,
                      controller: cityController,
                      label: "City",
                      hintText: "Enter your city",
                    ),
                    AuthCustomTextFormField(
                      width: swidth / 5,
                      controller: countryController,
                      label: "Country",
                      hintText: "Enter your country",
                    ),
                    SizedBox(
                      width: swidth / 5,
                      child: TextFormField(
                        controller: dateOfBirthController,
                        decoration: const InputDecoration(
                          labelText: "Date of Birth",
                          hintText: "mm/dd/yyyy",
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        readOnly: true,
                        onTap: () async {
                          pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );

                          if (pickedDate != null) {
                            dateOfBirthController.text =
                                DateFormat("dd/MM/yyyy").format(pickedDate!);
                            setState(() {});
                          }
                        },
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: BlocConsumer<AuthBloc, AuthState>(
                        listener: (context, state) {
                          if (state is AuthFailure) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(state.message)));
                          } else if (state is AuthSignUpSuccess) {
                            getIt<User>().user = state.auth.userEntity;
                            if (getIt<User>().employee != null &&
                                getIt<User>().organisation != null) {
                              context.go(Dashboard.routePath);
                            } else {
                              context.go(RegisterCompanyPage.routePath);
                            }
                          }
                        },
                        builder: (context, state) {
                          if (state is AuthLoading) {
                            return const SizedBox(
                                child: CircularProgressIndicator());
                          }
                          return AuthButton(
                            height: 50,
                            width: swidth / 10,
                            onpressed: () {
                              if (fileId != null &&
                                  formKey.currentState!.validate()) {
                                context.read<AuthBloc>().add(SignUpEvent(
                                    signUpParams: SignUpParams(
                                        firstName: firstNameController.text,
                                        lastName: lastNameController.text,
                                        email: emailController.text,
                                        phoneNumber: phoneNumberController.text,
                                        city: cityController.text,
                                        country: countryController.text,
                                        dateOfBirth: pickedDate!,
                                        profilePic: fileId!,
                                        hashedPassword:
                                            passwordController.text)));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text("We want to see your face")));
                              }
                            },
                            text: "Sign Up",
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Center _buildAvatar(BuildContext context) {
    return Center(
        child: GestureDetector(
      onTap: () async {
        FileUploadInputElement uploadInput = FileUploadInputElement();
        uploadInput.click();

        uploadInput.onChange.listen((e) {
          // read file content as dataURL
          final files = uploadInput.files;
          if (files != null && files.length == 1) {
            final file = files[0];
            FileReader reader = FileReader();

            reader.onLoadEnd.listen((e) {
              setState(() {
                uploadedImage = reader.result as Uint8List?;

                final params = UploadFileParams(
                    file: (reader.result as Uint8List),
                    fileType: file.type,
                    fileName: file.name,
                    fileSize: file.size);

                context
                    .read<UploadFileBloc>()
                    .add(UploadFileBlocEvent(file: params));
              });
            });

            reader.onError.listen((fileEvent) {
              setState(() {
                uploadedImage = null;
              });
            });

            reader.readAsArrayBuffer(file);
          }
        });
      },
      child: BlocConsumer<UploadFileBloc, UploadFileState>(
        listener: (context, state) {
          if (state is UploadFileError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error.message)));
          } else if (state is UploadFileSuccess) {
            fileId = state.fileId;
          }
        },
        builder: (context, state) {
          if (state is UploadFileLoading) {
            return const SizedBox(child: CircularProgressIndicator());
          }
          if (state is UploadFileError) {
            return const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(ImageAssets.profile),
            );
          }
          if (state is UploadFileSuccess || uploadedImage != null) {
            return CircleAvatar(
              radius: 50,
              backgroundImage: MemoryImage(uploadedImage!),
            );
          }
          return const CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage(ImageAssets.profile),
          );
        },
      ),
    ));
  }
}
