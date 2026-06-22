// This file contains the main application widget and its dependencies
// It also initializes the Hive Flutter database and the Appwrite client
// The main entry point of the application.
// This file initializes the Hive database for local storage and the Appwrite
// client for cloud storage. It also initializes the app's routes and BLoC
// providers.

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hackathon/dependency_injection.g.dart';
import 'package:hackathon/features/attendence/domain/use_cases/attendence_usecase.dart';
import 'package:hackathon/features/attendence/presentation/blocs/bloc/attendence_bloc.dart';
import 'package:hackathon/features/auth/domain/usecase/auth_usecase.dart';
import 'package:hackathon/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:hackathon/features/chats/domain/use_cases/chat_usecase.dart';
import 'package:hackathon/features/chats/domain/use_cases/message_usecase.dart';
import 'package:hackathon/features/chats/presentation/blocs/chat_bloc/chat_bloc_bloc.dart';
import 'package:hackathon/features/chats/presentation/blocs/message_bloc/message_bloc.dart';
import 'package:hackathon/features/company/domain/use_cases/register_company_usecase.dart';
import 'package:hackathon/features/company/presentation/blocs/register%20comapny%20bloc/register_company_bloc.dart';
import 'package:hackathon/features/dashboards/domain/use_cases/validate_emp_usecase.dart';
import 'package:hackathon/features/dashboards/presentation/blocs/bloc/validate_employee_bloc.dart';
import 'package:hackathon/features/tasks/domain/use_cases/create_task_usecase.dart';
import 'package:hackathon/features/tasks/domain/use_cases/fetch_task_usecase.dart';
import 'package:hackathon/features/tasks/domain/use_cases/get_emp_usecase.dart';
import 'package:hackathon/features/tasks/domain/use_cases/get_project_usecase.dart';
import 'package:hackathon/features/tasks/domain/use_cases/task_get_team_usecase.dart';
import 'package:hackathon/features/tasks/domain/use_cases/update_task_usecase.dart';
import 'package:hackathon/features/tasks/presentation/blocs/create_task_bloc/create_task_bloc.dart';
import 'package:hackathon/features/tasks/presentation/blocs/get_emp_bloc/get_employees_bloc.dart';
import 'package:hackathon/features/tasks/presentation/blocs/get_project_bloc/get_project_bloc.dart';
import 'package:hackathon/features/tasks/presentation/blocs/task_bloc/task_bloc.dart';
import 'package:hackathon/features/team/domain/usecases/create_team_usecase.dart';
import 'package:hackathon/features/team/domain/usecases/get_team_usecase.dart';
import 'package:hackathon/features/team/domain/usecases/team_get_project_usecase.dart';
import 'package:hackathon/features/team/presentation/blocs/project_bloc/project_bloc.dart';
import 'package:hackathon/features/team/presentation/blocs/team_bloc/team_bloc.dart';
import 'package:hackathon/features/team/presentation/blocs/team_id_bloc/teamid_bloc.dart';
import 'package:hackathon/features/upload_files/domain/use_cases/upload_file_usecase.dart';
import 'package:hackathon/features/upload_files/presentation/bloc/upload_file_bloc.dart';
import 'package:hackathon/features/notifications/presentation/blocs/notifications_bloc/notifications_bloc.dart';
import 'package:hackathon/firebase_options.dart';
//hello world how are you?? I am doing great what about you??
import 'package:hackathon/globals/constants/globals.dart';
import 'package:hackathon/globals/constants/strings.dart';
import 'package:hackathon/globals/constants/styles.dart';
import 'package:hackathon/globals/constants/color_pallete.dart';
import 'package:hackathon/services/routes.dart';
import 'package:hackathon/features/chats/data/models/message_hive_model.dart';
import 'package:hackathon/features/chats/data/models/chat_hive_model.dart';
import 'package:hackathon/features/chats/data/models/chat_participant_hive_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart';

// The main application widget
main() async {
  // Load the .env file
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize the Hive Flutter database
  await Hive.initFlutter();

  // Register Hive adapters
  Hive.registerAdapter(MessageHiveModelAdapter());
  Hive.registerAdapter(ChatHiveModelAdapter());
  Hive.registerAdapter(ChatParticipantHiveModelAdapter());

  await Hive.openBox(Strings.authBox);
  await Hive.openBox<MessageHiveModel>('messages');
  await Hive.openBox<ChatHiveModel>('chats');
  await Hive.openBox<String>('chat_cursors');

  // Initialize the dependencies
  initDependencies();

  // Run the application
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Return the main application widget
    return MultiBlocProvider(
      providers: [
        // The auth bloc
        BlocProvider(
          create: (context) => AuthBloc(
            saveTokenUsecase: getIt<SaveTokenUsecase>(),
            signUpUsecase: getIt<SignUpUsecase>(),
            getTokenUsecase: getIt<GetTokenUsecase>(),
            signInUsecase: getIt<SignInUsecase>(),
            sendVerificationEmailUsecase: getIt<SendVerificationEmailUsecase>(),
            verifyEmailUsecase: getIt<VerifyEmailUsecase>(),
            getMeUsecase: getIt<GetMeUsecase>(),
          ),
        ),
        // The upload file bloc
        BlocProvider(
          create: (context) => UploadFileBloc(
            uploadFileUsecase: getIt<UploadFileUsecase>(),
          ),
        ),
        // The register company bloc
        BlocProvider(
          create: (context) => RegisterCompanyBloc(
            fetchEmployeeDataUseCase: getIt<FetchEmployeeDataUseCase>(),
            registerCompanyUseCase: getIt<RegisterCompanyUseCase>(),
          ),
        ),
        // The attendence bloc
        BlocProvider(
          create: (context) => AttendenceBloc(
            attendenceGetUsecase: getIt<AttendenceGetUsecase>(),
            attendenceCheckInUsecase: getIt<AttendenceCheckInUsecase>(),
            attendenceCheckOutUsecase: getIt<AttendenceCheckOutUsecase>(),
          ),
        ),
        // The get employees bloc
        BlocProvider(
          create: (context) => GetEmployeesBloc(
            getProjectUseCase: getIt<GetProjectUseCase>(),
            getTeamUseCase: getIt<TaskGetTeamUsecase>(),
            getEmployeesUseCase: getIt<GetEmployeesUseCase>(),
          ),
        ),

        // The validate employee bloc
        BlocProvider(
          create: (context) => ValidateEmployeeBloc(
            usecase: getIt<ValidateEmpUsecase>(),
          ),
        ),
        // The get project bloc
        BlocProvider(
          create: (context) => GetProjectBloc(
            getProjectUseCase: getIt<GetProjectUseCase>(),
          ),
        ),
        // The create task bloc
        BlocProvider(
          create: (context) => CreateTaskBloc(
            createTaskUsecase: getIt<CreateTaskUseCase>(),
          ),
        ),
        // The task bloc
        BlocProvider(
          create: (context) => TaskBloc(
            updateTaskUsecase: getIt<UpdateTaskUsecase>(),
            fetchTasksUsecase: getIt<FetchTaskUsecase>(),
          ),
        ),
        // The chat bloc
        BlocProvider(
          create: (context) => ChatBlocBloc(
            usecase: getIt<StreamChatUsecase>(),
            createChatUsecase: getIt<CreateChatUsecase>(),
            getChatUsecase: getIt<GetChatUsecase>(),
          ),
        ),
        //Message Bloc
        BlocProvider(
            create: (context) => MessageBloc(
                  messageUseCase: getIt<MessageUsecase>(),
                )),

        BlocProvider(
            create: (context) => ProjectBloc(
                  teamGetProjectUsecase: getIt<TeamGetProjectUsecase>(),
                )),
        BlocProvider(
          create: (context) => TeamBloc(
            createTeamUsecase: getIt<CreateTeamUsecase>(),
            getTeamUseCase: getIt<GetTeamUseCase>(),
          ),
        ),
        BlocProvider(
            create: (context) => TeamidBloc(getTeamByIdUseCase: getIt())),
        BlocProvider(
          create: (context) => getIt<NotificationsBloc>(),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: route,
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: ColorPallete.backgroundPrimary,
          primaryColor: ColorPallete.redPrimary,
          colorScheme: const ColorScheme.dark(
            primary: ColorPallete.redPrimary,
            onPrimary: ColorPallete.textPrimary,
            secondary: ColorPallete.redDark,
            onSecondary: ColorPallete.textPrimary,
            surface: ColorPallete.backgroundSecondary,
            onSurface: ColorPallete.textPrimary,
            error: ColorPallete.redPrimary,
            onError: ColorPallete.textPrimary,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: ColorPallete.backgroundPrimary,
            foregroundColor: ColorPallete.textPrimary,
            elevation: 0,
            iconTheme: IconThemeData(color: ColorPallete.textPrimary),
          ),
          cardTheme: CardThemeData(
            color: ColorPallete.backgroundSecondary,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          inputDecorationTheme: inputDecorationTheme,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorPallete.redPrimary,
              foregroundColor: ColorPallete.textPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ).copyWith(
              overlayColor: WidgetStateProperty.resolveWith<Color?>(
                (Set<WidgetState> states) {
                  if (states.contains(WidgetState.pressed))
                    return ColorPallete.redDark;
                  return null;
                },
              ),
            ),
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: ColorPallete.redPrimary,
            ),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              foregroundColor: ColorPallete.redPrimary,
              side: const BorderSide(color: ColorPallete.redPrimary),
            ),
          ),
          iconTheme: const IconThemeData(color: ColorPallete.textPrimary),
          dividerTheme: const DividerThemeData(
            color: ColorPallete.divider,
            thickness: 1,
          ),
          checkboxTheme: CheckboxThemeData(
            fillColor: WidgetStateProperty.resolveWith<Color?>(
              (Set<WidgetState> states) {
                if (states.contains(WidgetState.selected)) {
                  return ColorPallete.redPrimary;
                }
                return null;
              },
            ),
          ),
          radioTheme: RadioThemeData(
            fillColor: WidgetStateProperty.resolveWith<Color?>(
              (Set<WidgetState> states) {
                if (states.contains(WidgetState.selected)) {
                  return ColorPallete.redPrimary;
                }
                return null;
              },
            ),
          ),
          switchTheme: SwitchThemeData(
            trackColor: WidgetStateProperty.resolveWith<Color?>(
              (Set<WidgetState> states) {
                if (states.contains(WidgetState.selected)) {
                  return ColorPallete.redPrimary;
                }
                return null;
              },
            ),
            thumbColor: WidgetStateProperty.resolveWith<Color?>(
              (Set<WidgetState> states) {
                if (states.contains(WidgetState.selected)) {
                  return ColorPallete.redPrimary;
                }
                return null;
              },
            ),
          ),
          progressIndicatorTheme: const ProgressIndicatorThemeData(
            color: ColorPallete.redPrimary,
          ),
          snackBarTheme: const SnackBarThemeData(
            backgroundColor: ColorPallete.backgroundTertiary,
            contentTextStyle: TextStyle(color: ColorPallete.textPrimary),
          ),
          dialogTheme: const DialogThemeData(
            backgroundColor: ColorPallete.backgroundTertiary,
            titleTextStyle: TextStyle(
                color: ColorPallete.textPrimary, fontWeight: FontWeight.bold),
          ),
          bottomSheetTheme: const BottomSheetThemeData(
            backgroundColor: ColorPallete.backgroundTertiary,
          ),
          tabBarTheme: const TabBarThemeData(
            labelColor: ColorPallete.redPrimary,
            unselectedLabelColor: ColorPallete.textSecondary,
            indicator: UnderlineTabIndicator(
              borderSide: BorderSide(color: ColorPallete.redPrimary),
            ),
          ),
          chipTheme: const ChipThemeData(
            backgroundColor: ColorPallete.backgroundTertiary,
            selectedColor: ColorPallete.redSubtle,
            labelStyle: TextStyle(color: ColorPallete.textPrimary),
            secondaryLabelStyle: TextStyle(color: ColorPallete.redPrimary),
          ),
          listTileTheme: const ListTileThemeData(
            tileColor: ColorPallete.transparent,
            selectedTileColor: ColorPallete.redSubtle,
            selectedColor: ColorPallete.redPrimary,
            iconColor: ColorPallete.textSecondary,
            textColor: ColorPallete.textPrimary,
          ),
          textTheme: textTheme,
        ),
      ),
    );
  }
}
