import 'package:fpdart/fpdart.dart';
import 'package:hackathon/features/resources/domain/entities/resource_file_entity.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';

abstract class ResourcesRepository {
  Future<Either<ErrorModel, ResourceCollection>> createCollection({
    required String name,
    required String description,
    required List<CollectionField> fields,
    required String token,
  });

  Future<Either<ErrorModel, ResourceCollection>> getCollection({
    required int id,
    required String token,
  });

  Future<Either<ErrorModel, List<ResourceCollection>>> listCollections({
    required String token,
  });

  Future<Either<ErrorModel, ResourceCollection>> updateCollection({
    required int id,
    required String name,
    required String description,
    required String token,
  });

  Future<Either<ErrorModel, void>> deleteCollection({
    required int id,
    required String token,
  });

  Future<Either<ErrorModel, ResourceCollection>> addField({
    required int collectionId,
    required CollectionField field,
    required String token,
  });

  Future<Either<ErrorModel, ResourceCollection>> updateField({
    required int collectionId,
    required String key,
    required CollectionField field,
    required String token,
  });

  Future<Either<ErrorModel, ResourceCollection>> removeField({
    required int collectionId,
    required String key,
    required String token,
  });

  Future<Either<ErrorModel, ResourceRecord>> createRecord({
    required int collectionId,
    required Map<String, dynamic> data,
    required String token,
  });

  Future<Either<ErrorModel, ResourceRecord>> getRecord({
    required int collectionId,
    required int recordId,
    required String token,
  });

  Future<Either<ErrorModel, List<ResourceRecord>>> listRecords({
    required int collectionId,
    required String token,
  });

  Future<Either<ErrorModel, ResourceRecord>> updateRecord({
    required int collectionId,
    required int recordId,
    required Map<String, dynamic> data,
    required String token,
  });

  Future<Either<ErrorModel, void>> deleteRecord({
    required int collectionId,
    required int recordId,
    required String token,
  });

  Future<Either<ErrorModel, List<ResourceRecord>>> bulkCreate({
    required int collectionId,
    required List<Map<String, dynamic>> records,
    required String token,
  });
}