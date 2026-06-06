import 'package:equatable/equatable.dart';

class ResearchFolderEntity extends Equatable {
  final int id;
  final int researchId;
  final int? parentId;
  final String name;
  final int createdBy;
  final DateTime updatedAt;

  const ResearchFolderEntity({
    required this.id,
    required this.researchId,
    required this.parentId,
    required this.name,
    required this.createdBy,
    required this.updatedAt,
  });

  @override
  List<Object?> get props =>
      [id, researchId, parentId, name, createdBy, updatedAt];
}
