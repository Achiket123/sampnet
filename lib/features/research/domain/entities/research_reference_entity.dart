import 'package:equatable/equatable.dart';

class ResearchReferenceEntity extends Equatable {
  final int id;
  final int researchId;
  final int? documentId;
  final String title;
  final String? authors;
  final String? url;

  const ResearchReferenceEntity({
    required this.id,
    required this.researchId,
    this.documentId,
    required this.title,
    this.authors,
    this.url,
  });

  @override
  List<Object?> get props => [id, researchId, documentId, title, authors, url];
}
