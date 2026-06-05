import 'package:fpdart/fpdart.dart';
import 'package:hackathon/features/resources/domain/entities/resource_file_entity.dart';
import 'package:hackathon/features/resources/domain/repositories/resources_repository.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';

class CreateCollectionUsecase {
  final ResourcesRepository repository;

  CreateCollectionUsecase({required this.repository});

  Future<Either<ErrorModel, ResourceCollection>> call({
    required String name,
    required String description,
    required List<CollectionField> fields,
    required String token,
  }) {
    return repository.createCollection(
      name: name,
      description: description,
      fields: fields,
      token: token,
    );
  }
}