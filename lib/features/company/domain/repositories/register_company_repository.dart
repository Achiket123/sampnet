import 'package:fpdart/fpdart.dart';
import 'package:hackathon/features/company/domain/use_cases/register_company_params.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';
import 'package:hackathon/globals/models/organisation_model.dart';

abstract class RegisterCompanyRepository {
  Future<Either<ErrorModel, Organisation>> registerCompany(RegisterCompanyParams params);
  Future<Either<ErrorModel, void>> fetchEmployeeData(String employeeId);
}
