import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hackathon/features/company/presentation/blocs/register%20comapny%20bloc/register_company_bloc.dart';
import 'package:hackathon/features/dashboards/presentation/pages/dashboard.dart';
import 'package:hackathon/features/upload_files/domain/use_cases/upload_file_usecase.dart';
import 'package:hackathon/features/upload_files/presentation/bloc/upload_file_bloc.dart';
import 'package:hackathon/globals/constants/assets.dart';
import 'package:hackathon/globals/constants/color_pallete.dart';
import 'package:hackathon/globals/constants/user.dart';
import 'package:hackathon/widgets/auth_button.dart';
import 'dart:typed_data';
import 'dart:html';

import 'package:hackathon/widgets/auth_custom_text_form_field.dart';

class RegisterCompanyPage extends StatefulWidget {
  const RegisterCompanyPage({super.key});
  static const routePath = '/register-company-page';
  @override
  State<RegisterCompanyPage> createState() => _RegisterCompanyPageState();
}

class _RegisterCompanyPageState extends State<RegisterCompanyPage> {
  Uint8List? uploadedImage;
  int? fileId;
  @override
  void initState() {
    super.initState();
    context
        .read<RegisterCompanyBloc>()
        .add(FetchEmployeeData(User.user.id.toString()));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(ImageAssets.background),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: BlocConsumer<RegisterCompanyBloc, RegisterCompanyState>(
              listener: (context, state) {
                if (state is FetchEmployeeDataSuccess) {
                  context.go(Dashboard.routePath);
                }
                if (state is FetchEmployeeDataFailure) {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            content: SizedBox(
                              width: 300,
                              height: 250,
                              child: Column(
                                children: [
                                  const Text(
                                      "WE ARE UNABLE TO FETCH YOUR DATA"),
                                  const Text(
                                      "THIS MEANS THAT YOUR DATA IS NOT YET ENTERED INTO THE SYSTEM BY YOUR ADMIN"),
                                  const Text("--or--"),
                                  const Text(
                                      "You are here to register your company!!!"),
                                  const Spacer(),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: AuthButton(
                                      height: 50,
                                      width: 100,
                                      text: "CLOSE",
                                      onpressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ));
                }
              },
              builder: (context, state) {
                if (state is FetchEmployeeDataFailure) {
                  return SingleChildScrollView(
                    child: _registerOrganisation(context),
                  );
                }

                if (state is RegisterCompanyLoading) {
                  return const Center(
                      child: CircularProgressIndicator(
                    color: ColorPallete.redPrimary,
                  ));
                }
                return const Center(child: Text("Something went wrong"));
              },
            ),
          )),
    );
  }

  Container _registerOrganisation(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.white.withOpacity(1),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.6),
            blurStyle: BlurStyle.solid,
            blurRadius: 20,
            spreadRadius: 2,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.6),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.2),
            Colors.white.withOpacity(0.1),
          ],
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _companyLogo(context),
          const SizedBox(height: 40),
          Text("Register Your Company",
              style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 20),
          Form(
            child: Wrap(
              spacing: 20,
              runSpacing: 20,
              alignment: WrapAlignment.center,
              children: [
                const SizedBox(
                  width: 300,
                  child: AuthCustomTextFormField(
                    style: TextStyle(color: ColorPallete.white),
                    label: "Company Name",
                  ),
                ),
                const SizedBox(
                  width: 300,
                  child: AuthCustomTextFormField(
                    label: "Company Code",
                  ),
                ),
                const SizedBox(
                  width: 300,
                  child: AuthCustomTextFormField(
                    label: "Primary Contact Name",
                  ),
                ),
                const SizedBox(
                  width: 300,
                  child: AuthCustomTextFormField(
                    label: "Primary Email",
                  ),
                ),
                const SizedBox(
                  width: 300,
                  child: AuthCustomTextFormField(
                    label: "Phone Number",
                  ),
                ),
                const SizedBox(
                  width: 300,
                  child: AuthCustomTextFormField(
                    label: "Office Address",
                  ),
                ),
                const SizedBox(
                  width: 300,
                  child: AuthCustomTextFormField(
                    label: "City",
                  ),
                ),
                const SizedBox(
                  width: 300,
                  child: AuthCustomTextFormField(
                    label: "State",
                  ),
                ),
                const SizedBox(
                  width: 300,
                  child: AuthCustomTextFormField(
                    label: "Postal Code",
                  ),
                ),
                const SizedBox(
                  width: 300,
                  child: AuthCustomTextFormField(
                    label: "Country",
                  ),
                ),
                const SizedBox(
                  width: 300,
                  child: AuthCustomTextFormField(
                    label: "Industry",
                  ),
                ),
                const SizedBox(
                  width: 300,
                  child: AuthCustomTextFormField(
                    label: "Billing Address",
                  ),
                ),
                const SizedBox(
                  width: 300,
                  child: AuthCustomTextFormField(
                    label: "Company Size",
                  ),
                ),
                const SizedBox(
                  width: 300,
                  child: AuthCustomTextFormField(
                    label: "Max Employees",
                  ),
                ),
                SizedBox(
                  width: 300,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorPallete.redPrimary,
                    ),
                    onPressed: () {
                      // Handle registration
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 15,
                      ),
                      child: Text("Register Company"),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Center _companyLogo(BuildContext context) {
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
