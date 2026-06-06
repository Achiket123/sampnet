import re

with open("lib/dependency_injection.g.dart", "r") as f:
    content = f.read()

# Add imports
imports = """
// People CRM Module Imports
import 'package:hackathon/features/people/data/data_sources/people_remote_data_source.dart';
import 'package:hackathon/features/people/data/repositories_impl/people_repository_impl.dart';
import 'package:hackathon/features/people/domain/use_cases/people_usecases.dart';
import 'package:hackathon/features/people/presentation/blocs/people_list_bloc/people_list_bloc.dart';
import 'package:hackathon/features/people/presentation/blocs/contact_detail_bloc/contact_detail_bloc.dart';
"""
if "PeopleRemoteDataSource" not in content:
    content = content.replace("final getIt = GetIt.instance;", imports + "\nfinal getIt = GetIt.instance;")

# Add DataSource
ds = """  getIt.registerLazySingleton<PeopleRemoteDataSource>(
    () => PeopleRemoteDataSourceImpl(apiClient: getIt()),
  );
"""
if "PeopleRemoteDataSourceImpl" not in content:
    content = content.replace("// Repositories", ds + "\n  // Repositories")

# Add Repository
repo = """  getIt.registerLazySingleton<PeopleRepository>(
    () => PeopleRepositoryImpl(remoteDataSource: getIt()),
  );
"""
if "PeopleRepositoryImpl" not in content:
    content = content.replace("// Use Cases", repo + "\n  // Use Cases")

# Add Usecases
uc = """  getIt.registerLazySingleton<GetContactsUseCase>(() => GetContactsUseCase(getIt()));
  getIt.registerLazySingleton<GetContactDetailsUseCase>(() => GetContactDetailsUseCase(getIt()));
  getIt.registerLazySingleton<CreateContactUseCase>(() => CreateContactUseCase(getIt()));
  getIt.registerLazySingleton<UpdateContactUseCase>(() => UpdateContactUseCase(getIt()));
  getIt.registerLazySingleton<DeleteContactUseCase>(() => DeleteContactUseCase(getIt()));
  getIt.registerLazySingleton<GetInteractionsUseCase>(() => GetInteractionsUseCase(getIt()));
  getIt.registerLazySingleton<CreateInteractionUseCase>(() => CreateInteractionUseCase(getIt()));
  getIt.registerLazySingleton<GetPipelineStagesUseCase>(() => GetPipelineStagesUseCase(getIt()));
  getIt.registerLazySingleton<CreatePipelineStageUseCase>(() => CreatePipelineStageUseCase(getIt()));
  getIt.registerLazySingleton<UpdatePipelineStageUseCase>(() => UpdatePipelineStageUseCase(getIt()));
  getIt.registerLazySingleton<GetListsUseCase>(() => GetListsUseCase(getIt()));
  getIt.registerLazySingleton<CreateListUseCase>(() => CreateListUseCase(getIt()));
"""
if "GetContactsUseCase" not in content:
    content = content.replace("// Blocs", uc + "\n  // Blocs")

# Add Blocs
bloc = """  getIt.registerFactory<PeopleListBloc>(() => PeopleListBloc(
        getContactsUseCase: getIt(),
        deleteContactUseCase: getIt(),
      ));
  getIt.registerFactory<ContactDetailBloc>(() => ContactDetailBloc(
        getContactDetailsUseCase: getIt(),
        getInteractionsUseCase: getIt(),
        createInteractionUseCase: getIt(),
        updateContactUseCase: getIt(),
      ));
"""
if "PeopleListBloc" not in content:
    content = content.replace("}\n", bloc + "}\n")

with open("lib/dependency_injection.g.dart", "w") as f:
    f.write(content)
