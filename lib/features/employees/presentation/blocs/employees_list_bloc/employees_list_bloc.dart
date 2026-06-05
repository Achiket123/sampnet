import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hackathon/features/employees/domain/entities/employee_entity.dart';
import 'package:hackathon/features/employees/domain/repositories/employees_repository.dart';
import 'package:hackathon/features/employees/presentation/blocs/employees_list_bloc/employees_list_event.dart';
import 'package:hackathon/features/employees/presentation/blocs/employees_list_bloc/employees_list_state.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';
import 'package:stream_transform/stream_transform.dart';

EventTransformer<E> debounce<E>(Duration duration) {
  return (events, mapper) => events.debounce(duration).switchMap(mapper);
}

class EmployeesListBloc extends Bloc<EmployeesListEvent, EmployeesListState> {
  final EmployeesRepository repository;

  EmployeesListBloc({required this.repository}) : super(const EmployeesListState()) {
    on<EmployeesListLoadRequested>(_onLoadRequested);
    on<EmployeesSearchQueryChanged>(
      _onSearchQueryChanged,
      transformer: debounce(const Duration(milliseconds: 300)),
    );
    on<EmployeesSearchCleared>(_onSearchCleared);
    on<EmployeeDeleteRequested>(_onDeleteRequested);
    on<EmployeeMakeManagerRequested>(_onMakeManagerRequested);
    on<EmployeesListRefreshRequested>(_onRefreshRequested);
    on<EmployeeUpdateRequested>(_onUpdateRequested);
  }

  Future<void> _onLoadRequested(
    EmployeesListLoadRequested event,
    Emitter<EmployeesListState> emit,
  ) async {
    emit(state.copyWith(status: EmployeesListStatus.loading));
    final result = await repository.getEmployees(event.organisationId);
    
    result.fold(
      (ErrorModel failure) => emit(state.copyWith(
        status: EmployeesListStatus.error,
        failureMessage: failure.message,
      )),
      (employees) => emit(state.copyWith(
        status: EmployeesListStatus.loaded,
        allEmployees: employees,
        displayedEmployees: _filterEmployees(employees, state.searchQuery),
      )),
    );
  }

  void _onSearchQueryChanged(
    EmployeesSearchQueryChanged event,
    Emitter<EmployeesListState> emit,
  ) {
    emit(state.copyWith(
      searchQuery: event.query,
      displayedEmployees: _filterEmployees(state.allEmployees, event.query),
    ));
  }

  void _onSearchCleared(
    EmployeesSearchCleared event,
    Emitter<EmployeesListState> emit,
  ) {
    emit(state.copyWith(
      searchQuery: '',
      displayedEmployees: state.allEmployees,
    ));
  }

  Future<void> _onDeleteRequested(
    EmployeeDeleteRequested event,
    Emitter<EmployeesListState> emit,
  ) async {
    emit(state.copyWith(
      status: EmployeesListStatus.deleting,
      deletingEmployeeId: event.employeeId,
    ));

    final result = await repository.deleteEmployee(event.employeeId);

    result.fold(
      (ErrorModel failure) => emit(state.copyWith(
        status: EmployeesListStatus.deleteError,
        failureMessage: failure.message,
        deletingEmployeeId: null,
      )),
      (_) {
        final newAll = state.allEmployees.where((e) => e.userId != event.employeeId).toList();
        emit(state.copyWith(
          status: EmployeesListStatus.loaded,
          allEmployees: newAll,
          displayedEmployees: _filterEmployees(newAll, state.searchQuery),
          deletingEmployeeId: null,
        ));
      },
    );
  }

  Future<void> _onMakeManagerRequested(
    EmployeeMakeManagerRequested event,
    Emitter<EmployeesListState> emit,
  ) async {
    emit(state.copyWith(status: EmployeesListStatus.promotingToManager));

    final result = await repository.makeManager(
      userId: event.employeeId,
      organisationId: event.organisationId,
      type: event.type,
      salary: event.salary,
    );

    result.fold(
      (ErrorModel failure) => emit(state.copyWith(
        status: EmployeesListStatus.promoteError,
        failureMessage: failure.message,
      )),
      (_) => add(EmployeesListLoadRequested(event.organisationId)),
    );
  }

  Future<void> _onRefreshRequested(
    EmployeesListRefreshRequested event,
    Emitter<EmployeesListState> emit,
  ) async {
    final result = await repository.getEmployees(event.organisationId);
    result.fold(
      (ErrorModel failure) => emit(state.copyWith(
        status: EmployeesListStatus.error,
        failureMessage: failure.message,
      )),
      (employees) => emit(state.copyWith(
        status: EmployeesListStatus.loaded,
        allEmployees: employees,
        displayedEmployees: _filterEmployees(employees, state.searchQuery),
      )),
    );
  }

  Future<void> _onUpdateRequested(
    EmployeeUpdateRequested event,
    Emitter<EmployeesListState> emit,
  ) async {
    final employee = state.allEmployees.firstWhere((e) => e.userId == event.employeeId);
    final updatedUser = UserSummaryEntity(
      id: employee.user.id,
      firstName: event.firstName ?? employee.user.firstName,
      lastName: event.lastName ?? employee.user.lastName,
      email: employee.user.email,
      phoneNumber: event.phoneNumber ?? employee.user.phoneNumber,
      profilePic: event.profilePic ?? employee.user.profilePic,
    );
    final updated = EmployeeEntity(
      userId: employee.userId,
      employmentId: employee.employmentId,
      organisationId: employee.organisationId,
      organisationName: employee.organisationName,
      type: event.type,
      salary: event.salary,
      lastLoginAt: employee.lastLoginAt,
      user: updatedUser,
    );

    final result = await repository.updateEmployee(event.employeeId, updated);

    result.fold(
      (ErrorModel failure) => emit(state.copyWith(
        status: EmployeesListStatus.promoteError,
        failureMessage: failure.message,
      )),
      (_) {
        final newAll = state.allEmployees.map((e) => e.userId == event.employeeId ? updated : e).toList();
        emit(state.copyWith(
          allEmployees: newAll,
          displayedEmployees: _filterEmployees(newAll, state.searchQuery),
        ));
      },
    );
  }

  List<EmployeeEntity> _filterEmployees(List<EmployeeEntity> employees, String query) {
    if (query.isEmpty) return employees;
    final lowercaseQuery = query.toLowerCase();
    return employees.where((e) {
      return e.user.fullName.toLowerCase().contains(lowercaseQuery) ||
          e.user.email.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }
}
