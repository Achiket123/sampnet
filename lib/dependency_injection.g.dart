import 'package:get_it/get_it.dart';
import 'package:hackathon/features/attendence/data/data_sources/attendence_remote_data_source.dart';
import 'package:hackathon/features/attendence/data/repositories_impl/attendence_repository_impl.dart';
import 'package:hackathon/features/attendence/domain/repositories/attendence_repository.dart';
import 'package:hackathon/features/attendence/domain/use_cases/attendence_usecase.dart';
import 'package:hackathon/features/attendence/presentation/blocs/bloc/attendence_bloc.dart';
import 'package:hackathon/features/auth/data/datasource/auth_local_datasource.dart';
import 'package:hackathon/features/auth/data/datasource/auth_remote_datasource.dart';
import 'package:hackathon/features/auth/data/repository/auth_repository_impl.dart';
import 'package:hackathon/features/auth/domain/repository/auth_repository.dart';
import 'package:hackathon/features/auth/domain/usecase/auth_usecase.dart';
import 'package:hackathon/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:hackathon/features/chats/data/data_sources/chat_data_source.dart';
import 'package:hackathon/features/chats/data/data_sources/message_data_source.dart';
import 'package:hackathon/features/chats/data/repositories_impl/chat_repository_impl.dart';
import 'package:hackathon/features/chats/data/repositories_impl/message_repository_impl.dart';
import 'package:hackathon/features/chats/domain/repositories/chat_repository.dart';
import 'package:hackathon/features/chats/domain/repositories/message_repository.dart';
import 'package:hackathon/features/chats/domain/use_cases/chat_usecase.dart';
import 'package:hackathon/features/chats/presentation/blocs/chat_bloc/chat_bloc_bloc.dart';
import 'package:hackathon/features/chats/presentation/blocs/message_bloc/message_bloc.dart';
import 'package:hackathon/features/company/data/data_sources/company_remote_data_source.dart';
import 'package:hackathon/features/company/data/repositories_impl/register_company_repository_impl.dart';
import 'package:hackathon/features/company/domain/repositories/register_company_repository.dart';
import 'package:hackathon/features/company/domain/use_cases/register_company_usecase.dart';
import 'package:hackathon/features/company/presentation/blocs/register%20comapny%20bloc/register_company_bloc.dart';
import 'package:hackathon/features/dashboards/data/data_sources/validate_emp_datasource.dart';
import 'package:hackathon/features/dashboards/data/repositories_impl/validate_emp_repo_impl.dart';
import 'package:hackathon/features/dashboards/domain/repositories/validate_emp_repo.dart';
import 'package:hackathon/features/dashboards/domain/use_cases/validate_emp_usecase.dart';
import 'package:hackathon/features/dashboards/presentation/blocs/bloc/validate_employee_bloc.dart';
import 'package:hackathon/features/tasks/data/data_sources/emp_data_sorce.dart';
import 'package:hackathon/features/tasks/data/data_sources/project_data_source.dart';
import 'package:hackathon/features/tasks/data/data_sources/task_remote_data_source.dart';
import 'package:hackathon/features/tasks/data/data_sources/task_team_data_source.dart';
import 'package:hackathon/features/tasks/data/repository/task_team_repository_impl.dart';
import 'package:hackathon/features/tasks/domain/repositories/task_team_repository.dart';
import 'package:hackathon/features/tasks/domain/use_cases/task_get_team_usecase.dart';
import 'package:hackathon/features/team/data/datasources/team_data_source.dart';
import 'package:hackathon/features/tasks/data/repository/emp_repository_impl.dart';
import 'package:hackathon/features/tasks/data/repository/project_repository_impl.dart';
import 'package:hackathon/features/tasks/data/repository/task_repository_impl.dart';
import 'package:hackathon/features/team/data/datasources/team_project_data_source.dart';
import 'package:hackathon/features/team/data/repo/team_repository_impl.dart';
import 'package:hackathon/features/tasks/domain/repositories/emp_repository.dart';
import 'package:hackathon/features/tasks/domain/repositories/project_repository.dart';
import 'package:hackathon/features/tasks/domain/repositories/task_repository.dart';
import 'package:hackathon/features/team/domain/repo/team_project_repo.dart';
import 'package:hackathon/features/team/domain/repo/team_repository.dart';
import 'package:hackathon/features/tasks/domain/use_cases/create_task_usecase.dart';
import 'package:hackathon/features/tasks/domain/use_cases/fetch_task_usecase.dart';
import 'package:hackathon/features/tasks/domain/use_cases/get_emp_usecase.dart';
import 'package:hackathon/features/tasks/domain/use_cases/get_project_usecase.dart';
import 'package:hackathon/features/team/domain/usecases/create_team_usecase.dart';
import 'package:hackathon/features/team/domain/usecases/get_team_usecase.dart';
import 'package:hackathon/features/tasks/domain/use_cases/update_task_usecase.dart';
import 'package:hackathon/features/tasks/presentation/blocs/create_task_bloc/create_task_bloc.dart';
import 'package:hackathon/features/tasks/presentation/blocs/get_emp_bloc/get_employees_bloc.dart';
import 'package:hackathon/features/tasks/presentation/blocs/get_project_bloc/get_project_bloc.dart';
import 'package:hackathon/features/tasks/presentation/blocs/task_bloc/task_bloc.dart';
import 'package:hackathon/features/team/domain/usecases/team_get_project_usecase.dart';
import 'package:hackathon/features/team/presentation/blocs/project_bloc/project_bloc.dart';
import 'package:hackathon/features/team/presentation/blocs/team_bloc/team_bloc.dart';
import 'package:hackathon/features/team/presentation/blocs/team_id_bloc/teamid_bloc.dart';
import 'package:hackathon/features/upload_files/data/data_sources/upload_file.dart';
import 'package:hackathon/features/upload_files/data/repositories_impl/upload_file_repository_impl.dart';
import 'package:hackathon/features/upload_files/domain/repositories/upload_file_repository.dart';
import 'package:hackathon/features/upload_files/domain/use_cases/upload_file_usecase.dart';
import 'package:hackathon/features/upload_files/presentation/bloc/upload_file_bloc.dart';
import 'package:hackathon/features/chats/domain/use_cases/message_usecase.dart';
import 'package:hackathon/globals/constants/user.dart';
import 'package:hackathon/services/api_client.dart';
import 'package:hackathon/globals/constants/api_end_points.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:hackathon/features/tasks/data/data_sources/task_comment_data_source.dart';
import 'package:hackathon/features/tasks/data/data_sources/task_attachment_data_source.dart';
import 'package:hackathon/features/tasks/data/repository/task_comment_repository_impl.dart';
import 'package:hackathon/features/tasks/data/repository/task_attachment_repository_impl.dart';
import 'package:hackathon/features/tasks/domain/repositories/task_comment_repository.dart';
import 'package:hackathon/features/tasks/domain/repositories/task_attachment_repository.dart';
import 'package:hackathon/features/tasks/domain/use_cases/add_task_comment_usecase.dart';
import 'package:hackathon/features/tasks/domain/use_cases/get_task_comments_usecase.dart';
import 'package:hackathon/features/tasks/domain/use_cases/delete_task_comment_usecase.dart';
import 'package:hackathon/features/tasks/domain/use_cases/add_task_attachment_usecase.dart';
import 'package:hackathon/features/tasks/domain/use_cases/get_task_attachments_usecase.dart';
import 'package:hackathon/features/tasks/domain/use_cases/remove_task_attachment_usecase.dart';
import 'package:hackathon/features/tasks/presentation/blocs/task_detail_bloc/task_detail_bloc.dart';
import 'package:hackathon/features/notifications/data/data_sources/notifications_remote_data_source.dart';
import 'package:hackathon/features/notifications/data/repositories/notification_repository_impl.dart';
import 'package:hackathon/features/notifications/domain/repositories/notification_repository.dart';
import 'package:hackathon/features/notifications/domain/use_cases/get_notifications_usecase.dart';
import 'package:hackathon/features/notifications/domain/use_cases/mark_all_read_usecase.dart';
import 'package:hackathon/features/notifications/domain/use_cases/mark_notification_read_usecase.dart';
import 'package:hackathon/features/notifications/presentation/blocs/notifications_bloc/notification_type_filter.dart';
import 'package:hackathon/features/notifications/presentation/blocs/notifications_bloc/notifications_bloc.dart';
import 'package:hackathon/features/onboarding/data/data_sources/onboarding_remote_data_source.dart';
import 'package:hackathon/features/onboarding/data/repositories_impl/onboarding_repository_impl.dart';
import 'package:hackathon/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:hackathon/features/onboarding/domain/use_cases/get_onboarding_progress_usecase.dart';
import 'package:hackathon/features/onboarding/domain/use_cases/update_onboarding_progress_usecase.dart';
import 'package:hackathon/features/onboarding/presentation/blocs/onboarding_bloc/onboarding_bloc.dart';
import 'package:hackathon/features/leave/data/data_sources/leave_remote_data_source.dart';
import 'package:hackathon/features/leave/data/repositories_impl/leave_repository_impl.dart';
import 'package:hackathon/features/leave/domain/repositories/leave_repository.dart';
import 'package:hackathon/features/leave/domain/use_cases/submit_leave_request_usecase.dart';
import 'package:hackathon/features/leave/domain/use_cases/get_leave_history_usecase.dart';
import 'package:hackathon/features/leave/domain/use_cases/get_all_leave_requests_usecase.dart';
import 'package:hackathon/features/leave/domain/use_cases/approve_leave_usecase.dart';
import 'package:hackathon/features/leave/domain/use_cases/reject_leave_usecase.dart';
import 'package:hackathon/features/leave/domain/use_cases/cancel_leave_usecase.dart';
import 'package:hackathon/features/leave/presentation/blocs/leave_bloc/leave_bloc.dart';
import 'package:hackathon/features/team/data/repo/team_project_repo_impl.dart';
import 'package:hackathon/features/employees/data/data_sources/employees_remote_data_source.dart';
import 'package:hackathon/features/employees/data/repositories/employees_repository_impl.dart';
import 'package:hackathon/features/employees/domain/repositories/employees_repository.dart';
import 'package:hackathon/features/employees/domain/use_cases/get_employees_usecase.dart';
import 'package:hackathon/features/employees/domain/use_cases/get_employee_profile_usecase.dart';
import 'package:hackathon/features/employees/domain/use_cases/add_employee_usecase.dart';
import 'package:hackathon/features/employees/domain/use_cases/edit_employee_usecase.dart';
import 'package:hackathon/features/employees/domain/use_cases/deactivate_employee_usecase.dart';
import 'package:hackathon/features/employees/domain/use_cases/search_employees_usecase.dart';
import 'package:hackathon/features/employees/domain/use_cases/make_manager_usecase.dart';
import 'package:hackathon/features/employees/presentation/blocs/employees_list_bloc/employees_list_bloc.dart';
import 'package:hackathon/features/employees/presentation/blocs/add_employee_bloc/add_employee_bloc.dart';
import 'package:hackathon/features/employees/presentation/blocs/employee_profile_bloc/employee_profile_bloc.dart';

// Projects Module imports
import 'package:hackathon/features/projects/data/data_sources/project_remote_data_source.dart';
import 'package:hackathon/features/projects/data/repositories_impl/project_repository_impl.dart' as projects_data;
import 'package:hackathon/features/projects/domain/repositories/project_repository.dart' as projects_domain;
import 'package:hackathon/features/projects/domain/use_cases/get_projects_usecase.dart';
import 'package:hackathon/features/projects/domain/use_cases/get_project_detail_usecase.dart';
import 'package:hackathon/features/projects/domain/use_cases/create_project_usecase.dart';
import 'package:hackathon/features/projects/domain/use_cases/update_project_usecase.dart';
import 'package:hackathon/features/projects/domain/use_cases/delete_project_usecase.dart';
import 'package:hackathon/features/projects/domain/use_cases/create_milestone_usecase.dart';
import 'package:hackathon/features/projects/domain/use_cases/update_milestone_usecase.dart';
import 'package:hackathon/features/projects/domain/use_cases/delete_milestone_usecase.dart';
import 'package:hackathon/features/projects/presentation/blocs/project_bloc/project_bloc.dart';
import 'package:hackathon/features/search/data/data_sources/search_remote_data_source.dart';
import 'package:hackathon/features/search/data/repositories_impl/search_repository_impl.dart';
import 'package:hackathon/features/search/domain/repositories/search_repository.dart';
import 'package:hackathon/features/search/domain/use_cases/global_search_usecase.dart';
import 'package:hackathon/features/search/presentation/blocs/search_bloc/search_bloc.dart';
import 'package:hackathon/services/websocket_service.dart';

// Resources Module Imports
import 'package:hackathon/features/resources/data/data_sources/resources_remote_data_source.dart';
import 'package:hackathon/features/resources/data/repositories_impl/resources_repository_impl.dart';
import 'package:hackathon/features/resources/domain/repositories/resources_repository.dart';
import 'package:hackathon/features/resources/domain/use_cases/delete_file_usecase.dart';
import 'package:hackathon/features/resources/domain/use_cases/get_file_detail_usecase.dart';
import 'package:hackathon/features/resources/domain/use_cases/get_files_usecase.dart';
import 'package:hackathon/features/resources/domain/use_cases/update_file_access_usecase.dart';
import 'package:hackathon/features/resources/domain/use_cases/upload_file_usecase.dart';
import 'package:hackathon/features/resources/presentation/blocs/resources_list_bloc/resources_list_bloc.dart';

// Calendar Module Imports
import 'package:hackathon/features/calendar/data/data_sources/calendar_remote_data_source.dart';
import 'package:hackathon/features/calendar/data/repositories_impl/calendar_repository_impl.dart';
import 'package:hackathon/features/calendar/domain/repositories/calendar_repository.dart';
import 'package:hackathon/features/calendar/domain/use_cases/get_personal_calendar_usecase.dart';
import 'package:hackathon/features/calendar/domain/use_cases/get_team_calendar_usecase.dart';
import 'package:hackathon/features/calendar/presentation/blocs/calendar_bloc/calendar_bloc.dart';

// Research Module Imports
import 'package:hackathon/features/research/data/data_sources/research_remote_data_source.dart';
import 'package:hackathon/features/research/data/repositories_impl/research_repository_impl.dart';
import 'package:hackathon/features/research/domain/repositories/research_repository.dart';
import 'package:hackathon/features/research/domain/use_cases/fetch_research_list_usecase.dart';
import 'package:hackathon/features/research/domain/use_cases/get_research_detail_usecase.dart';
import 'package:hackathon/features/research/domain/use_cases/create_research_entry_usecase.dart';
import 'package:hackathon/features/research/domain/use_cases/update_research_entry_usecase.dart';
import 'package:hackathon/features/research/domain/use_cases/delete_research_entry_usecase.dart';
import 'package:hackathon/features/research/presentation/blocs/research_list_bloc/research_list_bloc.dart';
import 'package:hackathon/features/research/presentation/blocs/research_detail_bloc/research_detail_bloc.dart';

final getIt = GetIt.instance;

void initDependencies() {
  // Http client
  getIt.registerLazySingleton(() => http.Client());

  // Api Client
  getIt.registerLazySingleton(
      () => ApiClient(client: getIt(), baseUrl: ApiConstants.baseUrl));

  // Data Sources

  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(apiClient: getIt()),
  );
  getIt.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(hive: Hive),
  );
  getIt.registerLazySingleton<UploadFileDataSource>(
    () => UploadFileDataSourceImpl(apiClient: getIt()),
  );
  getIt.registerLazySingleton<CompanyRemoteDataSource>(
    () => CompanyRemoteDataSourceImpl(apiClient: getIt()),
  );
  getIt.registerLazySingleton<AttendenceRemoteDataSource>(
    () => AttendenceRemoteDataSourceImpl(client: getIt()),
  );
  getIt.registerLazySingleton<ProjectDataSource>(
    () => ProjectDataSourceImpl(client: getIt()),
  );
  getIt.registerLazySingleton<TaskTeamDataSource>(
    () => TaskTeamDataSourceImpl(client: getIt()),
  );
  getIt.registerLazySingleton<EmployeeDataSource>(
    () => EmployeeDataSourceImpl(apiService: getIt()),
  );
  getIt.registerLazySingleton<ValidateEmpDataSource>(
    () => ValidateEmpDataSourceImpl(client: getIt()),
  );
  getIt.registerLazySingleton<TaskRemoteDataSource>(
    () => TaskRemoteDataSourceImpl(client: getIt()),
  );
  getIt.registerLazySingleton<UpdateTaskRemoteDataSource>(
    () => UpdateTaskRemoteDataSourceImpl(client: getIt()),
  );
  getIt.registerLazySingleton<TaskCommentRemoteDataSource>(
    () => TaskCommentRemoteDataSourceImpl(apiClient: getIt()),
  );
  getIt.registerLazySingleton<TaskAttachmentRemoteDataSource>(
    () => TaskAttachmentRemoteDataSourceImpl(apiClient: getIt()),
  );
  getIt.registerLazySingleton<OnboardingRemoteDataSource>(
    () => OnboardingRemoteDataSourceImpl(apiClient: getIt()),
  );
  getIt.registerLazySingleton<LeaveRemoteDataSource>(
    () => LeaveRemoteDataSourceImpl(apiClient: getIt()),
  );
  getIt.registerLazySingleton<NotificationsRemoteDataSource>(
    () => NotificationsRemoteDataSourceImpl(apiClient: getIt()),
  );
  getIt.registerLazySingleton<NotificationTypeFilter>(
    () => NotificationTypeFilter(),
  );
  getIt.registerLazySingleton<ChatDataSource>(
      () => ChatDataSourceImpl(apiClient: getIt()));

  getIt.registerLazySingleton<MessageDataSource>(
      () => MessageDataSourceImpl(apiClient: getIt()));

  getIt.registerLazySingleton<TeamDataSource>(
      () => TeamDataSourceImpl(client: getIt()));

  getIt.registerLazySingleton<TeamProjectDataSource>(
      () => TeamProjectDataSourceImpl(getIt()));

  getIt.registerLazySingleton<EmployeesRemoteDataSource>(
    () => EmployeesRemoteDataSourceImpl(apiClient: getIt()),
  );

  getIt.registerLazySingleton<ProjectRemoteDataSource>(
    () => ProjectRemoteDataSourceImpl(apiClient: getIt()),
  );

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: getIt(),
      localDataSource: getIt(),
    ),
  );
  getIt.registerLazySingleton<UploadFileRepository>(
    () => UploadFileRepositoryImpl(uploadFileDataSource: getIt()),
  );
  getIt.registerLazySingleton<RegisterCompanyRepository>(
    () => RegisterCompanyRepositoryImpl(getIt()),
  );
  getIt.registerLazySingleton<AttendenceRepository>(
    () => AttendenceRepositoryImpl(attendenceRemoteDataSource: getIt()),
  );
  getIt.registerLazySingleton<ProjectRepository>(
    () => ProjectRepositoryImpl(dataSource: getIt()),
  );
  getIt.registerLazySingleton<TeamRepository>(
    () => TeamRepositoryImpl(dataSource: getIt()),
  );
  getIt.registerLazySingleton<EmployeeRepository>(
    () => EmployeeRepositoryImpl(dataSource: getIt()),
  );
  getIt.registerLazySingleton<OnboardingRepository>(
    () => OnboardingRepositoryImpl(remoteDataSource: getIt()),
  );
  getIt.registerLazySingleton<LeaveRepository>(
    () => LeaveRepositoryImpl(remoteDataSource: getIt()),
  );
  getIt.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(remoteDataSource: getIt()),
  );
  getIt.registerLazySingleton<ValidateEmployeeRepository>(
    () => ValidateEmpRepoImpl(dataSource: getIt()),
  );
  getIt.registerLazySingleton<TaskRepository>(
    () => TaskRepositoryImpl(taskRemoteDataSource: getIt()),
  );
  getIt.registerLazySingleton<FetchTaskRepository>(
    () => FetchTaskRepositoryImpl(taskRemoteDataSource: getIt()),
  );
  getIt.registerLazySingleton<UpdateTaskRepository>(
    () => UpdateTaskRepositoryImpl(remoteDataSource: getIt()),
  );
  getIt.registerLazySingleton<TaskCommentRepository>(
    () => TaskCommentRepositoryImpl(remoteDataSource: getIt()),
  );
  getIt.registerLazySingleton<TaskAttachmentRepository>(
    () => TaskAttachmentRepositoryImpl(remoteDataSource: getIt()),
  );
  getIt.registerLazySingleton<ChatRepository>(
      () => ChatRepositoryImpl(dataSource: getIt()));

  getIt.registerLazySingleton<MessageRepository>(
      () => MessageRepositoryImpl(messageDataSource: getIt()));

  getIt.registerLazySingleton<TaskTeamRepository>(
      () => TaskTeamRepositoryImpl(dataSource: getIt()));

  getIt.registerLazySingleton<TeamProjectRepo>(
      () => TeamProjectRepoImpl(getIt()));

  getIt.registerLazySingleton<EmployeesRepository>(
    () => EmployeesRepositoryImpl(remoteDataSource: getIt()),
  );

  getIt.registerLazySingleton<projects_domain.ProjectRepository>(
    () => projects_data.ProjectRepositoryImpl(remoteDataSource: getIt()),
  );

  // Use Cases
  getIt.registerLazySingleton<SignUpUsecase>(
    () => SignUpUsecase(repository: getIt()),
  );
  getIt.registerLazySingleton<SignInUsecase>(
    () => SignInUsecase(repository: getIt()),
  );
  getIt.registerLazySingleton<GetTokenUsecase>(
    () => GetTokenUsecase(repository: getIt()),
  );
  getIt.registerLazySingleton<UploadFileUsecase>(
    () => UploadFileUsecase(uploadFileRepository: getIt()),
  );
  getIt.registerLazySingleton<RegisterCompanyUseCase>(
    () => RegisterCompanyUseCase(getIt()),
  );
  getIt.registerLazySingleton<FetchEmployeeDataUseCase>(
    () => FetchEmployeeDataUseCase(getIt()),
  );
  getIt.registerLazySingleton<AttendenceGetUsecase>(
    () => AttendenceGetUsecase(attendenceRepository: getIt()),
  );
  getIt.registerLazySingleton<AttendenceCheckInUsecase>(
    () => AttendenceCheckInUsecase(attendenceRepository: getIt()),
  );
  getIt.registerLazySingleton<AttendenceCheckOutUsecase>(
    () => AttendenceCheckOutUsecase(attendenceRepository: getIt()),
  );
  getIt.registerLazySingleton<GetEmployeesUseCase>(
    () => GetEmployeesUseCase(employeeRepository: getIt()),
  );
  getIt.registerLazySingleton<GetProjectUseCase>(
    () => GetProjectUseCase(projectRepository: getIt()),
  );
  getIt.registerLazySingleton<GetTeamUseCase>(
    () => GetTeamUseCase(teamRepository: getIt()),
  );
  getIt.registerLazySingleton<ValidateEmpUsecase>(
    () => ValidateEmpUsecase(repository: getIt()),
  );
  getIt.registerLazySingleton<FetchTaskByIdUsecase>(
    () => FetchTaskByIdUsecase(getIt()),
  );
  getIt.registerLazySingleton<FetchTaskByOrganisationIdUsecase>(
    () => FetchTaskByOrganisationIdUsecase(getIt()),
  );
  getIt.registerLazySingleton<CreateTaskUseCase>(
    () => CreateTaskUseCase(taskRepository: getIt()),
  );
  getIt.registerLazySingleton<UpdateTaskUsecase>(
    () => UpdateTaskUsecase(repository: getIt()),
  );
  getIt.registerLazySingleton<FetchTaskUsecase>(
    () => FetchTaskUsecase(getIt()),
  );
  getIt.registerLazySingleton<AddTaskCommentUseCase>(
    () => AddTaskCommentUseCase(repository: getIt()),
  );
  getIt.registerLazySingleton<GetTaskCommentsUseCase>(
    () => GetTaskCommentsUseCase(repository: getIt()),
  );
  getIt.registerLazySingleton<DeleteTaskCommentUseCase>(
    () => DeleteTaskCommentUseCase(repository: getIt()),
  );
  getIt.registerLazySingleton<AddTaskAttachmentUseCase>(
    () => AddTaskAttachmentUseCase(repository: getIt()),
  );
  getIt.registerLazySingleton<GetTaskAttachmentsUseCase>(
    () => GetTaskAttachmentsUseCase(repository: getIt()),
  );
  getIt.registerLazySingleton<RemoveTaskAttachmentUseCase>(
    () => RemoveTaskAttachmentUseCase(repository: getIt()),
  );
  getIt.registerLazySingleton<GetNotificationsUseCase>(
    () => GetNotificationsUseCase(getIt()),
  );
  getIt.registerLazySingleton<MarkNotificationReadUseCase>(
    () => MarkNotificationReadUseCase(getIt()),
  );
  getIt.registerLazySingleton<MarkAllReadUseCase>(
    () => MarkAllReadUseCase(getIt()),
  );
  getIt.registerLazySingleton<GetOnboardingProgressUseCase>(
    () => GetOnboardingProgressUseCase(getIt()),
  );
  getIt.registerLazySingleton<UpdateOnboardingProgressUseCase>(
    () => UpdateOnboardingProgressUseCase(getIt()),
  );
  getIt.registerLazySingleton<SubmitLeaveRequestUsecase>(
    () => SubmitLeaveRequestUsecase(repository: getIt()),
  );
  getIt.registerLazySingleton<GetLeaveHistoryUsecase>(
    () => GetLeaveHistoryUsecase(repository: getIt()),
  );
  getIt.registerLazySingleton<GetAllLeaveRequestsUsecase>(
    () => GetAllLeaveRequestsUsecase(repository: getIt()),
  );
  getIt.registerLazySingleton<ApproveLeaveUsecase>(
    () => ApproveLeaveUsecase(repository: getIt()),
  );
  getIt.registerLazySingleton<RejectLeaveUsecase>(
    () => RejectLeaveUsecase(repository: getIt()),
  );
  getIt.registerLazySingleton<CancelLeaveUsecase>(
    () => CancelLeaveUsecase(repository: getIt()),
  );

  getIt.registerLazySingleton<GetEmployeesUsecase>(
    () => GetEmployeesUsecase(getIt()),
  );
  getIt.registerLazySingleton<GetEmployeeProfileUsecase>(
    () => GetEmployeeProfileUsecase(getIt()),
  );
  getIt.registerLazySingleton<AddEmployeeUsecase>(
    () => AddEmployeeUsecase(getIt()),
  );
  getIt.registerLazySingleton<EditEmployeeUsecase>(
    () => EditEmployeeUsecase(getIt()),
  );
  getIt.registerLazySingleton<DeactivateEmployeeUsecase>(
    () => DeactivateEmployeeUsecase(getIt()),
  );
  getIt.registerLazySingleton<SearchEmployeesUsecase>(
    () => SearchEmployeesUsecase(getIt()),
  );
  getIt.registerLazySingleton<MakeManagerUsecase>(
    () => MakeManagerUsecase(getIt()),
  );

  getIt.registerLazySingleton<StreamChatUsecase>(
      () => StreamChatUsecase(chatRepository: getIt()));
  getIt.registerLazySingleton<CreateChatUsecase>(
      () => CreateChatUsecase(chatRepository: getIt()));

  getIt.registerLazySingleton<GetChatUsecase>(
      () => GetChatUsecase(chatRepository: getIt()));

  getIt.registerLazySingleton<MessageUsecase>(() => MessageUsecase(
        messageRepository: getIt(),
      ));
  getIt.registerLazySingleton<TeamGetProjectUsecase>(
      () => TeamGetProjectUsecase(getIt()));

  getIt.registerLazySingleton<TaskGetTeamUsecase>(
      () => TaskGetTeamUsecase(teamRepository: getIt()));

  getIt.registerLazySingleton<CreateTeamUsecase>(
      () => CreateTeamUsecase(getIt()));

  getIt.registerLazySingleton<GetTeamByIdUseCase>(
      () => GetTeamByIdUseCase(teamRepository: getIt()));

  getIt.registerLazySingleton<SaveTokenUsecase>(() => SaveTokenUsecase(
        repository: getIt(),
      ));

  getIt.registerLazySingleton<GetProjectsUseCase>(
    () => GetProjectsUseCase(repository: getIt<projects_domain.ProjectRepository>()),
  );
  getIt.registerLazySingleton<GetProjectDetailUseCase>(
    () => GetProjectDetailUseCase(repository: getIt<projects_domain.ProjectRepository>()),
  );
  getIt.registerLazySingleton<CreateProjectUseCase>(
    () => CreateProjectUseCase(repository: getIt<projects_domain.ProjectRepository>()),
  );
  getIt.registerLazySingleton<UpdateProjectUseCase>(
    () => UpdateProjectUseCase(repository: getIt<projects_domain.ProjectRepository>()),
  );
  getIt.registerLazySingleton<DeleteProjectUseCase>(
    () => DeleteProjectUseCase(repository: getIt<projects_domain.ProjectRepository>()),
  );
  getIt.registerLazySingleton<CreateMilestoneUseCase>(
    () => CreateMilestoneUseCase(repository: getIt<projects_domain.ProjectRepository>()),
  );
  getIt.registerLazySingleton<UpdateMilestoneUseCase>(
    () => UpdateMilestoneUseCase(repository: getIt<projects_domain.ProjectRepository>()),
  );
  getIt.registerLazySingleton<DeleteMilestoneUseCase>(
    () => DeleteMilestoneUseCase(repository: getIt<projects_domain.ProjectRepository>()),
  );

  // Blocs
  getIt.registerFactory<AuthBloc>(
    () => AuthBloc(
      saveTokenUsecase: getIt(),
      signUpUsecase: getIt(),
      signInUsecase: getIt(),
      getTokenUsecase: getIt(),
    ),
  );
  getIt.registerFactory<UploadFileBloc>(
    () => UploadFileBloc(uploadFileUsecase: getIt()),
  );
  getIt.registerFactory<RegisterCompanyBloc>(
    () => RegisterCompanyBloc(
      registerCompanyUseCase: getIt(),
      fetchEmployeeDataUseCase: getIt(),
    ),
  );
  getIt.registerFactory<AttendenceBloc>(
    () => AttendenceBloc(
      attendenceGetUsecase: getIt(),
      attendenceCheckInUsecase: getIt(),
      attendenceCheckOutUsecase: getIt(),
    ),
  );
  getIt.registerFactory<GetEmployeesBloc>(
    () => GetEmployeesBloc(
      getEmployeesUseCase: getIt(),
      getProjectUseCase: getIt(),
      getTeamUseCase: getIt(),
    ),
  );
  getIt.registerFactory<GetProjectBloc>(
    () => GetProjectBloc(getProjectUseCase: getIt()),
  );
  getIt.registerFactory<ValidateEmployeeBloc>(
    () => ValidateEmployeeBloc(usecase: getIt()),
  );
  getIt.registerFactory<OnboardingBloc>(
    () => OnboardingBloc(
      getOnboardingProgressUseCase: getIt(),
      updateOnboardingProgressUseCase: getIt(),
    ),
  );
  getIt.registerFactory<LeaveBloc>(
    () => LeaveBloc(
      submitLeaveRequestUsecase: getIt(),
      getLeaveHistoryUsecase: getIt(),
      getAllLeaveRequestsUsecase: getIt(),
      approveLeaveUsecase: getIt(),
      rejectLeaveUsecase: getIt(),
      cancelLeaveUsecase: getIt(),
    ),
  );
  getIt.registerFactory<NotificationsBloc>(
    () => NotificationsBloc(
      repository: getIt(),
      typeFilter: getIt(),
    ),
  );
  getIt.registerFactory<EmployeesListBloc>(
    () => EmployeesListBloc(repository: getIt()),
  );
  getIt.registerFactory<AddEmployeeBloc>(
    () => AddEmployeeBloc(repository: getIt()),
  );
  getIt.registerFactory<EmployeeProfileBloc>(
    () => EmployeeProfileBloc(repository: getIt()),
  );
  getIt.registerFactory<CreateTaskBloc>(
    () => CreateTaskBloc(createTaskUsecase: getIt()),
  );
  getIt.registerFactory<TaskBloc>(
    () => TaskBloc(fetchTasksUsecase: getIt(), updateTaskUsecase: getIt()),
  );
  getIt.registerFactory<ChatBlocBloc>(
    () => ChatBlocBloc(
      usecase: getIt(),
      createChatUsecase: getIt(),
      getChatUsecase: getIt(),
    ),
  );
  getIt
      .registerFactory<MessageBloc>(() => MessageBloc(messageUseCase: getIt()));

  getIt.registerFactory<ProjectBloc>(
      () => ProjectBloc(teamGetProjectUsecase: getIt()));
  getIt.registerCachedFactory<TeamBloc>(
      () => TeamBloc(createTeamUsecase: getIt(), getTeamUseCase: getIt()));

  getIt.registerFactory<TeamidBloc>(
      () => TeamidBloc(getTeamByIdUseCase: getIt()));

  // User
  getIt.registerLazySingleton<User>(() => User());

  // WebSocket Service
  getIt.registerLazySingleton<WebsocketService>(
    () => WebsocketService(user: getIt()),
  );
getIt.registerFactory(
  () => TaskDetailBloc(
    getTaskUsecase: getIt(),
    updateTaskUsecase: getIt(),
    addTaskCommentUsecase: getIt(),
    getTaskCommentsUsecase: getIt(),
    deleteTaskCommentUsecase: getIt(),
    addTaskAttachmentUsecase: getIt(),
    getTaskAttachmentsUsecase: getIt(),
    removeTaskAttachmentUsecase: getIt(),
  ),
);
  getIt.registerFactory<ProjectsBloc>(
    () => ProjectsBloc(
      getProjectsUseCase: getIt(),
      getProjectDetailUseCase: getIt(),
      createProjectUseCase: getIt(),
      updateProjectUseCase: getIt(),
      deleteProjectUseCase: getIt(),
      createMilestoneUseCase: getIt(),
      updateMilestoneUseCase: getIt(),
      deleteMilestoneUseCase: getIt(),
    ),
  );

  // ── Search Module ──────────────────────────────────────────────────────────
  getIt.registerLazySingleton<SearchRemoteDataSource>(
    () => SearchRemoteDataSourceImpl(apiClient: getIt()),
  );
  getIt.registerLazySingleton<SearchRepository>(
    () => SearchRepositoryImpl(remoteDataSource: getIt()),
  );
  getIt.registerLazySingleton(
    () => GlobalSearchUsecase(repository: getIt()),
  );
  getIt.registerFactory<SearchBloc>(
    () => SearchBloc(searchUsecase: getIt()),
  );

  // ── Resources Module ──────────────────────────────────────────────────────
  getIt.registerLazySingleton<ResourcesRemoteDataSource>(
    () => ResourcesRemoteDataSourceImpl(apiClient: getIt()),
  );
  getIt.registerLazySingleton<ResourcesRepository>(
    () => ResourcesRepositoryImpl(remoteDataSource: getIt()),
  );
  getIt.registerLazySingleton<GetFilesUsecase>(
    () => GetFilesUsecase(repository: getIt()),
  );
  getIt.registerLazySingleton<GetFileDetailUsecase>(
    () => GetFileDetailUsecase(repository: getIt()),
  );
  getIt.registerLazySingleton<CreateCollectionUsecase>(
    () => CreateCollectionUsecase(repository: getIt()),
  );
  getIt.registerLazySingleton<UpdateFileAccessUsecase>(
    () => UpdateFileAccessUsecase(repository: getIt()),
  );
  getIt.registerLazySingleton<DeleteFileUsecase>(
    () => DeleteFileUsecase(repository: getIt()),
  );
  getIt.registerFactory<ResourcesListBloc>(
    () => ResourcesListBloc(
      getFilesUsecase: getIt(),
      getFileDetailUsecase: getIt(),
      uploadFileUsecase: getIt(),
      updateFileAccessUsecase: getIt(),
      deleteFileUsecase: getIt(),
    ),
  );

  // ── Calendar Module ───────────────────────────────────────────────────────
  getIt.registerLazySingleton<CalendarRemoteDataSource>(
    () => CalendarRemoteDataSourceImpl(apiClient: getIt()),
  );
  getIt.registerLazySingleton<CalendarRepository>(
    () => CalendarRepositoryImpl(remoteDataSource: getIt()),
  );
  getIt.registerLazySingleton<GetPersonalCalendarUsecase>(
    () => GetPersonalCalendarUsecase(repository: getIt()),
  );
  getIt.registerLazySingleton<GetTeamCalendarUsecase>(
    () => GetTeamCalendarUsecase(repository: getIt()),
  );
  getIt.registerFactory<CalendarBloc>(
    () => CalendarBloc(
      getPersonalCalendarUsecase: getIt(),
      getTeamCalendarUsecase: getIt(),
    ),
  );

  // ── Research Module ────────────────────────────────────────────────────────
  getIt.registerLazySingleton<ResearchRemoteDataSource>(
    () => ResearchRemoteDataSourceImpl(apiClient: getIt()),
  );
  getIt.registerLazySingleton<ResearchRepository>(
    () => ResearchRepositoryImpl(remoteDataSource: getIt()),
  );
  getIt.registerLazySingleton<FetchResearchListUsecase>(
    () => FetchResearchListUsecase(repository: getIt()),
  );
  getIt.registerLazySingleton<GetResearchDetailUsecase>(
    () => GetResearchDetailUsecase(repository: getIt()),
  );
  getIt.registerLazySingleton<CreateResearchEntryUsecase>(
    () => CreateResearchEntryUsecase(repository: getIt()),
  );
  getIt.registerLazySingleton<UpdateResearchEntryUsecase>(
    () => UpdateResearchEntryUsecase(repository: getIt()),
  );
  getIt.registerLazySingleton<DeleteResearchEntryUsecase>(
    () => DeleteResearchEntryUsecase(repository: getIt()),
  );
  getIt.registerFactory<ResearchListBloc>(
    () => ResearchListBloc(fetchResearchListUsecase: getIt()),
  );
  getIt.registerFactory<ResearchDetailBloc>(
    () => ResearchDetailBloc(
      getResearchDetailUsecase: getIt(),
      createResearchEntryUsecase: getIt(),
      updateResearchEntryUsecase: getIt(),
      deleteResearchEntryUsecase: getIt(),
    ),
  );
}
