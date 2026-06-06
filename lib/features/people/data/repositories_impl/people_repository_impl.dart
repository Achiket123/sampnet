import 'package:fpdart/fpdart.dart';
import '../../../../globals/error_handling/error_model.dart';
import '../../domain/entities/people_entities.dart';
import '../../domain/use_cases/people_usecases.dart';
import '../data_sources/people_remote_data_source.dart';


class PeopleRepositoryImpl implements PeopleRepository {
  final PeopleRemoteDataSource remoteDataSource;

  PeopleRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<ErrorModel, List<PeopleContactEntity>>> getContacts(
      {int? stageId, int? listId, String? search}) async {
    try {
      final models = await remoteDataSource.getContacts(
          stageId: stageId, listId: listId, search: search);
      return Right(models);
    } catch (e) {
      return Left(ServerError(message: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, PeopleContactEntity>> getContactDetails(int id) async {
    try {
      final model = await remoteDataSource.getContactDetails(id);
      return Right(model);
    } catch (e) {
      return Left(ServerError(message: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, PeopleContactEntity>> createContact(PeopleContactEntity contact) async {
    try {
      // Need to cast or construct model from entity. We assume the entity is already a model,
      // or we construct a new model. Since models implement entities and we just pass the object directly,
      // Dart requires a cast or manual conversion.
      final model = await remoteDataSource.createContact(contact as dynamic);
      return Right(model);
    } catch (e) {
      return Left(ServerError(message: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, PeopleContactEntity>> updateContact(PeopleContactEntity contact) async {
    try {
      final model = await remoteDataSource.updateContact(contact as dynamic);
      return Right(model);
    } catch (e) {
      return Left(ServerError(message: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, void>> deleteContact(int id) async {
    try {
      await remoteDataSource.deleteContact(id);
      return const Right(null);
    } catch (e) {
      return Left(ServerError(message: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, List<PeopleInteractionEntity>>> getInteractions(int contactId) async {
    try {
      final models = await remoteDataSource.getInteractions(contactId);
      return Right(models);
    } catch (e) {
      return Left(ServerError(message: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, PeopleInteractionEntity>> createInteraction(
      PeopleInteractionEntity interaction) async {
    try {
      final model = await remoteDataSource.createInteraction(interaction as dynamic);
      return Right(model);
    } catch (e) {
      return Left(ServerError(message: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, List<PipelineStageEntity>>> getPipelineStages() async {
    try {
      final models = await remoteDataSource.getPipelineStages();
      return Right(models);
    } catch (e) {
      return Left(ServerError(message: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, PipelineStageEntity>> createPipelineStage(PipelineStageEntity stage) async {
    try {
      final model = await remoteDataSource.createPipelineStage(stage as dynamic);
      return Right(model);
    } catch (e) {
      return Left(ServerError(message: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, PipelineStageEntity>> updatePipelineStage(PipelineStageEntity stage) async {
    try {
      final model = await remoteDataSource.updatePipelineStage(stage as dynamic);
      return Right(model);
    } catch (e) {
      return Left(ServerError(message: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, List<PeopleListEntity>>> getLists() async {
    try {
      final models = await remoteDataSource.getLists();
      return Right(models);
    } catch (e) {
      return Left(ServerError(message: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, PeopleListEntity>> createList(PeopleListEntity list) async {
    try {
      final model = await remoteDataSource.createList(list as dynamic);
      return Right(model);
    } catch (e) {
      return Left(ServerError(message: e.toString()));
    }
  }
}
