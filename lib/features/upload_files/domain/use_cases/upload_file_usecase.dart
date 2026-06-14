import 'dart:typed_data';

import 'package:fpdart/fpdart.dart';
import 'package:hackathon/features/upload_files/domain/repositories/upload_file_repository.dart';
import 'package:hackathon/globals/constants/usecase.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';

class UploadFileResponse {
  final int fileId;
  final String url;
  UploadFileResponse({required this.fileId, required this.url});
}

class UploadFileUsecase implements Usecase<UploadFileResponse, UploadFileParams> {
  final UploadFileRepository uploadFileRepository;
  UploadFileUsecase({required this.uploadFileRepository});
  @override
  Future<Either<ErrorModel, UploadFileResponse>> call(UploadFileParams file) async =>
      uploadFileRepository.uploadFile(file);
}

class UploadFileParams {
  final Uint8List file;
  final String fileType;
  final String fileName;
  final int fileSize;
  UploadFileParams(
      {required this.file,
      required this.fileType,
      required this.fileName,
      required this.fileSize});
}
