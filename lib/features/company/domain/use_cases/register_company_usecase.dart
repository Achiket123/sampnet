import 'package:fpdart/src/either.dart';
import 'package:hackathon/features/company/domain/repositories/register_company_repository.dart';
import 'package:hackathon/features/company/domain/use_cases/register_company_params.dart';
import 'package:hackathon/globals/constants/usecase.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';
import 'package:hackathon/globals/models/organisation_model.dart';

class RegisterCompanyUseCase implements Usecase<void, RegisterCompanyParams> {
  final RegisterCompanyRepository repository;

  RegisterCompanyUseCase(this.repository);

  @override
  Future<Either<ErrorModel, Organisation>> call(
      RegisterCompanyParams params) async {
    return await repository.registerCompany(params);
  }
}

class FetchEmployeeDataUseCase implements Usecase<void, String> {
  final RegisterCompanyRepository repository;

  FetchEmployeeDataUseCase(this.repository);
  
  @override
  Future<Either<ErrorModel, void>> call(String params) async {
    return await repository.fetchEmployeeData(params);
  }
}

