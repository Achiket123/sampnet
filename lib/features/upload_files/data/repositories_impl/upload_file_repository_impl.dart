
import 'package:fpdart/fpdart.dart';
import 'package:hackathon/features/upload_files/domain/use_cases/upload_file_usecase.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';
import 'package:hackathon/globals/error_handling/error_messages.dart';
import 'package:hackathon/features/upload_files/data/data_sources/upload_file.dart';
import 'package:hackathon/features/upload_files/domain/repositories/upload_file_repository.dart';

class UploadFileRepositoryImpl with ErrorMessages implements UploadFileRepository {
  final UploadFileDataSource uploadFileDataSource;
  UploadFileRepositoryImpl({required this.uploadFileDataSource});
  @override
  Future<Either<ErrorModel, int>> uploadFile(UploadFileParams file) async =>
      uploadFileDataSource.uploadFile(file);
}
