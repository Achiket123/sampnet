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
import 'features/team/data/repo/team_project_repo_impl.dart';

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
    () => TaskCommentRemoteDataSource(apiClient: getIt()),
  );
  getIt.registerLazySingleton<TaskAttachmentRemoteDataSource>(
    () => TaskAttachmentRemoteDataSource(apiClient: getIt()),
  );
  getIt.registerLazySingleton<ChatDataSource>(
      () => ChatDataSourceImpl(apiClient: getIt()));

  getIt.registerLazySingleton<MessageDataSource>(
      () => MessageDataSourceImpl(apiClient: getIt()));

  getIt.registerLazySingleton<TeamDataSource>(
      () => TeamDataSourceImpl(client: getIt()));

  getIt.registerLazySingleton<TeamProjectDataSource>(
      () => TeamProjectDataSourceImpl(getIt()));

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
  getIt.registerLazySingleton<ChatRepository>(
      () => ChatRepositoryImpl(dataSource: getIt()));

  getIt.registerLazySingleton<MessageRepository>(
      () => MessageRepositoryImpl(messageDataSource: getIt()));

  getIt.registerLazySingleton<TaskTeamRepository>(
      () => TaskTeamRepositoryImpl(dataSource: getIt()));

  getIt.registerLazySingleton<TeamProjectRepo>(
      () => TeamProjectRepoImpl(getIt()));

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
}
