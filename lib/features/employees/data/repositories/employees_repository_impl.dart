import 'package:fpdart/fpdart.dart';
import 'package:hackathon/features/employees/data/data_sources/employees_remote_data_source.dart';
import 'package:hackathon/features/employees/data/models/add_employee_request_model.dart';
import 'package:hackathon/features/employees/data/models/employee_model.dart';
import 'package:hackathon/features/employees/data/models/make_manager_request_model.dart';
import 'package:hackathon/features/employees/domain/entities/employee_entity.dart';
import 'package:hackathon/features/employees/domain/repositories/employees_repository.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';

class EmployeesRepositoryImpl implements EmployeesRepository {
  final EmployeesRemoteDataSource remoteDataSource;
  
  // In-memory cache: organisationId -> List of EmployeeModel
  final Map<int, List<EmployeeModel>> _cache = {};

  EmployeesRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<ErrorModel, List<EmployeeEntity>>> getEmployees(int organisationId) async {
    try {
      if (_cache.containsKey(organisationId)) {
        // Return cached version immediately
        final cachedEntities = _cache[organisationId]!.map((m) => m.toEntity()).toList();
        
        // Trigger background refresh
        _refreshEmployees(organisationId);
        
        return Right(cachedEntities);
      }

      final models = await remoteDataSource.getEmployees(organisationId);
      _cache[organisationId] = models;
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(ServerError(message: e.toString()));
    }
  }

  Future<void> _refreshEmployees(int organisationId) async {
    try {
      final models = await remoteDataSource.getEmployees(organisationId);
      _cache[organisationId] = models;
    } catch (_) {
      // Background refresh failed, ignore or handle silently
    }
  }

  @override
  Future<Either<ErrorModel, EmployeeEntity>> getEmployeeById(int id) async {
    try {
      final model = await remoteDataSource.getEmployeeById(id);
      return Right(model.toEntity());
    } on EmployeeNotFoundException {
      return Left(ServerError(message: 'Employee not found'));
    } catch (e) {
      return Left(ServerError(message: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, void>> addEmployee({
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
    required int employmentId,
  }) async {
    try {
      await remoteDataSource.addEmployee(AddEmployeeRequestModel(
        employmentId: employmentId,
        firstName: firstName,
        lastName: lastName,
        email: email,
        phoneNumber: phoneNumber,
      ));
      _cache.clear(); // Invalidate cache
      return const Right(null);
    } on AddEmployeeException catch (e) {
      return Left(ValidationError(message: e.message));
    } catch (e) {
      return Left(ServerError(message: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, void>> updateEmployee(int employeeId, EmployeeEntity updated) async {
    try {
      // Construct a partial model for update
      final model = EmployeeModel(
        userId: updated.userId,
        employmentId: updated.employmentId,
        organisationId: updated.organisationId,
        organisationName: updated.organisationName,
        type: updated.type,
        salary: updated.salary,
        lastLoginAt: updated.lastLoginAt,
        user: UserSummaryModel(
          id: updated.user.id,
          firstName: updated.user.firstName,
          lastName: updated.user.lastName,
          email: updated.user.email,
          phoneNumber: updated.user.phoneNumber,
          profilePic: updated.user.profilePic,
          isVerified: updated.user.isVerified,
        ),
      );
      await remoteDataSource.updateEmployee(employeeId, model);
      _cache.clear(); // Invalidate cache
      return const Right(null);
    } catch (e) {
      return Left(ServerError(message: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, void>> deleteEmployee(int employeeId) async {
    try {
      await remoteDataSource.deleteEmployee(employeeId);
      _cache.clear(); // Invalidate cache
      return const Right(null);
    } catch (e) {
      return Left(ServerError(message: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, List<EmployeeEntity>>> searchEmployees(String query) async {
    try {
      final models = await remoteDataSource.searchEmployees(query);
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(ServerError(message: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, void>> makeManager({
    required int userId,
    required int organisationId,
    required String type,
    required String salary,
  }) async {
    try {
      await remoteDataSource.makeManager(MakeManagerRequestModel(
        userId: userId,
        organisationId: organisationId,
        type: type,
        salary: salary,
      ));
      _cache.clear(); // Invalidate cache
      return const Right(null);
    } catch (e) {
      return Left(ServerError(message: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, void>> resendInvite(String email) async {
    try {
      await remoteDataSource.resendInvite(email);
      return const Right(null);
    } on ResendInviteException catch (e) {
      return Left(ValidationError(message: e.message));
    } catch (e) {
      return Left(ServerError(message: e.toString()));
    }
  }
}
