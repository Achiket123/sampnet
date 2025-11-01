import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hackathon/dependency_injection.g.dart';
import 'package:hackathon/features/tasks/data/models/assignee_model.dart';
import 'package:hackathon/features/tasks/presentation/blocs/get_emp_bloc/get_employees_bloc.dart';
import 'package:hackathon/features/team/data/models/project_model.dart';
import 'package:hackathon/features/team/domain/entities/project_entity.dart';
import 'package:hackathon/features/team/domain/usecases/create_team_usecase.dart';
import 'package:hackathon/features/team/presentation/blocs/project_bloc/project_bloc.dart';
import 'package:hackathon/features/team/presentation/blocs/team_bloc/team_bloc.dart';
import 'package:hackathon/globals/constants/color_pallete.dart';
import 'package:hackathon/globals/constants/user.dart';
import 'package:hackathon/widgets/custom_app_bar.dart';

class TeamCreatePopUp extends StatefulWidget {
  const TeamCreatePopUp({super.key});

  @override
  State<TeamCreatePopUp> createState() => _TeamCreatePopUpState();
}

class _TeamCreatePopUpState extends State<TeamCreatePopUp> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _pageController = PageController();
  final getEmployeesBloc = getIt<GetEmployeesBloc>();
  final List<AssigneeModel> teamMembers = [];
  final GlobalKey _key = GlobalKey();
  AssigneeModel? teamLead;
  @override
  void initState() {
    super.initState();
    context.read<ProjectBloc>().add(GetProjectEvent(token: User.token));
    getEmployeesBloc.add(GetEmployees(token: User.token));
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    _pageController.dispose();
    getEmployeesBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    final taskStyle = Theme.of(context).textTheme.bodyMedium;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;
    return Container(
      key: _key,
      constraints: BoxConstraints(
        maxHeight: screenHeight * 0.56,
        maxWidth: screenWidth * 0.8,
        minWidth: screenWidth * 0.6,
      ),
      decoration: BoxDecoration(
        color: ColorPallete.blackTertiary,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(10),
      child: PageView.builder(
          controller: _pageController,
          itemCount: 3,
          itemBuilder: (context, index) => [
                teamCreatePage_1(screenHeight, taskStyle),
                teamCreatePage_2(screenHeight, screenWidth, taskStyle),
                teamCreatePage_3(screenHeight, screenWidth, taskStyle),
              ][index]),
    );
  }

  Widget teamCreatePage_1(double screenHeight, TextStyle? taskStyle) {
    /// This is the first page of the team creation process
    /// We will be able to create a team name and description
    /// and then move to the next page
    return SingleChildScrollView(
      child: Column(
        children: [
          CustomAppBar(
              callback: () {
                Navigator.pop(context);
              },
              children: [
                Center(
                  child: Text(
                    "Create Team",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                )
              ]),
          SizedBox(height: screenHeight * 0.02),
          TextFormField(
            controller: _nameController,
            style: taskStyle,
            decoration: _buildInputDecoration('Team Name'),
          ),
          SizedBox(height: screenHeight * 0.02),
          TextFormField(
            controller: _descriptionController,
            maxLines: 7,
            style: taskStyle,
            decoration: _buildInputDecoration('Team Description'),
          ),
          SizedBox(height: screenHeight * 0.02),
          ElevatedButton(
            onPressed: () {
              _pageController.nextPage(
                  duration: Durations.medium1, curve: Curves.bounceIn);
            },
            child: const Text("Next"),
          ),
        ],
      ),
    );
  }

  Widget teamCreatePage_2(
      double screenHeight, double screenWidth, TextStyle? taskStyle) {
    /// This is the second page of the team creation process
    /// We will be able to add team members and select a team lead
    ///   - We will be able to drag and drop team members to the team members list
    return SingleChildScrollView(
      child: Column(
        children: [
          CustomAppBar(
            callback: () {
              _pageController.previousPage(
                  duration: Durations.medium1, curve: Curves.bounceIn);
            },
            children: [
              Center(
                child: Text(
                  "Create Team",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              )
            ],
          ),
          SizedBox(height: screenHeight * 0.02),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                width: screenWidth * 0.25,
                height: screenHeight * 0.4,
                child: BlocConsumer<GetEmployeesBloc, GetEmployeesState>(
                  bloc: getEmployeesBloc,
                  builder: (context, state) {
                    if (state is GetEmployeesSuccess) {
                      return Container(
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: ColorPallete.blackTertiary,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: ColorPallete.white,
                              width: 2,
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: ColorPallete.black,
                                blurRadius: 10,
                              ),
                            ]),
                        child: ListView.builder(
                            itemCount: state.employees.length,
                            itemBuilder: (context, index) {
                              if (teamMembers
                                  .contains(state.employees[index])) {
                                return const SizedBox.shrink();
                              }
                              return Draggable(
                                childWhenDragging: SizedBox(
                                  width: 200,
                                  height: 50,
                                  child: ListTile(
                                    title: Text(
                                        "${state.employees[index].firstName!} ${state.employees[index].lastName!}"),
                                  ),
                                ),
                                data: state.employees[index],
                                feedback: Material(
                                  child: SizedBox(
                                    width: 200,
                                    height: 50,
                                    child: ListTile(
                                      title: Text(
                                          "${state.employees[index].firstName!} ${state.employees[index].lastName!}"),
                                    ),
                                  ),
                                ),
                                child: ListTile(
                                  title: Text(
                                      "${state.employees[index].firstName!} ${state.employees[index].lastName!}"),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.add),
                                    onPressed: () {
                                      setState(() {
                                        teamMembers.add(AssigneeModel(
                                            id: state.employees[index].id,
                                            firstName: state
                                                .employees[index].firstName,
                                            lastName: state
                                                .employees[index].lastName));
                                      });
                                    },
                                  ),
                                ),
                              );
                            }),
                      );
                    } else if (state is GetEmployeesLoading) {
                      return const CircularProgressIndicator();
                    } else if (state is GetEmployeesFailure) {
                      return const Text("Error");
                    } else
                      return Text(state.toString());
                  },
                  listener: (context, state) {
                    if (state is GetEmployeesFailure) {
                      print(state.error.message);
                      ElegantNotification.error(
                              description: const Text("Internal Error Occured"),
                              title: const Text("Error"))
                          .show(context);
                    }
                  },
                ),
              ),
              SizedBox(
                width: screenWidth * 0.25,
                height: screenHeight * 0.4,
                child: DragTarget<AssigneeModel>(
                  hitTestBehavior: HitTestBehavior.deferToChild,
                  builder: (context, candidateData, rejectedData) {
                    return Container(
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: ColorPallete.blackTertiary,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: ColorPallete.white,
                            width: 2,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: ColorPallete.black,
                              blurRadius: 10,
                            ),
                          ]),
                      child: Column(children: [
                        for (var assignee in teamMembers)
                          ListTile(
                            leading: IconButton(
                                onPressed: () {
                                  setState(() {
                                    teamLead = assignee;
                                  });
                                },
                                icon: teamLead == assignee
                                    ? const Icon(Icons.person_pin_sharp)
                                    : const Icon(Icons.person_pin)),
                            title: Text(
                                "${assignee.firstName!} ${assignee.lastName!}"),
                            trailing: IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                setState(() {
                                  teamMembers.remove(assignee);
                                });
                              },
                            ),
                          ),
                      ]),
                    );
                  },
                  onAcceptWithDetails: (details) {
                    setState(() {
                      teamMembers.add(details.data);
                    });
                  },
                ),
              ),
              SizedBox(
                width: screenWidth * 0.25,
                height: screenHeight * 0.4,
                child: Container(
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: ColorPallete.blackTertiary,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: ColorPallete.white,
                        width: 2,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: ColorPallete.black,
                          blurRadius: 10,
                        ),
                      ]),
                  child: Column(children: [
                    ListTile(
                      title: const Text("Team Lead"),
                      trailing: teamLead == null
                          ? const SizedBox.shrink()
                          : Text(
                              "${teamLead!.firstName!} ${teamLead!.lastName!}"),
                    ),
                    ListTile(
                      title: const Text("Members"),
                      trailing: Text(teamMembers.length.toString()),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _pageController.nextPage(
                            duration: Durations.medium1,
                            curve: Curves.bounceIn);
                      },
                      child: const Text("Next"),
                    ),
                  ]),
                ),
              )
            ],
          ),
          SizedBox(height: screenHeight * 0.02),
        ],
      ),
    );
  }

  Widget teamCreatePage_3(
      double screenHeight, double screenWidth, TextStyle? taskStyle) {
    return SingleChildScrollView(
      child: Column(
        children: [
          CustomAppBar(
              callback: () {
                _pageController.previousPage(
                    duration: Durations.medium1, curve: Curves.bounceIn);
              },
              children: [
                Text(
                  "Create Team",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const Spacer(),
                BlocBuilder<ProjectBloc, ProjectState>(
                  builder: (context, state) {
                    if (state is ProjectSuccessState) {
                      final data = state.projects;
                      if (data.isEmpty) return const Text("No Projects");
                      return DropdownMenu<ProjectEntity>(
                          width: screenWidth * 0.2,
                          hintText: "Select Project",
                          inputDecorationTheme: InputDecorationTheme(
                              border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(
                                color: ColorPallete.white, width: 2.0),
                          )),
                          dropdownMenuEntries: data
                              .map<DropdownMenuEntry<ProjectEntity>>((e) =>
                                  DropdownMenuEntry<ProjectEntity>(
                                      value: e, label: e.name))
                              .toList());
                    }
                    return SizedBox.fromSize();
                  },
                ),
              ]),
          Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: ColorPallete.blackTertiary,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: ColorPallete.white,
                  width: 2,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: ColorPallete.black,
                    blurRadius: 10,
                  ),
                ]),
            child: Column(children: [
              ListTile(
                title: const Text("Team Lead"),
                trailing: teamLead == null
                    ? const SizedBox.shrink()
                    : Text("${teamLead!.firstName!} ${teamLead!.lastName!}"),
              ),
              ListTile(
                title: const Text("Members"),
                trailing: Text(teamMembers.length.toString()),
              ),
              ListTile(
                title: const Text("Team Name"),
                trailing: Text(_nameController.text),
              ),
              ListTile(
                title: const Text("Team Description"),
                trailing: Text(_descriptionController.text),
              ),
              ElevatedButton(
                onPressed: () {
                  BlocProvider.of<TeamBloc>(context).add(CreateTeamEvent(
                      params: CreateTeamParam(
                          name: _nameController.text,
                          description: _descriptionController.text,
                          organisationId: User.organisation.id!,
                          createdBy: User.user.id,
                          isActive: true,
                          teamLead: teamLead!.id,
                          members: teamMembers.map((e) => e.id).toList(),
                          projectId: null)));
                },
                child: const Text("Create Team"),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hintText) {
    return InputDecoration(
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: ColorPallete.blackPrimary),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      hintText: hintText,
      filled: true,
    );
  }
}
