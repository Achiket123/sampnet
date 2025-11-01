import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hackathon/features/attendence/presentation/pages/check_in_page.dart';
import 'package:hackathon/features/attendence/presentation/pages/check_out_page.dart';
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
import 'package:hive_flutter/adapters.dart';
import 'package:jwt_io/jwt_io.dart';

GoRouter route = GoRouter(initialLocation: initRoute(), routes: [
  GoRoute(
    path: LandingPage.routePath,
    builder: (context, state) => const LandingPage(),
  ),
  GoRoute(
    path: Dashboard.routePath,
    builder: (context, state) => const Dashboard(),
  ),
  GoRoute(
    path: CheckInPage.routePath,
    builder: (context, state) => const CheckInPage(),
  ),
  GoRoute(
    path: CheckOutPage.routePath,
    builder: (context, state) => const CheckOutPage(),
  ),
  GoRoute(
    path: RegisterCompanyPage.routePath,
    builder: (context, state) => const RegisterCompanyPage(),
  ),
  GoRoute(
    path: TaskPage.routePath,
    builder: (context, state) => const TaskPage(),
  ),
  GoRoute(
    path: ChatPage.routePath,
    builder: (context, state) => const ChatPage(),
  ),
  GoRoute(
      path: CallPage.routePath,
      builder: (context, state) {
        final Map data = state.extra as Map<String, dynamic>;
        return CallPage(
          chatEntity: ChatModel.fromEntity(data['chat']),
          isCalling: data['isCalling'],
        );
      }),
  GoRoute(
      path: TeamPage.routePath, builder: (context, state) => const TeamPage()),
]);

initRoute() {
  print("INIT ROUTE");
  try {
    final token = Hive.box(Strings.authBox).get(Strings.tokenKey);
    final Map<String, dynamic> organisation = Map<String, dynamic>.from(
        Hive.box(Strings.authBox).get(Strings.organisationKey));
    if (token == null || JwtToken.isExpired(token)) {
      debugPrint(
        token.toString(),
      );
      return LandingPage.routePath;
    } else {
      User.user = UserModel.fromJson(JwtToken.payload(token)['user']);
      debugPrint(
        organisation.toString(),
      );
      debugPrint(
        token,
      );
      Map<String, dynamic> organisationData = Map<String, dynamic>.from(
          Hive.box(Strings.authBox).get(Strings.organisationKey));
      debugPrint(
        organisationData.toString(),
      );
      User.organisation = Organisation.fromJson(organisationData);
      debugPrint("Kya ho raha h??");

      final empToken = Hive.box(Strings.authBox).get(Strings.employeeTokenKey);
      debugPrint(empToken.toString());
      User.employeeToken = empToken;
      User.token = token;
      final decodedToken = JwtToken.payload(token);
      debugPrint(
        decodedToken.toString(),
      );

      User.employee =
          EmpModel.fromJson(JwtToken.payload(User.employeeToken)['employee']);
      return RegisterCompanyPage.routePath;
    }
  } catch (e) {
    debugPrint(
      "ERROR",
    );
    debugPrint(
      e.toString(),
    );
    return LandingPage.routePath;
  }
}

clearStackAndPush(BuildContext context, String path) {
  while (context.canPop()) {
    context.pop();
  }
  context.push(path);
}
