import 'dart:math';
import 'dart:ui';

import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hackathon/dependency_injection.g.dart';
import 'package:hackathon/features/team/presentation/blocs/team_bloc/team_bloc.dart';
import 'package:hackathon/features/team/presentation/blocs/team_id_bloc/teamid_bloc.dart'
    as ti;
import 'package:hackathon/features/team/presentation/pages/team_create_pop_up.dart';
import 'package:hackathon/features/team/presentation/pages/team_pop_up.dart';
import 'package:hackathon/globals/constants/color_pallete.dart';
import 'package:hackathon/globals/constants/user.dart';
import 'package:hackathon/globals/models/team_model.dart';
import 'package:hackathon/widgets/custom_app_bar.dart';
import 'package:hackathon/widgets/custom_drawer.dart';
import 'package:hackathon/widgets/list_of_side_bar.dart';
import 'package:hackathon/widgets/task_button.dart';

class TeamPage extends StatefulWidget {
  const TeamPage({super.key});
  static const String routePath = '/team-page';
  @override
  State<TeamPage> createState() => _TeamPageState();
}

class _TeamPageState extends State<TeamPage> {
  final teamPageKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<TeamBloc>().add(GetTeamEvent(token: getIt<User>().employeeToken ?? getIt<User>().token!));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: teamPageKey,
      drawer: CustomDrawer(
        selectedIndex: ListOfSideBar.sideBarItems.indexOf('Teams'),
      ),
      body: Container(
        height: MediaQuery.sizeOf(context).height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [ColorPallete.backgroundPrimary, ColorPallete.backgroundSecondary],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              CustomAppBar(children: [
                Text(
                  "Team",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const Spacer(),
                IconButton(
                    icon: const Icon(
                      Icons.menu,
                      color: ColorPallete.textPrimary,
                    ),
                    onPressed: () {
                      teamPageKey.currentState!.openDrawer();
                    })
              ]),
              Container(
                padding: const EdgeInsets.all(20),
                alignment: Alignment.centerRight,
                child: CustomTextButton(
                  text: const Text("Add Team"),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) => Dialog(child: TeamCreatePopUp()));
                  },
                ),
              ),
              BlocConsumer<TeamBloc, TeamState>(
                listener: (context, state) {
                  debugPrint(state.toString());
                  if (state is TeamErrorState) {
                    debugPrint(state.error.message);
                    ElegantNotification.error(
                            description: Text(
                              state.error.message,
                              style: const TextStyle(color: ColorPallete.textSecondary),
                            ),
                            title: const Text("Error",
                                style: TextStyle(color: ColorPallete.textSecondary)))
                        .show(context);
                  }
                },
                builder: (context, state) {
                  if (state is TeamLoadingState) {
                    return CircularProgressIndicator();
                  }
                  if (state is TeamSuccessState) {
                    return Wrap(children: [
                      for (var i in state.teams) TeamContainer(team: i)
                    ]);
                  }
                  return const Text("ERROR");
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

class TeamContainer extends StatelessWidget {
  final Team team;
  const TeamContainer({
    super.key,
    required this.team,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.sizeOf(context).width * 0.2,
        maxHeight: MediaQuery.sizeOf(context).height * 0.4,
      ),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ColorPallete.backgroundTertiary,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: ColorPallete.textSecondary.withOpacity(0.5),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      margin: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              team.name,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(fontSize: 20),
            ),
            Align(
                alignment: Alignment.bottomRight,
                child: IconButton(
                    icon: const Icon(Icons.arrow_right),
                    onPressed: () {
                      // calling the function to get the team
                      context
                          .read<ti.TeamidBloc>()
                          .add(ti.GetTeamIdEvent(id: team.id.toString()));
                      showDialog(
                          context: context,
                          builder: (context) =>
                              const Dialog(child: TeamPopUp()));
                    }))
          ],
        ),
      ),
    );
  }
}
