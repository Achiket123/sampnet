import 'package:equatable/equatable.dart';
import 'package:hackathon/globals/models/team_model.dart';
import 'package:hackathon/globals/models/user_model.dart';

class TeamMember extends Equatable {
  int? id;
  int userId;
  int teamId;
  Team? team;
  UserModel? user;
  String role;
  bool isActive;
  bool isLeader;
  bool isAdmin;
  bool isManager;
  bool isEmployee;
  bool isBoss;

  TeamMember(
      {this.id,
      required this.userId,
      required this.teamId,
      this.team,
      required this.role,
      this.isActive = true,
      this.isLeader = false,
      this.isAdmin = false,
      this.isManager = false,
      this.isEmployee = false,
      this.isBoss = false,
      this.user});

  // Factory constructor for JSON deserialization
  factory TeamMember.fromJson(Map<String, dynamic> json) {
    return TeamMember(
        id: json['id'],
        userId: json['user_id'],
        teamId: json['team_id'],
        team: json['team'] != null ? Team.fromJson(json['team']) : null,
        role: json['role'],
        isActive: json['is_active'] ?? true,
        isLeader: json['is_leader'] ?? false,
        isAdmin: json['is_admin'] ?? false,
        isManager: json['is_manager'] ?? false,
        isEmployee: json['is_employee'] ?? false,
        isBoss: json['is_boss'] ?? false,
        user: json['user'] != null ? UserModel.fromJson(json['user']) : null);
  }

  // Convert object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'team_id': teamId,
      'team': team?.toJson(),
      'role': role,
      'is_active': isActive,
      'is_leader': isLeader,
      'is_admin': isAdmin,
      'is_manager': isManager,
      'is_employee': isEmployee,
      'is_boss': isBoss,
    };
  }

  @override
  // TODO: implement props
  List<Object?> get props => [id];
}
