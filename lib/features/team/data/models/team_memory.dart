import 'package:hackathon/features/team/data/models/team_member.dart';
import 'package:hackathon/globals/models/team_model.dart';

class TeamMemory {
  final Team team;
  final List<TeamMember> teamMember;
  TeamMemory({required this.team, required this.teamMember});
}
