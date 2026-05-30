import 'package:bloc/bloc.dart';
import 'package:hackathon/features/company/domain/use_cases/register_company_params.dart';
import 'package:hackathon/features/company/domain/use_cases/register_company_usecase.dart';
import 'package:hackathon/globals/models/organisation_model.dart';
import 'package:meta/meta.dart';

part 'register_company_event.dart';
part 'register_company_state.dart';

class RegisterCompanyBloc
    extends Bloc<RegisterCompanyEvent, RegisterCompanyState> {
  final RegisterCompanyUseCase _registerCompanyUseCase;
  final FetchEmployeeDataUseCase _fetchEmployeeDataUseCase;
  RegisterCompanyBloc(
      {required RegisterCompanyUseCase registerCompanyUseCase,
      required FetchEmployeeDataUseCase fetchEmployeeDataUseCase})
      : _registerCompanyUseCase = registerCompanyUseCase,
        _fetchEmployeeDataUseCase = fetchEmployeeDataUseCase,
        super(RegisterCompanyInitial()) {
    on<RegisterCompanyEvent>((event, emit) async {
      emit(RegisterCompanyLoading());
    });

    on<RegisterCompany>((event, emit) async {
      final result = await _registerCompanyUseCase.call(event.params);
      result.fold((l) => emit(RegisterCompanyFailure(l.message)),
          (r) => emit(RegisterCompanySuccess(r)));
    });

    on<FetchEmployeeData>((event, emit) async {
      final result = await _fetchEmployeeDataUseCase.call(event.employeeId);
      result.fold((l) => emit(FetchEmployeeDataFailure(l.message)),
          (r) => emit(FetchEmployeeDataSuccess()));
    });
  }
}
