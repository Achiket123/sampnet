import 'package:fpdart/fpdart.dart';
import '../../../../globals/error_handling/error_model.dart';
import '../entities/people_entities.dart';


abstract class PeopleRepository {
  Future<Either<ErrorModel, List<PeopleContactEntity>>> getContacts(
      {int? stageId, int? listId, String? search});
  Future<Either<ErrorModel, PeopleContactEntity>> getContactDetails(int id);
  Future<Either<ErrorModel, PeopleContactEntity>> createContact(PeopleContactEntity contact);
  Future<Either<ErrorModel, PeopleContactEntity>> updateContact(PeopleContactEntity contact);
  Future<Either<ErrorModel, void>> deleteContact(int id);

  Future<Either<ErrorModel, List<PeopleInteractionEntity>>> getInteractions(int contactId);
  Future<Either<ErrorModel, PeopleInteractionEntity>> createInteraction(
      PeopleInteractionEntity interaction);

  Future<Either<ErrorModel, List<PipelineStageEntity>>> getPipelineStages();
  Future<Either<ErrorModel, PipelineStageEntity>> createPipelineStage(PipelineStageEntity stage);
  Future<Either<ErrorModel, PipelineStageEntity>> updatePipelineStage(PipelineStageEntity stage);

  Future<Either<ErrorModel, List<PeopleListEntity>>> getLists();
  Future<Either<ErrorModel, PeopleListEntity>> createList(PeopleListEntity list);
}

class GetContactsUseCase {
  final PeopleRepository repository;
  GetContactsUseCase(this.repository);

  Future<Either<ErrorModel, List<PeopleContactEntity>>> call(
      {int? stageId, int? listId, String? search}) {
    return repository.getContacts(stageId: stageId, listId: listId, search: search);
  }
}

class GetContactDetailsUseCase {
  final PeopleRepository repository;
  GetContactDetailsUseCase(this.repository);

  Future<Either<ErrorModel, PeopleContactEntity>> call(int id) {
    return repository.getContactDetails(id);
  }
}

class CreateContactUseCase {
  final PeopleRepository repository;
  CreateContactUseCase(this.repository);

  Future<Either<ErrorModel, PeopleContactEntity>> call(PeopleContactEntity contact) {
    return repository.createContact(contact);
  }
}

class UpdateContactUseCase {
  final PeopleRepository repository;
  UpdateContactUseCase(this.repository);

  Future<Either<ErrorModel, PeopleContactEntity>> call(PeopleContactEntity contact) {
    return repository.updateContact(contact);
  }
}

class DeleteContactUseCase {
  final PeopleRepository repository;
  DeleteContactUseCase(this.repository);

  Future<Either<ErrorModel, void>> call(int id) {
    return repository.deleteContact(id);
  }
}

class GetInteractionsUseCase {
  final PeopleRepository repository;
  GetInteractionsUseCase(this.repository);

  Future<Either<ErrorModel, List<PeopleInteractionEntity>>> call(int contactId) {
    return repository.getInteractions(contactId);
  }
}

class CreateInteractionUseCase {
  final PeopleRepository repository;
  CreateInteractionUseCase(this.repository);

  Future<Either<ErrorModel, PeopleInteractionEntity>> call(PeopleInteractionEntity interaction) {
    return repository.createInteraction(interaction);
  }
}

class GetPipelineStagesUseCase {
  final PeopleRepository repository;
  GetPipelineStagesUseCase(this.repository);

  Future<Either<ErrorModel, List<PipelineStageEntity>>> call() {
    return repository.getPipelineStages();
  }
}

class CreatePipelineStageUseCase {
  final PeopleRepository repository;
  CreatePipelineStageUseCase(this.repository);

  Future<Either<ErrorModel, PipelineStageEntity>> call(PipelineStageEntity stage) {
    return repository.createPipelineStage(stage);
  }
}

class UpdatePipelineStageUseCase {
  final PeopleRepository repository;
  UpdatePipelineStageUseCase(this.repository);

  Future<Either<ErrorModel, PipelineStageEntity>> call(PipelineStageEntity stage) {
    return repository.updatePipelineStage(stage);
  }
}

class GetListsUseCase {
  final PeopleRepository repository;
  GetListsUseCase(this.repository);

  Future<Either<ErrorModel, List<PeopleListEntity>>> call() {
    return repository.getLists();
  }
}

class CreateListUseCase {
  final PeopleRepository repository;
  CreateListUseCase(this.repository);

  Future<Either<ErrorModel, PeopleListEntity>> call(PeopleListEntity list) {
    return repository.createList(list);
  }
}
