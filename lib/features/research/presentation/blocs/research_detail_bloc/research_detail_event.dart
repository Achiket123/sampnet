part of 'research_detail_bloc.dart';

abstract class ResearchDetailEvent extends Equatable {
  const ResearchDetailEvent();

  @override
  List<Object?> get props => [];
}

class GetResearchDetail extends ResearchDetailEvent {
  final int id;
  const GetResearchDetail({required this.id});

  @override
  List<Object?> get props => [id];
}

class CreateResearchEntry extends ResearchDetailEvent {
  final ResearchEntryEntity entry;
  const CreateResearchEntry({required this.entry});

  @override
  List<Object?> get props => [entry];
}

class UpdateResearchEntry extends ResearchDetailEvent {
  final ResearchEntryEntity entry;
  const UpdateResearchEntry({required this.entry});

  @override
  List<Object?> get props => [entry];
}

class DeleteResearchEntry extends ResearchDetailEvent {
  final int id;
  const DeleteResearchEntry({required this.id});

  @override
  List<Object?> get props => [id];
}
