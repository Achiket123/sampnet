import 'package:fpdart/fpdart.dart';
import 'package:hackathon/features/resources/domain/entities/resource_file_entity.dart';
import 'package:hackathon/features/resources/domain/repositories/resources_repository.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';

class GetFileDetailUsecase {
  final ResourcesRepository repository;

  GetFileDetailUsecase({required this.repository});

  Future<Either<ErrorModel, List<ResourceRecord>>> call({
    required int collectionId,
    required String token,
  }) {
    return repository.listRecords(collectionId: collectionId, token: token);
  }
}