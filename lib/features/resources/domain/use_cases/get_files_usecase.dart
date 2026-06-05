import 'package:fpdart/fpdart.dart';
import 'package:hackathon/features/resources/domain/entities/resource_file_entity.dart';
import 'package:hackathon/features/resources/domain/repositories/resources_repository.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';

class GetFilesUsecase {
  final ResourcesRepository repository;

  GetFilesUsecase({required this.repository});

  Future<Either<ErrorModel, List<ResourceCollection>>> call({required String token}) {
    return repository.listCollections(token: token);
  }
}