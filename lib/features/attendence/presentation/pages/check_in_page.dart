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

class CheckInPage extends StatefulWidget {
  static const routePath = '/checkin-page';

  const CheckInPage({super.key});

  @override
  State<CheckInPage> createState() => _CheckInPageState();
}

class _CheckInPageState extends State<CheckInPage> {
  Uint8List? picture;

  @override
  Widget build(BuildContext context) {
    final swidth = MediaQuery.of(context).size.width;
    final sheight = MediaQuery.of(context).size.height;
    final attendanceService = getIt<AttendenceBloc>();
    final uploadFileService = getIt<UploadFileBloc>();
    return Scaffold(
      body: Container(
        height: sheight,
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: ColorPallete.background),
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
                    "CHECK-IN",
                    style: TextStyle(color: ColorPallete.white),
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
                    color: Colors.black26,
                    border: Border.all(color: ColorPallete.white, width: 3),
                  ),
                  child: Center(
                    child: picture == null
                        ? const Text(
                            "Take a Clear Picture",
                            style: TextStyle(color: Colors.white),
                          )
                        : null,
                  ),
                ),
              ),
              Container(
                  margin: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(color: ColorPallete.white, width: 2),
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
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                        )
                      : null),
              if (picture != null)
                BlocConsumer(
                    bloc: uploadFileService,
                    listener: (context, state) {},
                    builder: (context, state) {
                      if (state is UploadFileLoading) {
                        return const CircularProgressIndicator();
                      } else if (state is UploadFileSuccess) {
                        return GestureDetector(
                          onTap: () {
                            DateTime dateTime = DateTime.now();
                            attendanceService.add(AttendenceCheckInEvent(
                                params: AttendenceParams(
                                    dateTime: dateTime,
                                    userId: User.user.id,
                                    organisationId: User.organisation.id!,
                                    picture: state.fileId)));
                            context
                                .read<AttendenceBloc>()
                                .add(AttendenceGetEvent(
                                  userId: User.user.id,
                                ));
                            clearStackAndPush(context, Dashboard.routePath);
                          },
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: Container(
                              margin: const EdgeInsets.all(20),
                              child: const CircleAvatar(
                                backgroundColor: Colors.green,
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
                                      "attendence_picture_${User.user.id}_${DateTime.now()}",
                                  fileSize: picture!.length)));
                        },
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: Container(
                            margin: const EdgeInsets.all(20),
                            child: const CircleAvatar(
                              backgroundColor: Colors.grey,
                              child: Icon(
                                Icons.upload,
                                color: Colors.black,
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
