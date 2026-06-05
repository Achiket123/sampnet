import 'package:bloc/bloc.dart';
import 'package:hackathon/features/upload_files/domain/use_cases/upload_file_usecase.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';
import 'package:meta/meta.dart';

part 'upload_file_event.dart';
part 'upload_file_state.dart';

class UploadFileBloc extends Bloc<UploadFileEvent, UploadFileState> {
  final UploadFileUsecase _uploadFileUsecase;
  UploadFileBloc({required UploadFileUsecase uploadFileUsecase}) :
    _uploadFileUsecase = uploadFileUsecase,
    super(UploadFileInitial()) {
    on<UploadFileEvent>((event, emit) {
      // TODO: implement event handler
      emit(UploadFileLoading());
    });
    on<UploadFileBlocEvent>((event, emit) async {
      emit(UploadFileLoading());
      final result = await _uploadFileUsecase(event.file);
      result.fold(
        (l) => emit(UploadFileError(error: l)),
        (r) => emit(UploadFileSuccess(fileId: r, fileName: event.file.fileName)),
      );
    });
  }
}
