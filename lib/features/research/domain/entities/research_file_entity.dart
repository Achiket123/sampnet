import 'package:equatable/equatable.dart';

class ResearchFileEntity extends Equatable {
  final int id;
  final int researchId;
  final int? documentId;
  final int? folderId;
  final String fileName;
  final String mimeType;
  final int size;
  final String storagePath;
  final String? previewPath;
  final String? thumbnailPath;
  final bool isPinned;
  final DateTime updatedAt;

  const ResearchFileEntity({
    required this.id,
    required this.researchId,
    this.documentId,
    this.folderId,
    required this.fileName,
    required this.mimeType,
    required this.size,
    required this.storagePath,
    this.previewPath,
    this.thumbnailPath,
    required this.isPinned,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        researchId,
        documentId,
        folderId,
        fileName,
        mimeType,
        size,
        storagePath,
        previewPath,
        thumbnailPath,
        isPinned,
        updatedAt,
      ];
}
