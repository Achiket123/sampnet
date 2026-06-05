import 'package:fpdart/fpdart.dart';
import 'package:hackathon/features/resources/domain/repositories/resources_repository.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';

class DeleteFileUsecase {
  final ResourcesRepository repository;

  DeleteFileUsecase({required this.repository});

  Future<Either<ErrorModel, void>> deleteCollection({
    required int id,
    required String token,
  }) {
    return repository.deleteCollection(id: id, token: token);
  }

  Future<Either<ErrorModel, void>> deleteRecord({
    required int collectionId,
    required int recordId,
    required String token,
  }) {
    return repository.deleteRecord(collectionId: collectionId, recordId: recordId, token: token);
  }
}