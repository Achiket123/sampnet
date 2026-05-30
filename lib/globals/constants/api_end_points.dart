import 'package:hackathon/dependency_injection.g.dart';
import 'package:hackathon/globals/constants/user.dart';

class ApiConstants {
  static const String baseUrl = "/api/v1";
  static const String websocketBaseUrl = "/api/v1";
  // Authentication Endpoints
  static const String signIn = "$baseUrl/auth/signin";
  static const String signUp = "$baseUrl/auth/signup";
  static const String signOut = "$baseUrl/auth/signout";
  static const String completeSignIn = "$baseUrl/auth/complete-signin";
  static const String validateEmployee = "$baseUrl/auth/validate-employee";

  // File Endpoints
  static const String uploadFile = "$baseUrl/file/upload";
  static const String getFile = "$baseUrl/file"; // Add ID as needed

  // Organization Endpoints
  static const String registerOrganisation = "$baseUrl/organisation/register";

  // Employee Endpoints
  static const String isEmployee = "$baseUrl/employees/is-employee";
  static const String addEmployee = "$baseUrl/employees/add";
  static String getEmployees =
      "$baseUrl/employees/get/${getIt<User>().organisation!.id}";
  static const String getEmployeeById = "$baseUrl/employees/list";
  static const String updateEmployee = "$baseUrl/employees/update";
  static const String deleteEmployee = "$baseUrl/employees/delete";
  static const String searchEmployee = "$baseUrl/employees/search";
  static const String makeManager = "$baseUrl/employees/make-manager";

  // Task Endpoints
  static const String createTask = "$baseUrl/tasks/create";
  static const String updateTask = "$baseUrl/tasks/update";
  static const String deleteTask = "$baseUrl/tasks/delete";
  static const String getTaskById = "$baseUrl/tasks/get";
  static const String getTeamTasks = "$baseUrl/tasks/team";
  static const String getProjectTasks = "$baseUrl/tasks/project";
  static const String getPersonalTasks = "$baseUrl/tasks/personal";
  static String getOrganisationTasks =
      "$baseUrl/tasks/organisation/${getIt<User>().organisation!.id}";
  static const String getTaskByTitle = "$baseUrl/tasks/title";

  // Team Endpoints
  static const String getTeams = "$baseUrl/teams/get";
  static const String createTeam = "$baseUrl/teams/create";
  static const String updateTeam = "$baseUrl/teams";
  static const String deleteTeam = "$baseUrl/teams/delete";
  static const String getTeamById = "$baseUrl/teams";
  static String getTeamsByOrganisation =
      "$baseUrl/teams/organisation/${getIt<User>().organisation!.id}";
  // Project Endpoints
  static const String getProjects = "$baseUrl/projects/organisation";
  static const String createProject = "$baseUrl/projects/create";
  static const String updateProject = "$baseUrl/projects";
  static const String deleteProject = "$baseUrl/projects";
  static const String getProjectById = "$baseUrl/projects";
  static String projectLessData =
      "$baseUrl/projects/less-data/${getIt<User>().organisation!.id}";

  // Attendence Endpoints
  static const String attendenceCheckInUrl = "$baseUrl/attendence/create";
  static const String attendenceCheckOutUrl = "$baseUrl/attendence";
  static const String getAttendence = "$baseUrl/attendence";

  // Chat Endpoints
  static const String createChat = "/chats/create";
  static const String getChats = "/chats";

  // Message Endpoints
  static const String sendMessage = "/messages/send";
  static String getMessages(String peerId) => "/messages/$peerId";

  // Call Endpoints
  static const String upsertCall = "/calls/upsert";
  static String updateCallOffer(String id) => "/calls/offer/$id";
  static String getCall(String id) => "/calls/$id";
  static String endCall(String id) => "/calls/end/$id";

  //ws:localhost:8000/ws/
  static const String callingEndpoint = "$websocketBaseUrl/call/";

  // Example for dynamically adding `id` to `getFile`
  static String getFileById(String id) => "$baseUrl/file/$id";
  static String updateEmployeeById(String id) =>
      "$baseUrl/employees/update/$id";
}
