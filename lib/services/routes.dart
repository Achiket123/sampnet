import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hackathon/dependency_injection.g.dart';
import 'package:hackathon/features/attendence/presentation/pages/check_in_page.dart';
import 'package:hackathon/features/attendence/presentation/pages/check_out_page.dart';
import 'package:hackathon/features/auth/domain/usecase/auth_usecase.dart';
import 'package:hackathon/features/chats/data/models/chat_model.dart';
import 'package:hackathon/features/chats/presentation/pages/call_page.dart';
import 'package:hackathon/features/chats/presentation/pages/chat_page.dart';
import 'package:hackathon/features/company/presentation/pages/register_company_page.dart';
import 'package:hackathon/features/dashboards/data/models/emp_model.dart';
import 'package:hackathon/features/dashboards/presentation/pages/dashboard.dart';
import 'package:hackathon/features/landing/landing.dart';
import 'package:hackathon/features/tasks/presentation/pages/task_page.dart';
import 'package:hackathon/features/team/presentation/pages/team_page.dart';
import 'package:hackathon/globals/constants/strings.dart';
import 'package:hackathon/globals/constants/user.dart';
import 'package:hackathon/globals/models/organisation_model.dart';
import 'package:hackathon/globals/models/user_model.dart';
import 'package:hackathon/widgets/error_page.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:jwt_io/jwt_io.dart';

final GoRouter route = GoRouter(
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
        (context, state) => const ChatPage(),
      ),
    ),
    GoRoute(
      path: TeamPage.routePath,
      builder: safeBuilder(
        (context, state) => const TeamPage(),
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
            chatEntity: ChatModel.fromEntity(extra['chat']),
            isCalling: extra['isCalling'],
          );
        },
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
      getIt<User>().employee = EmpModel.fromJson(empPayload['employee']);
    } else {
      final employeeDataRaw = Hive.box(Strings.authBox).get(Strings.employeeKey);
      if (employeeDataRaw != null && getIt<User>().organisation != null) {
        final employeeData = Map<String, dynamic>.from(employeeDataRaw);
        getIt<User>().employee = EmpModel.fromJson(employeeData);
      } else {
        getIt<User>().employee = null;
      }
    }

    if (getIt<User>().employee != null && getIt<User>().organisation != null) {
      return Dashboard.routePath;
    }

    return RegisterCompanyPage.routePath;
  } catch (e, stack) {
    debugPrint("HANDLE TOKEN ERROR");
    debugPrint(e.toString());
    debugPrint(stack.toString());

    return LandingPage.routePath;
  }
}
