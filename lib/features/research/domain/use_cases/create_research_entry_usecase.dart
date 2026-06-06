import 'package:fpdart/fpdart.dart';
import '../entities/research_entry_entity.dart';
import '../repositories/research_repository.dart';
import '../../../../globals/error_handling/error_model.dart';

class CreateResearchEntryUsecase {
  final ResearchRepository repository;

  CreateResearchEntryUsecase({required this.repository});

  Future<Either<ErrorModel, ResearchEntryEntity>> call(
      ResearchEntryEntity entry) {
    return repository.createEntry(entry);
  }
}
