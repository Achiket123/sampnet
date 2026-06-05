import 'package:fpdart/fpdart.dart';
import '../repositories/research_repository.dart';
import '../../../../globals/error_handling/error_model.dart';

class DeleteResearchEntryUsecase {
  final ResearchRepository repository;

  DeleteResearchEntryUsecase({required this.repository});

  Future<Either<ErrorModel, void>> call(int id) {
    return repository.deleteEntry(id);
  }
}
