import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hackathon/dependency_injection.g.dart';
import 'package:hackathon/features/attendence/presentation/pages/check_in_page.dart';
import 'package:hackathon/features/attendence/presentation/pages/check_out_page.dart';
import 'package:hackathon/features/auth/domain/usecase/auth_usecase.dart';
import 'package:hackathon/features/chats/data/models/chat_model.dart';
import 'package:hackathon/features/chats/domain/entities/chat_entity.dart';
import 'package:hackathon/features/chats/presentation/pages/call_page.dart';
import 'package:hackathon/features/chats/presentation/pages/chat_page.dart';
import 'package:hackathon/features/company/presentation/pages/register_company_page.dart';
import 'package:hackathon/features/dashboards/data/models/emp_model.dart';
import 'package:hackathon/features/dashboards/presentation/pages/dashboard.dart';
import 'package:hackathon/features/employees/presentation/pages/employees_list_page.dart';
import 'package:hackathon/features/employees/presentation/pages/employee_profile_page.dart';
import 'package:hackathon/features/landing/landing.dart';
import 'package:hackathon/features/leave/presentation/pages/leave_management_page.dart';
import 'package:hackathon/features/leave/presentation/pages/leave_request_page.dart';
import 'package:hackathon/features/notifications/presentation/pages/notification_preferences_page.dart';
import 'package:hackathon/features/tasks/presentation/pages/task_page.dart';
import 'package:hackathon/features/tasks/presentation/pages/task_detail_page.dart';
import 'package:hackathon/features/team/presentation/pages/team_page.dart';
import 'package:hackathon/features/projects/presentation/pages/projects_list_page.dart';
import 'package:hackathon/features/projects/presentation/pages/project_detail_page.dart';
import 'package:hackathon/globals/constants/strings.dart';
import 'package:hackathon/features/search/presentation/pages/global_search_page.dart';
import 'package:hackathon/features/resources/presentation/pages/resources_page.dart';
import 'package:hackathon/features/calendar/presentation/pages/personal_calendar_page.dart';
import 'package:hackathon/features/calendar/presentation/pages/team_calendar_page.dart';

// Research Module Imports
import 'package:hackathon/features/research/domain/entities/research_entry_entity.dart';
import 'package:hackathon/features/research/presentation/pages/research_list_page.dart';
import 'package:hackathon/features/research/presentation/pages/research_detail_page.dart';
import 'package:hackathon/features/research/presentation/pages/research_explorer_page.dart';
import 'package:hackathon/features/research/presentation/pages/markdown_editor_page.dart';
import 'package:hackathon/features/research/presentation/pages/create_edit_research_page.dart';
import 'package:hackathon/features/research/presentation/blocs/research_list_bloc/research_list_bloc.dart';
import 'package:hackathon/features/research/presentation/blocs/research_detail_bloc/research_detail_bloc.dart';
import 'package:hackathon/features/research/presentation/blocs/research_workspace_bloc/research_workspace_bloc.dart';
import 'package:hackathon/features/research/presentation/blocs/markdown_editor_bloc/markdown_editor_bloc.dart';
import 'package:hackathon/features/projects/presentation/blocs/project_bloc/project_bloc.dart';
import 'package:hackathon/features/projects/presentation/blocs/project_bloc/project_event.dart';
import 'package:hackathon/features/team/presentation/blocs/team_bloc/team_bloc.dart';
import 'package:hackathon/features/people/presentation/pages/people_list_page.dart';

import 'package:hackathon/globals/constants/user.dart';
import 'package:hackathon/globals/models/organisation_model.dart';
import 'package:hackathon/globals/models/user_model.dart';
import 'package:hackathon/widgets/error_page.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:jwt_io/jwt_io.dart';
import 'package:hackathon/services/websocket_service.dart';
import 'package:hackathon/services/incoming_call_overlay_service.dart';
import 'package:hackathon/services/webrtc_service.dart';
import 'package:hackathon/globals/constants/globals.dart';

final GoRouter route = GoRouter(
  navigatorKey: navigatorKey,
  initialLocation: initRoute(),
  redirect: (context, state) {
    return handleRouteGuard(state);
  },
  errorBuilder: (context, state) {
    debugPrint("GLOBAL ROUTING ERROR");
    debugPrint(state.error.toString());

    return ErrorPage(
      message: state.error.toString(),
    );
  },
  routes: [
    GoRoute(
      path: LandingPage.routePath,
      builder: safeBuilder(
        (context, state) => const LandingPage(),
      ),
    ),
    GoRoute(
      path: Dashboard.routePath,
      builder: safeBuilder(
        (context, state) => const Dashboard(),
      ),
    ),
    GoRoute(
      path: CheckInPage.routePath,
      builder: safeBuilder(
        (context, state) => const CheckInPage(),
      ),
    ),
    GoRoute(
      path: CheckOutPage.routePath,
      builder: safeBuilder(
        (context, state) => const CheckOutPage(),
      ),
    ),
    GoRoute(
      path: EmployeesListPage.routePath,
      builder: safeBuilder(
        (context, state) => const EmployeesListPage(),
      ),
    ),
    GoRoute(
      path: '${EmployeeProfilePage.routePath}/:employeeId',
      builder: safeBuilder(
        (context, state) {
          final id =
              int.tryParse(state.pathParameters['employeeId'] ?? '0') ?? 0;
          return EmployeeProfilePage(employeeId: id);
        },
      ),
    ),
    GoRoute(
      path: RegisterCompanyPage.routePath,
      builder: safeBuilder(
        (context, state) => const RegisterCompanyPage(),
      ),
    ),
    GoRoute(
      path: TaskPage.routePath,
      builder: safeBuilder(
        (context, state) => const TaskPage(),
      ),
    ),
    GoRoute(
      path: ChatPage.routePath,
      builder: safeBuilder(
        (context, state) {
          final extra = state.extra;
          ChatEntity? initialChat;
          if (extra is ChatEntity) {
            initialChat = extra;
          } else if (extra is Map<String, dynamic> &&
              extra.containsKey('chat')) {
            initialChat = extra['chat'] as ChatEntity?;
          }
          return ChatPage(initialChat: initialChat);
        },
      ),
    ),
    GoRoute(
      path: TeamPage.routePath,
      builder: safeBuilder(
        (context, state) => const TeamPage(),
      ),
    ),
    GoRoute(
      path: LeaveManagementPage.routePath,
      builder: safeBuilder(
        (context, state) => const LeaveManagementPage(),
      ),
    ),
    GoRoute(
      path: LeaveRequestPage.routePath,
      builder: safeBuilder(
        (context, state) => const LeaveRequestPage(),
      ),
    ),
    GoRoute(
      path: ProjectsListPage.routePath,
      builder: safeBuilder(
        (context, state) => const ProjectsListPage(),
      ),
    ),
    GoRoute(
      path: '${ProjectDetailPage.routePath}/:projectId',
      builder: safeBuilder(
        (context, state) {
          final id =
              int.tryParse(state.pathParameters['projectId'] ?? '0') ?? 0;
          return ProjectDetailPage(projectId: id);
        },
      ),
    ),
    GoRoute(
      path: NotificationPreferencesPage.routePath,
      builder: safeBuilder(
        (context, state) => const NotificationPreferencesPage(),
      ),
    ),
    GoRoute(
      path: CallPage.routePath,
      builder: safeBuilder(
        (context, state) {
          final extra = state.extra;

          if (extra == null) {
            return const ErrorPage(
              message: "Call route data is null",
            );
          }

          if (extra is! Map<String, dynamic>) {
            return const ErrorPage(
              message: "Invalid call route data",
            );
          }

          if (!extra.containsKey('chat')) {
            return const ErrorPage(
              message: "Missing chat object",
            );
          }

          if (!extra.containsKey('isCalling')) {
            return const ErrorPage(
              message: "Missing isCalling flag",
            );
          }

          return CallPage(
            chatEntity: extra['chat'] as ChatEntity,
            isCalling: extra['isCalling'],
          );
        },
      ),
    ),
    GoRoute(
      path: TaskDetailPage.routeName,
      builder: (context, state) {
        return TaskDetailPage(
            taskId:
                int.tryParse(state.pathParameters["taskId"].toString()) ?? 0);
      },
    ),
    GoRoute(
      path: ResourcesPage.routePath,
      builder: safeBuilder(
        (context, state) => const ResourcesPage(),
      ),
    ),
    GoRoute(
      path: GlobalSearchPage.routePath,
      builder: safeBuilder(
        (context, state) {
          final query = state.extra is String ? state.extra as String : '';
          return GlobalSearchPage(initialQuery: query);
        },
      ),
    ),
    GoRoute(
      path: PersonalCalendarPage.routePath,
      builder: safeBuilder(
        (context, state) => const PersonalCalendarPage(),
      ),
    ),
    GoRoute(
      path: TeamCalendarPage.routePath,
      builder: safeBuilder(
        (context, state) => const TeamCalendarPage(),
      ),
    ),
    GoRoute(
      path: ResearchListPage.routePath,
      builder: safeBuilder(
        (context, state) => MultiBlocProvider(
          providers: [
            BlocProvider(
                create: (context) => getIt<ResearchListBloc>()
                  ..add(const LoadResearchList(isRefresh: true))),
            BlocProvider(create: (context) => getIt<ResearchDetailBloc>()),
          ],
          child: const ResearchListPage(),
        ),
      ),
    ),
    GoRoute(
      path: '${ResearchDetailPage.routePath}/:researchId',
      builder: safeBuilder(
        (context, state) {
          final id =
              int.tryParse(state.pathParameters['researchId'] ?? '0') ?? 0;
          return BlocProvider(
            create: (context) =>
                getIt<ResearchDetailBloc>()..add(GetResearchDetail(id: id)),
            child: ResearchDetailPage(researchId: id),
          );
        },
      ),
    ),
    GoRoute(
      path: '${ResearchExplorerPage.routePath}/:researchId',
      builder: safeBuilder(
        (context, state) {
          final id =
              int.tryParse(state.pathParameters['researchId'] ?? '0') ?? 0;
          final extra = state.extra;
          ResearchEntryEntity? entry;
          if (extra is ResearchEntryEntity) {
            entry = extra;
          }
          return BlocProvider(
            create: (context) => getIt<ResearchWorkspaceBloc>(),
            child: ResearchExplorerPage(researchId: id, entry: entry),
          );
        },
      ),
    ),
    GoRoute(
      path: '${MarkdownEditorPage.routePath}/:documentId',
      builder: safeBuilder(
        (context, state) {
          final id =
              int.tryParse(state.pathParameters['documentId'] ?? '0') ?? 0;
          final extra = state.extra as Map<String, dynamic>?;
          return BlocProvider(
            create: (context) => getIt<MarkdownEditorBloc>(),
            child: MarkdownEditorPage(
              documentId: id,
              researchId: extra?['researchId'] ?? 0,
              folderId: extra?['folderId'],
              initialTitle: extra?['title'],
              initialContent: extra?['content'],
            ),
          );
        },
      ),
    ),
    GoRoute(
      path: CreateEditResearchPage.routePath,
      builder: safeBuilder(
        (context, state) {
          final extra = state.extra;
          ResearchEntryEntity? entry;
          if (extra is ResearchEntryEntity) {
            entry = extra;
          }
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                  create: (context) =>
                      getIt<ProjectsBloc>()..add(LoadProjectsEvent())),
              BlocProvider(
                  create: (context) =>
                      getIt<TeamBloc>()..add(GetTeamEvent(token: ''))),
              BlocProvider(create: (context) => getIt<ResearchDetailBloc>()),
            ],
            child: CreateEditResearchPage(entryToEdit: entry),
          );
        },
      ),
    ),
    GoRoute(
      path: PeopleListPage.routePath,
      builder: safeBuilder(
        (context, state) => const PeopleListPage(),
      ),
    ),
  ],
);

Widget Function(BuildContext, GoRouterState) safeBuilder(
  Widget Function(BuildContext, GoRouterState) builder,
) {
  return (context, state) {
    try {
      debugPrint("ROUTE OPENED");
      debugPrint(state.fullPath);

      return builder(context, state);
    } catch (e, stack) {
      debugPrint("SAFE BUILDER ERROR");
      debugPrint(e.toString());
      debugPrint(stack.toString());

      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go(ErrorPage.routePath);
      });

      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  };
}

String? handleRouteGuard(GoRouterState state) {
  try {
    debugPrint("ROUTE GUARD");
    debugPrint(state.fullPath);

    final response = getIt<GetTokenUsecase>().call(null);

    final path = response.fold<String>(
      (l) {
        getIt<WebsocketService>().disconnect();
        return LandingPage.routePath;
      },
      handleToken,
    );

    final currentPath = state.fullPath;

    final isAuthPage = currentPath == LandingPage.routePath;

    if (path != LandingPage.routePath && isAuthPage) {
      return path;
    }

    return null;
  } catch (e, stack) {
    debugPrint("ROUTE GUARD ERROR");
    debugPrint(e.toString());
    debugPrint(stack.toString());

    getIt<WebsocketService>().disconnect();
    return LandingPage.routePath;
  }
}

String initRoute() {
  debugPrint("INIT ROUTE");

  try {
    final response = getIt<GetTokenUsecase>().call(null);

    final path = response.fold<String>(
      (l) {
        debugPrint("ERROR ${l.message}");
        getIt<WebsocketService>().disconnect();
        return LandingPage.routePath;
      },
      handleToken,
    );

    debugPrint(path);

    return path;
  } catch (e, stack) {
    debugPrint("INIT ROUTE ERROR");
    debugPrint(e.toString());
    debugPrint(stack.toString());

    getIt<WebsocketService>().disconnect();
    return LandingPage.routePath;
  }
}

void clearStackAndPush(
  BuildContext context,
  String path,
) {
  while (context.canPop()) {
    context.pop();
  }

  context.push(path);
}

String handleToken(dynamic token) {
  try {
    debugPrint("HANDLING TOKEN");
    if (token == null || JwtToken.isExpired(token)) {
      debugPrint("TOKEN EXPIRED OR NULL");
      getIt<WebsocketService>().disconnect();
      return LandingPage.routePath;
    }

    final payload = JwtToken.payload(token);
    getIt<User>().user = UserModel.fromJson(payload['user']);
    getIt<User>().token = token;

    final organisationDataRaw =
        Hive.box(Strings.authBox).get(Strings.organisationKey);
    if (organisationDataRaw != null) {
      final organisationData = Map<String, dynamic>.from(organisationDataRaw);
      getIt<User>().organisation = Organisation.fromJson(organisationData);
    } else {
      getIt<User>().organisation = null;
    }

    final empToken = Hive.box(Strings.authBox).get(Strings.employeeTokenKey);
    getIt<User>().employeeToken = empToken;

    if (getIt<User>().employeeToken != null &&
        !JwtToken.isExpired(getIt<User>().employeeToken!)) {
      final empPayload = JwtToken.payload(getIt<User>().employeeToken!);
      Map<String, dynamic>? empJson;
      if (empPayload['employee'] != null) {
        empJson = Map<String, dynamic>.from(empPayload['employee']);
      } else if (empPayload['manager'] != null) {
        empJson = Map<String, dynamic>.from(empPayload['manager']);
      } else if (empPayload['boss'] != null) {
        empJson = Map<String, dynamic>.from(empPayload['boss']);
        empJson['type'] = 'boss';
        empJson['employment_id'] = 0;
        empJson['salary'] = '0';
      }
      if (empJson != null) {
        getIt<User>().employee = EmpModel.fromJson(empJson);
      } else {
        getIt<User>().employee = null;
      }
    } else {
      final employeeDataRaw =
          Hive.box(Strings.authBox).get(Strings.employeeKey);
      if (employeeDataRaw != null && getIt<User>().organisation != null) {
        final employeeData = Map<String, dynamic>.from(employeeDataRaw);
        if (employeeData['type'] == null) {
          if (employeeData.containsKey('salary')) {
            employeeData['type'] = 'manager'; // or default to manager/employee
          } else {
            employeeData['type'] = 'boss';
            employeeData['employment_id'] = 0;
            employeeData['salary'] = '0';
          }
        }
        getIt<User>().employee = EmpModel.fromJson(employeeData);
      } else {
        getIt<User>().employee = null;
      }
    }

    if (getIt<User>().employee != null && getIt<User>().organisation != null) {
      getIt<WebsocketService>().connect();
      getIt<IncomingCallOverlayService>(); // Initialize the service so it listens to call events
      getIt<WebRtcService>(); // Initialize so it listens and caches pending offers/candidates
      return Dashboard.routePath;
    }

    getIt<WebsocketService>().disconnect();
    return RegisterCompanyPage.routePath;
  } catch (e, stack) {
    debugPrint("HANDLE TOKEN ERROR");
    debugPrint(e.toString());
    debugPrint(stack.toString());

    getIt<WebsocketService>().disconnect();
    return LandingPage.routePath;
  }
}
