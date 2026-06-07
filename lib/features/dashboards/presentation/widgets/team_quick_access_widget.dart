import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hackathon/dependency_injection.g.dart';
import 'package:hackathon/features/team/presentation/blocs/team_bloc/team_bloc.dart';
import 'package:hackathon/features/team/presentation/pages/team_page.dart';
import 'package:hackathon/features/team/presentation/pages/team_create_pop_up.dart';
import 'package:hackathon/globals/constants/color_pallete.dart';
import 'package:hackathon/globals/constants/user.dart';

class TeamQuickAccessWidget extends StatelessWidget {
  const TeamQuickAccessWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorPallete.backgroundSecondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Quick Access - Teams",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: ColorPallete.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline, color: ColorPallete.redPrimary, size: 20),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => Dialog(child: TeamCreatePopUp()),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 90,
            child: BlocBuilder<TeamBloc, TeamState>(
              builder: (context, state) {
                if (state is TeamLoadingState) {
                  return ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    separatorBuilder: (context, index) => const SizedBox(width: 16),
                    itemBuilder: (context, index) => _ShimmerCircle(),
                  );
                }

                if (state is TeamErrorState) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Error loading teams", style: TextStyle(fontSize: 10, color: ColorPallete.error)),
                        TextButton(
                          onPressed: () {
                            context.read<TeamBloc>().add(GetTeamEvent(token: getIt<User>().token!));
                          },
                          child: const Text("Retry", style: TextStyle(fontSize: 10)),
                        ),
                      ],
                    ),
                  );
                }

                if (state is TeamSuccessState) {
                  if (state.teams.isEmpty) {
                    return const Center(
                      child: Text("No teams yet", style: TextStyle(color: ColorPallete.textSecondary, fontSize: 12)),
                    );
                  }

                  final teams = state.teams.take(6).toList();

                  return ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: teams.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 16),
                    itemBuilder: (context, index) {
                      final team = teams[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const TeamPage()));
                        },
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: ColorPallete.redPrimary.withOpacity(0.3),
                              child: Text(
                                team.name.isNotEmpty ? team.name[0].toUpperCase() : "?",
                                style: const TextStyle(color: ColorPallete.textPrimary, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              team.name.length > 10 ? "${team.name.substring(0, 7)}..." : team.name,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: ColorPallete.textPrimary,
                                    fontSize: 10,
                                  ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }

                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ShimmerCircle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: ColorPallete.textPrimary.withOpacity(0.05),
        ),
        const SizedBox(height: 4),
        Container(
          width: 40,
          height: 8,
          decoration: BoxDecoration(
            color: ColorPallete.textPrimary.withOpacity(0.05),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }
}
