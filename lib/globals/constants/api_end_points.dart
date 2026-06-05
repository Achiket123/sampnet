import 'package:hackathon/dependency_injection.g.dart';
import 'package:hackathon/globals/constants/user.dart';

class ApiConstants {
  static const String baseUrl = "http://localhost:8000/api/v1";
  static const String websocketBaseUrl = "ws://localhost:8000/api/v1";
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
  static String getTaskActivity(String taskId) => "$baseUrl/tasks/$taskId/activity";

  // Team Endpoints
  static const String getTeams = "$baseUrl/teams/get";
  static const String createTeam = "$baseUrl/teams/create";
  static const String updateTeam = "$baseUrl/teams";
  static const String deleteTeam = "$baseUrl/teams/delete";
  static const String getTeamById = "$baseUrl/teams";
  static String getTeamsByOrganisation =
      "$baseUrl/teams/organisation/${getIt<User>().organisation!.id}";
  // Project Endpoints
  static const String projectsRoot = "/projects";
  static const String getProjects = "/projects";
  static const String createProject = "/projects";
  static String updateProject(int id) => "/projects/$id";
  static String deleteProject(int id) => "/projects/$id";
  static String getProjectById(int id) => "/projects/$id";
  static const String projectLessData = "/projects/less-data";

  // Milestone Endpoints
  static String createMilestone(int projectId) => "/projects/$projectId/milestones";
  static String updateMilestone(int projectId, int milestoneId) => "/projects/$projectId/milestones/$milestoneId";
  static String deleteMilestone(int projectId, int milestoneId) => "/projects/$projectId/milestones/$milestoneId";

  // Notification Endpoints
  static const String notifications = "/notifications";
  static String markNotificationRead(int id) => "$notifications/$id/read";
  static const String markAllNotificationsRead = "$notifications/read-all";

  // Onboarding Endpoints
  static String getOnboardingProgress(String userId) => "/onboarding/$userId";
  static const String updateOnboardingProgress = "/onboarding/update";

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

  // Leave Endpoints
  static const String leaveRequest = "/leave/request";
  static const String myLeaves = "/leave/my";
  static String organisationLeaves(int orgId) => "/leave/organisation/$orgId";
  static String leaveById(int id) => "/leave/$id";
  static String approveLeave(int id) => "/leave/$id/approve";
  static String rejectLeave(int id) => "/leave/$id/reject";
  static String cancelLeave(int id) => "/leave/$id/cancel";

  // Search Endpoints
  static const String globalSearch = "/search";
}
