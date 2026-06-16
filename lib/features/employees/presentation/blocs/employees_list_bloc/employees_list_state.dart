import 'package:equatable/equatable.dart';
import 'package:hackathon/features/employees/domain/entities/employee_entity.dart';

enum EmployeesListStatus {
  initial,
  loading,
  loaded,
  error,
  deleting,
  deleteError,
  promotingToManager,
  promoteError,
  resendingInvite,
  resendInviteSuccess,
  resendInviteError,
}

class EmployeesListState extends Equatable {
  final EmployeesListStatus status;
  final List<EmployeeEntity> allEmployees;
  final List<EmployeeEntity> displayedEmployees;
  final String searchQuery;
  final String? failureMessage;
  final int? deletingEmployeeId;

  const EmployeesListState({
    this.status = EmployeesListStatus.initial,
    this.allEmployees = const [],
    this.displayedEmployees = const [],
    this.searchQuery = '',
    this.failureMessage,
    this.deletingEmployeeId,
  });

  EmployeesListState copyWith({
    EmployeesListStatus? status,
    List<EmployeeEntity>? allEmployees,
    List<EmployeeEntity>? displayedEmployees,
    String? searchQuery,
    String? failureMessage,
    int? deletingEmployeeId,
  }) {
    return EmployeesListState(
      status: status ?? this.status,
      allEmployees: allEmployees ?? this.allEmployees,
      displayedEmployees: displayedEmployees ?? this.displayedEmployees,
      searchQuery: searchQuery ?? this.searchQuery,
      failureMessage: failureMessage ?? this.failureMessage,
      deletingEmployeeId: deletingEmployeeId ?? this.deletingEmployeeId,
    );
  }

  @override
  List<Object?> get props => [
        status,
        allEmployees,
        displayedEmployees,
        searchQuery,
        failureMessage,
        deletingEmployeeId,
      ];
}
