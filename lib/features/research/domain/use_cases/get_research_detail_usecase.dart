import 'package:fpdart/fpdart.dart';
import '../entities/research_entry_entity.dart';
import '../repositories/research_repository.dart';
import '../../../../globals/error_handling/error_model.dart';

class GetResearchDetailUsecase {
  final ResearchRepository repository;

  GetResearchDetailUsecase({required this.repository});

  Future<Either<ErrorModel, ResearchEntryEntity>> call(int id) {
    return repository.getEntry(id);
  }
}
