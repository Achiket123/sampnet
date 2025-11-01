
import 'package:fpdart/fpdart.dart';
import 'package:hackathon/features/upload_files/domain/use_cases/upload_file_usecase.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';

abstract class UploadFileRepository {
  Future<Either<ErrorModel, int>> uploadFile(UploadFileParams file);
}
