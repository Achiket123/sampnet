import '../../domain/entities/research_reference_entity.dart';

class ResearchReferenceModel extends ResearchReferenceEntity {
  const ResearchReferenceModel({
    required super.id,
    required super.researchId,
    super.documentId,
    required super.title,
    super.authors,
    super.url,
  });

  factory ResearchReferenceModel.fromJson(Map<String, dynamic> json) {
    return ResearchReferenceModel(
      id: json['id'],
      researchId: json['research_id'],
      documentId: json['document_id'],
      title: json['title'],
      authors: json['authors'],
      url: json['url'],
    );
  }
}
