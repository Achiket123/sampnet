import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hackathon/dependency_injection.g.dart';
import 'package:hackathon/features/dashboards/presentation/blocs/bloc/validate_employee_bloc.dart';
import 'package:hackathon/features/dashboards/presentation/widgets/side_bar_widget.dart';
import 'package:hackathon/features/landing/landing.dart';
import 'package:hackathon/features/dashboards/presentation/widgets/app_bar.dart';
import 'package:hackathon/globals/constants/user.dart';
import 'package:hackathon/services/routes.dart';
import 'package:hackathon/features/dashboards/presentation/widgets/attendance_summary_widget.dart';
import 'package:hackathon/features/dashboards/presentation/widgets/getting_started_checklist_widget.dart';
import 'package:hackathon/features/dashboards/presentation/widgets/greeting_widget.dart';
import 'package:hackathon/features/dashboards/presentation/widgets/my_tasks_summary_widget.dart';
import 'package:hackathon/features/dashboards/presentation/widgets/recent_chats_widget.dart';
import 'package:hackathon/features/dashboards/presentation/widgets/team_quick_access_widget.dart';
import 'package:hackathon/features/dashboards/presentation/widgets/today_schedule_widget.dart';
import 'package:hackathon/features/onboarding/presentation/blocs/onboarding_bloc/onboarding_bloc.dart';
import 'package:hackathon/features/onboarding/presentation/blocs/onboarding_bloc/onboarding_event.dart';
import 'package:hackathon/features/tasks/presentation/blocs/task_bloc/task_bloc.dart';
import 'package:hackathon/features/team/presentation/blocs/team_bloc/team_bloc.dart';
import 'package:hackathon/features/attendence/presentation/blocs/bloc/attendence_bloc.dart';
import 'package:hackathon/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:hackathon/features/chats/presentation/blocs/chat_bloc/chat_bloc_bloc.dart';
import 'package:hackathon/globals/constants/color_pallete.dart';

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
    final user = getIt<User>();
    final token = user.token!;
    final userId = user.user!.id;
    final orgId = user.organisation?.id;

    context.read<AuthBloc>().add(GetTokenEvent());
    context.read<ValidateEmployeeBloc>().add(ValidateEmployee(token: token));
    
    // Dashboard Data Fetching
    context.read<TaskBloc>().add(FetchTasksEvent(token: token));
    context.read<TeamBloc>().add(GetTeamEvent(token: token));
    context.read<AttendenceBloc>().add(AttendenceGetEvent(userId: userId));
    context.read<ChatBlocBloc>().add(GetChatsEvent());
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
    
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<OnboardingBloc>()
            ..add(LoadOnboardingProgress(getIt<User>().user!.id.toString())),
        ),
      ],
      child: Scaffold(
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
                  color: ColorPallete.backgroundPrimary),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    DashAppBar(swidth: swidth),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _sideBar(sheight, swidth),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(flex: 3, child: GreetingWidget()),
                                      const SizedBox(width: 20),
                                      Expanded(flex: 2, child: AttendanceSummaryWidget()),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(flex: 3, child: MyTasksSummaryWidget()),
                                      const SizedBox(width: 20),
                                      Expanded(flex: 2, child: TeamQuickAccessWidget()),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(flex: 3, child: RecentChatsWidget()),
                                      const SizedBox(width: 20),
                                      Expanded(flex: 2, child: GettingStartedChecklistWidget()),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(flex: 3, child: const TodayScheduleWidget()),
                                      const SizedBox(width: 20),
                                      Expanded(flex: 2, child: const SizedBox()),
                                    ],
                                  ),
                                ],
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
      ),
    );
  }

  SideBarWidget _sideBar(double sheight, double swidth) {
    return SideBarWidget(sheight: sheight, swidth: swidth);
  }
}
