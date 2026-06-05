import 'package:fpdart/fpdart.dart';
import 'package:hackathon/features/resources/data/data_sources/resources_remote_data_source.dart';
import 'package:hackathon/features/resources/domain/entities/resource_file_entity.dart';
import 'package:hackathon/features/resources/domain/repositories/resources_repository.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';

class ResourcesRepositoryImpl implements ResourcesRepository {
  final ResourcesRemoteDataSource remoteDataSource;

  ResourcesRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<ErrorModel, ResourceCollection>> createCollection({
    required String name,
    required String description,
    required List<CollectionField> fields,
    required String token,
  }) async {
    try {
      final fieldsJson = fields.map((e) => e.toJson()).toList();
      final collection = await remoteDataSource.createCollection(
        name: name,
        description: description,
        fields: fieldsJson,
      );
      return Right(collection);
    } catch (e) {
      return Left(ServerError(message: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, ResourceCollection>> getCollection({
    required int id,
    required String token,
  }) async {
    try {
      final collection = await remoteDataSource.getCollection(id: id);
      return Right(collection);
    } catch (e) {
      return Left(ServerError(message: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, List<ResourceCollection>>> listCollections({
    required String token,
  }) async {
    try {
      final collections = await remoteDataSource.listCollections();
      return Right(collections);
    } catch (e) {
      return Left(ServerError(message: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, ResourceCollection>> updateCollection({
    required int id,
    required String name,
    required String description,
    required String token,
  }) async {
    try {
      final collection = await remoteDataSource.updateCollection(
        id: id,
        name: name,
        description: description,
      );
      return Right(collection);
    } catch (e) {
      return Left(ServerError(message: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, void>> deleteCollection({
    required int id,
    required String token,
  }) async {
    try {
      await remoteDataSource.deleteCollection(id: id);
      return const Right(null);
    } catch (e) {
      return Left(ServerError(message: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, ResourceCollection>> addField({
    required int collectionId,
    required CollectionField field,
    required String token,
  }) async {
    try {
      final collection = await remoteDataSource.addField(
        collectionId: collectionId,
        field: field.toJson(),
      );
      return Right(collection);
    } catch (e) {
      return Left(ServerError(message: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, ResourceCollection>> updateField({
    required int collectionId,
    required String key,
    required CollectionField field,
    required String token,
  }) async {
    try {
      final collection = await remoteDataSource.updateField(
        collectionId: collectionId,
        key: key,
        field: field.toJson(),
      );
      return Right(collection);
    } catch (e) {
      return Left(ServerError(message: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, ResourceCollection>> removeField({
    required int collectionId,
    required String key,
    required String token,
  }) async {
    try {
      final collection = await remoteDataSource.removeField(
        collectionId: collectionId,
        key: key,
      );
      return Right(collection);
    } catch (e) {
      return Left(ServerError(message: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, ResourceRecord>> createRecord({
    required int collectionId,
    required Map<String, dynamic> data,
    required String token,
  }) async {
    try {
      final record = await remoteDataSource.createRecord(
        collectionId: collectionId,
        data: data,
      );
      return Right(record);
    } catch (e) {
      return Left(ServerError(message: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, ResourceRecord>> getRecord({
    required int collectionId,
    required int recordId,
    required String token,
  }) async {
    try {
      final record = await remoteDataSource.getRecord(
        collectionId: collectionId,
        recordId: recordId,
      );
      return Right(record);
    } catch (e) {
      return Left(ServerError(message: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, List<ResourceRecord>>> listRecords({
    required int collectionId,
    required String token,
  }) async {
    try {
      final records = await remoteDataSource.listRecords(collectionId: collectionId);
      return Right(records);
    } catch (e) {
      return Left(ServerError(message: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, ResourceRecord>> updateRecord({
    required int collectionId,
    required int recordId,
    required Map<String, dynamic> data,
    required String token,
  }) async {
    try {
      final record = await remoteDataSource.updateRecord(
        collectionId: collectionId,
        recordId: recordId,
        data: data,
      );
      return Right(record);
    } catch (e) {
      return Left(ServerError(message: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, void>> deleteRecord({
    required int collectionId,
    required int recordId,
    required String token,
  }) async {
    try {
      await remoteDataSource.deleteRecord(
        collectionId: collectionId,
        recordId: recordId,
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerError(message: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, List<ResourceRecord>>> bulkCreate({
    required int collectionId,
    required List<Map<String, dynamic>> records,
    required String token,
  }) async {
    try {
      final results = await remoteDataSource.bulkCreate(
        collectionId: collectionId,
        records: records,
      );
      return Right(results);
    } catch (e) {
      return Left(ServerError(message: e.toString()));
    }
  }
}