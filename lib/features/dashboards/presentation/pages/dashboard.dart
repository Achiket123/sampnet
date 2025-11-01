import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hackathon/dependency_injection.g.dart';
import 'package:hackathon/features/attendence/presentation/pages/check_in_page.dart';
import 'package:hackathon/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:hackathon/features/chats/data/data_sources/chat_data_source.dart';
import 'package:hackathon/features/chats/data/data_sources/signaling.dart';
import 'package:hackathon/features/chats/data/models/chat_model.dart';
import 'package:hackathon/features/chats/domain/entities/chat_entity.dart';
import 'package:hackathon/features/chats/domain/use_cases/chat_usecase.dart';
import 'package:hackathon/features/chats/presentation/blocs/chat_bloc/chat_bloc_bloc.dart';
import 'package:hackathon/features/dashboards/presentation/blocs/bloc/validate_employee_bloc.dart';
import 'package:hackathon/features/dashboards/presentation/widgets/side_bar_widget.dart';
import 'package:hackathon/features/landing/landing.dart';
import 'package:hackathon/features/tasks/presentation/widgets/task_horizontal_widget.dart';
import 'package:hackathon/features/team/presentation/pages/team_page.dart';
import 'package:hackathon/globals/constants/assets.dart';
import 'package:hackathon/globals/constants/color_pallete.dart';
import 'package:hackathon/globals/constants/styles.dart';
import 'package:hackathon/features/dashboards/presentation/widgets/app_bar.dart';
import 'package:hackathon/features/dashboards/presentation/widgets/custom_button.dart';
import 'package:hackathon/globals/constants/user.dart';
import 'package:hackathon/services/routes.dart';
import 'package:hackathon/features/tasks/presentation/blocs/task_bloc/task_bloc.dart';
import 'package:intl/intl.dart';

BuildContext? parentContext;

class Dashboard extends StatefulWidget {
  static const routePath = '/';
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  void initState() {
    super.initState();
    final chatParam = ChatParams(
      firstName: User.user.firstName,
      lastName: User.user.lastName,
      numberOfMessage: 0,
      email: User.user.email,
    );
    context.read<AuthBloc>().add(GetTokenEvent());

    context
        .read<ValidateEmployeeBloc>()
        .add(ValidateEmployee(token: User.token));
    context.read<TaskBloc>().add(FetchTasksEvent(token: User.token));
    context.read<ChatBlocBloc>().add(CreateChatEvent(params: chatParam));

    WebRTCSignaling.listenForCalling(context);
  }

  @override
  void didChangeDependencies() {
    parentContext = context;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final swidth = MediaQuery.of(context).size.width;
    final sheight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: BlocConsumer<ValidateEmployeeBloc, ValidateEmployeeState>(
        listener: (context, state) {
          if (state is ValidateEmployeeFailure) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error.message)));
            clearStackAndPush(context, LandingPage.routePath);
          }
        },
        builder: (context, state) {
          if (state is ValidateEmployeeLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(colors: ColorPallete.background)),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  DashAppBar(swidth: swidth),
                  Container(
                    margin: const EdgeInsets.only(
                      top: 10,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _sideBar(sheight, swidth),
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 40.0),
                            child: BlocBuilder<AuthBloc, AuthState>(
                              builder: (context, state) {
                                if (state is AuthLoading) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }
                                return Column(
                                  children: [
                                    _dashBoard(swidth, sheight),
                                    _dashboardHeading("TASKS"),
                                    BlocBuilder<TaskBloc, TaskState>(
                                      builder: (context, state) {
                                        if (state is TaskSuccess) {
                                          return SizedBox(
                                            height: 200,
                                            child: ListView.builder(
                                                itemCount: state.tasks.length,
                                                itemBuilder: (context, index) =>
                                                    TaskHorizontalWidget(
                                                        task: state
                                                            .tasks[index])),
                                          );
                                        } else if (state is TaskLoading) {
                                          return const Center(
                                            child: CircularProgressIndicator
                                                .adaptive(),
                                          );
                                        } else if (state is TaskError) {
                                          return const Text("Unable To Load");
                                        } else {
                                          return const Text("No Tasks");
                                        }
                                      },
                                    ),
                                    _dashboardHeading("CHATS"),
                                    StreamBuilder(
                                        stream:
                                            getIt<ChatDataSource>().getChats(),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const Center(
                                                child:
                                                    CircularProgressIndicator());
                                          }
                                          if (snapshot.hasError) {
                                            return const Center(
                                                child: Text("Error"));
                                          }
                                          if (snapshot.hasData) {
                                            final state = snapshot.data!;
                                            final List<ChatModel> chats = state
                                                .map<ChatModel>(
                                                    (e) => ChatModel.fromMap(e))
                                                .toList();
                                            return SizedBox(
                                              height: 500,
                                              child: ListView.builder(
                                                  itemCount: chats.length,
                                                  itemBuilder:
                                                      (context, index) =>
                                                          HorizontalChatWidget(
                                                            swidth: swidth,
                                                            chats: chats[index],
                                                          )),
                                            );
                                          }
                                          return const Center(
                                              child: Text("No Chats"));
                                        })
                                  ],
                                );
                              },
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

  Widget _dashBoard(double swidth, double sheight) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      constraints: const BoxConstraints(
        minHeight: 300,
        maxHeight: 300,
      ),
      // width: swidth / 1.2,
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: const LinearGradient(
              colors: ColorPallete.background,
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          organisationInfo(),
          Expanded(child: teamInfo()),
        ],
      ),
    );
  }

  Container _dashboardHeading(String text) {
    return Container(
      margin: const EdgeInsets.all(10),
      height: 60,
      padding: const EdgeInsets.all(15),
      decoration: const BoxDecoration(
          border: Border(
              bottom: BorderSide(color: ColorPallete.redPrimary, width: 5),
              left: BorderSide(color: ColorPallete.redPrimary, width: 5))),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            text,
            style: textTheme.headlineLarge!.copyWith(fontSize: 20),
          )
        ],
      ),
    );
  }

  Widget teamInfo() {
    return Wrap(
      spacing: 20,
      runAlignment: WrapAlignment.start,
      crossAxisAlignment: WrapCrossAlignment.start,
      runSpacing: 20,
      children: [
        dashBoardButton("Team Name"),
        dashBoardButton("Manager's Name"),
        dashBoardButton("UpComing Meetings"),
        dashBoardButton("Apply For Leave"),
      ],
    );
  }

  Widget organisationInfo() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
        child: OverflowBox(
          maxHeight: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SelectableText(
                "ORGANISATION'S NAME",
                maxLines: 1,
                style: textTheme.headlineMedium!.copyWith(
                    overflow: TextOverflow.fade,
                    fontSize: 20,
                    color: const Color.fromARGB(255, 254, 254, 254)),
              ),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is AuthFailure) {
                    return Text(state.message);
                  } else if (state is AuthLoading) {
                    return const CircularProgressIndicator();
                  } else if (state is AuthGetTokenSuccess) {
                    return SelectableText(
                      User.organisation.companyName,
                      maxLines: 1,
                      style: textTheme.headlineMedium!.copyWith(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
              SelectableText(
                "ORGANISATION'S OWNER",
                maxLines: 1,
                style: textTheme.headlineMedium!.copyWith(
                  fontSize: 20,
                  color: const Color.fromARGB(255, 255, 255, 255),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is AuthFailure) {
                    return Text(state.message);
                  } else if (state is AuthLoading) {
                    return const CircularProgressIndicator();
                  } else if (state is AuthGetTokenSuccess) {
                    return SelectableText(
                      User.organisation.primaryContactName,
                      maxLines: 1,
                      style: textTheme.headlineMedium!.copyWith(
                        fontSize: 40,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget dashBoardButton(String text) {
    return DashBoardTextFunctionButton(
        text: text,
        onTap: () {
          context.go(TeamPage.routePath);
        });
  }

  SideBarWidget _sideBar(double sheight, double swidth) {
    return SideBarWidget(sheight: sheight, swidth: swidth);
  }
}

class HorizontalChatWidget extends StatelessWidget {
  const HorizontalChatWidget({
    super.key,
    required this.chats,
    required this.swidth,
  });

  final double swidth;
  final ChatEntity chats;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorPallete.offWhite,
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
      child: ListTile(
        leading: CircleAvatar(
            radius: 30,
            backgroundColor: ColorPallete.blackSecondary,
            child: Image.asset(ImageAssets.chatProfile)),
        title: Text(chats.firstName,
            style: textTheme.headlineMedium!
                .copyWith(fontSize: 20, color: ColorPallete.blackSecondary)),
        subtitle: Text(chats.email!,
            style: textTheme.headlineMedium!
                .copyWith(fontSize: 15, color: ColorPallete.blackSecondary)),
        trailing: Container(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          width: swidth / 4,
          decoration: BoxDecoration(
              color: ColorPallete.blackSecondary,
              borderRadius: BorderRadius.circular(10)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                chats.lastMessage != null ? chats.lastMessage! : "No Message",
              ),
              Text(
                chats.lastMessageTimestamp != null
                    ? DateFormat("hh:mm a").format(chats.lastMessageTimestamp!)
                    : "No Message",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
