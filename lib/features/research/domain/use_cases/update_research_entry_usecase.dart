import 'package:fpdart/fpdart.dart';
import '../entities/research_entry_entity.dart';
import '../repositories/research_repository.dart';
import '../../../../globals/error_handling/error_model.dart';

class UpdateResearchEntryUsecase {
  final ResearchRepository repository;

  UpdateResearchEntryUsecase({required this.repository});

  Future<Either<ErrorModel, void>> call(ResearchEntryEntity entry) {
    return repository.updateEntry(entry);
  }
}
