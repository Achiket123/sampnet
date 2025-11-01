import 'package:fpdart/fpdart.dart';
import 'package:hackathon/globals/constants/usecase.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';
import 'package:hackathon/features/tasks/domain/entities/task_entity.dart';
import 'package:hackathon/features/tasks/domain/repositories/task_repository.dart';

class FetchTaskUsecase implements Usecase<List<TaskEntity>, String> {
  final FetchTaskRepository repository;
  FetchTaskUsecase(this.repository);
  @override
  Future<Either<ErrorModel, List<TaskEntity>>> call(String params) async =>
      repository.fetchTasks(params);
}

class FetchTaskByIdUsecase implements Usecase<TaskEntity, FetchTaskByIdParams> {
  final FetchTaskRepository repository;
  FetchTaskByIdUsecase(this.repository);
  @override
  Future<Either<ErrorModel, TaskEntity>> call(
          FetchTaskByIdParams params) async =>
      repository.fetchTaskById(params.token, params.id);
}

class FetchTaskByOrganisationIdUsecase
    implements Usecase<List<TaskEntity>, FetchTaskByOrganisationIdParams> {
  final FetchTaskRepository repository;
  FetchTaskByOrganisationIdUsecase(this.repository);
  @override
  Future<Either<ErrorModel, List<TaskEntity>>> call(
          FetchTaskByOrganisationIdParams params) async =>
      repository.fetchTasksByOrganisationId(
          params.token, params.organisationId);
}

class FetchTaskByIdParams {
  final String token;
  final String id;
  FetchTaskByIdParams(this.token, this.id);
}

class FetchTaskByOrganisationIdParams {
  final String token;
  final String organisationId;
  FetchTaskByOrganisationIdParams(this.token, this.organisationId);
}
