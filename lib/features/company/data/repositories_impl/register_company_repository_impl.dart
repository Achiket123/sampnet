import 'package:fpdart/fpdart.dart';
import 'package:hackathon/features/company/data/data_sources/company_remote_data_source.dart';
import 'package:hackathon/features/company/domain/repositories/register_company_repository.dart';
import 'package:hackathon/features/company/domain/use_cases/register_company_params.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';
import 'package:hackathon/globals/models/organisation_model.dart';

class RegisterCompanyRepositoryImpl extends RegisterCompanyRepository {
  final CompanyRemoteDataSource companyRemoteDataSource;

  RegisterCompanyRepositoryImpl(this.companyRemoteDataSource);

  @override
  Future<Either<ErrorModel, Organisation>> registerCompany(
      RegisterCompanyParams params) async {
    return await companyRemoteDataSource.registerCompany(params);
  }

  @override
  Future<Either<ErrorModel, void>> fetchEmployeeData(String employeeId) async {
    return await companyRemoteDataSource.fetchEmployeeData(employeeId);
  }
}
