import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hackathon/dependency_injection.g.dart';
import 'package:hackathon/features/attendence/domain/use_cases/attendence_params.dart';
import 'package:hackathon/features/attendence/presentation/blocs/bloc/attendence_bloc.dart';
import 'package:hackathon/features/dashboards/presentation/pages/dashboard.dart';
import 'package:hackathon/features/upload_files/domain/use_cases/upload_file_usecase.dart';
import 'package:hackathon/features/upload_files/presentation/bloc/upload_file_bloc.dart';
import 'package:hackathon/globals/constants/color_pallete.dart';
import 'package:hackathon/globals/constants/user.dart';
import 'package:hackathon/services/routes.dart';
import 'package:hackathon/widgets/custom_app_bar.dart';
import 'package:simple_web_camera/simple_web_camera.dart';

class CheckOutPage extends StatefulWidget {
  static const routePath = '/check-out';

  const CheckOutPage({super.key});

  @override
  State<CheckOutPage> createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  Uint8List? picture;

  @override
  Widget build(BuildContext context) {
    final swidth = MediaQuery.of(context).size.width;
    final sheight = MediaQuery.of(context).size.height;
    final AttendenceBloc attendanceService = getIt();
    final UploadFileBloc uploadFileService = getIt();
    return Scaffold(
      body: Container(
        height: sheight,
        decoration: const BoxDecoration(
          color: ColorPallete.backgroundPrimary,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              const CustomAppBar(
                children: [
                  Text(
                    "CHECK-OUT",
                    style: TextStyle(color: ColorPallete.textPrimary),
                  ),
                ],
              ),
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 20),
                  width: swidth / 1.5,
                  height: sheight / 1.5,
                  decoration: BoxDecoration(
                    image: picture != null
                        ? DecorationImage(image: MemoryImage(picture!))
                        : null,
                    color: ColorPallete.textSecondary.withOpacity(0.26),
                    border: Border.all(color: ColorPallete.textPrimary, width: 3),
                  ),
                  child: Center(
                    child: picture == null
                        ? const Text(
                            "Take a Clear Picture",
                            style: TextStyle(color: ColorPallete.textPrimary),
                          )
                        : null,
                  ),
                ),
              ),
              Container(
                  margin: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(color: ColorPallete.textPrimary, width: 2),
                  ),
                  child: picture == null
                      ? GestureDetector(
                          onTap: () async {
                            final res = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SimpleWebCameraPage(
                                    appBarTitle: "Take a Picture",
                                    centerTitle: true),
                              ),
                            );
                            if (res is String) {
                              setState(() {
                                picture = base64Decode(res);
                              });
                            }
                          },
                          child: const CircleAvatar(
                            radius: 40,
                            backgroundColor: Color.fromARGB(255, 92, 92, 92),
                            child: Icon(
                              Icons.camera_alt,
                              color: ColorPallete.textPrimary,
                              size: 40,
                            ),
                          ),
                        )
                      : null),
              if (picture != null)
                BlocConsumer(
                    bloc: uploadFileService,
                    listener: (context, state) {
                      if (state is UploadFileError) {
                        debugPrint(
                          state.error.toString(),
                        );
                      } else if (state is UploadFileSuccess) {
                        debugPrint(
                          state.fileId.toString(),
                        );
                      }
                    },
                    builder: (context, state) {
                      if (state is UploadFileLoading) {
                        return const CircularProgressIndicator();
                      } else if (state is UploadFileSuccess) {
                        return GestureDetector(
                          onTap: () {
                            DateTime dateTime = DateTime.now();

                            attendanceService.add(AttendenceCheckOutEvent(
                                params: AttendenceParams(
                                    dateTime: dateTime,
                                    userId: getIt<User>().user!.id,
                                    organisationId:
                                        getIt<User>().organisation!.id!,
                                    picture: state.fileId)));
                            context
                                .read<AttendenceBloc>()
                                .add(AttendenceGetEvent(
                                  userId: getIt<User>().user!.id,
                                ));

                            clearStackAndPush(context, Dashboard.routePath);
                          },
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: Container(
                              margin: const EdgeInsets.all(20),
                              child: CircleAvatar(
                                backgroundColor: ColorPallete.statusColor('approved'),
                                child: Icon(Icons.check),
                              ),
                            ),
                          ),
                        );
                      }

                      return GestureDetector(
                        onTap: () {
                          uploadFileService.add(UploadFileBlocEvent(
                              file: UploadFileParams(
                                  file: picture!,
                                  fileType: "image/jpeg",
                                  fileName:
                                      "attendence_picture_${getIt<User>().user!.id}_${DateTime.now()}",
                                  fileSize: picture!.length)));
                        },
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: Container(
                            margin: const EdgeInsets.all(20),
                            child: const CircleAvatar(
                              backgroundColor: ColorPallete.textSecondary,
                              child: Icon(
                                Icons.upload,
                                color: ColorPallete.textSecondary,
                              ),
                            ),
                          ),
                        ),
                      );
                    })
            ],
          ),
        ),
      ),
    );
  }
}
