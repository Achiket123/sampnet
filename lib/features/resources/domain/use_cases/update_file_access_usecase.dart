import 'package:fpdart/fpdart.dart';
import 'package:hackathon/features/resources/domain/entities/resource_file_entity.dart';
import 'package:hackathon/features/resources/domain/repositories/resources_repository.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';

class UpdateFileAccessUsecase {
  final ResourcesRepository repository;

  UpdateFileAccessUsecase({required this.repository});

  Future<Either<ErrorModel, ResourceRecord>> createRecord({
    required int collectionId,
    required Map<String, dynamic> data,
    required String token,
  }) {
    return repository.createRecord(collectionId: collectionId, data: data, token: token);
  }

  Future<Either<ErrorModel, ResourceRecord>> updateRecord({
    required int collectionId,
    required int recordId,
    required Map<String, dynamic> data,
    required String token,
  }) {
    return repository.updateRecord(collectionId: collectionId, recordId: recordId, data: data, token: token);
  }

  Future<Either<ErrorModel, ResourceCollection>> updateCollection({
    required int id,
    required String name,
    required String description,
    required String token,
  }) {
    return repository.updateCollection(id: id, name: name, description: description, token: token);
  }
}