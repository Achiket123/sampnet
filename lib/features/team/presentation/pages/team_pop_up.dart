import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hackathon/features/team/presentation/blocs/team_id_bloc/teamid_bloc.dart';
import 'package:hackathon/features/team/presentation/widgets/user_team_widget.dart';
import 'package:hackathon/globals/constants/color_pallete.dart';
import 'package:hackathon/globals/models/team_model.dart';
import 'package:hackathon/widgets/task_button.dart';
import 'package:intl/intl.dart';

class TeamPopUp extends StatelessWidget {
  const TeamPopUp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return BlocBuilder<TeamidBloc, TeamidState>(
      builder: (context, state) {
        if (state is TeamLoadingState) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }
        if (state is TeamSuccessState) {
          return Container(
            constraints: BoxConstraints(
              maxHeight: screenHeight * 0.8,
              maxWidth: screenWidth * 0.8,
            ),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: ColorPallete.background),
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.all(20),
            alignment: Alignment.centerRight,
            child: Row(children: [
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Team Lead :  ${state.teamMemory.team.createdByUser.firstName}",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    if (state.teamMemory.team.createdAt != null)
                      Text(
                        "Created At: ${DateFormat.yMEd().format(state.teamMemory.team.createdAt!)}",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Projects : ",
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        // Container(
                        //   width: screenWidth * 0.3,
                        //   height: screenHeight * 0.3,
                        //   decoration: BoxDecoration(
                        //     border: Border.all(
                        //       color: ColorPallete.black,
                        //       width: 2,
                        //     ),
                        //     borderRadius: BorderRadius.circular(10),
                        //     color: ColorPallete.blackTertiary,
                        //   ),
                        //   child: ListView.builder(
                        //     itemCount:state.teamMemory. team.projects != null
                        //         ? state.teamMemory.team.projects!.length
                        //         : 0,
                        //     itemBuilder: (context, index) {
                        //       return Container(
                        //         decoration: BoxDecoration(
                        //           borderRadius: BorderRadius.circular(10),
                        //           color: const Color.fromARGB(255, 46, 46, 46),
                        //           border: Border.all(
                        //             color: const Color.fromARGB(
                        //                 255, 190, 190, 190),
                        //             width: 1,
                        //           ),
                        //         ),
                        //         margin: EdgeInsets.all(10),
                        //         child: Row(
                        //           children: [
                        //             Expanded(
                        //               child: ListTile(
                        //                 title: Text(
                        //                   state.teamMemory.team.projects![index].name,
                        //                   style: Theme.of(context)
                        //                       .textTheme
                        //                       .headlineSmall,
                        //                 ),
                        //               ),
                        //             ),
                        //             Icon(Icons.arrow_forward_ios),
                        //           ],
                        //         ),
                        //       );
                        //     },
                        //   ),
                        // ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(15),
                      margin: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: ColorPallete.blackSecondary),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Description",
                              style: Theme.of(context).textTheme.headlineSmall),
                          Text(
                            state.teamMemory.team.description ??
                                "No Description",
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ],
                      ),
                    ),
                    Container(),
                    const Spacer(),
                    TextButton(
                      onPressed: () {},
                      style: const ButtonStyle(
                          backgroundColor:
                              WidgetStatePropertyAll(ColorPallete.redPrimary)),
                      child: Text(
                        "Delete",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
              const Spacer(),
              Container(
                width: screenWidth * 0.3,
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: ColorPallete.blackTertiary,
                  border: Border.all(
                    color: ColorPallete.black,
                    width: 2,
                  ),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: ColorPallete.black,
                          border: Border.all(
                            color: ColorPallete.black,
                            width: 2,
                          ),
                        ),
                        child: ListView.builder(
                          itemCount: state.teamMemory.teamMember.length,
                          itemBuilder: (context, index) {
                            return UserTeamWidget(
                              userEntity: state.teamMemory.teamMember[index],
                            );
                          },
                        ),
                      ),
                    ),
                    ListTile(
                        title: Text(
                          "Members",
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        trailing: const Icon(Icons.edit)),
                  ],
                ),
              )
            ]),
          );
        } else if (state is TeamFailureState) {
          return Text(state.errorModel.message);
        } else {
          return const Text("Internal Error");
        }
      },
    );
  }
}
