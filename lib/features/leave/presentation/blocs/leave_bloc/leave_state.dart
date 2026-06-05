import 'package:equatable/equatable.dart';
import 'package:hackathon/features/leave/domain/entities/leave_entity.dart';

abstract class LeaveState extends Equatable {
  const LeaveState();

  @override
  List<Object?> get props => [];
}

class LeaveInitial extends LeaveState {}

class LeaveLoading extends LeaveState {}

class LeaveRequestSuccess extends LeaveState {
  final Leave leave;
  const LeaveRequestSuccess(this.leave);

  @override
  List<Object?> get props => [leave];
}

class MyLeavesLoaded extends LeaveState {
  final List<Leave> leaves;
  const MyLeavesLoaded(this.leaves);

  @override
  List<Object?> get props => [leaves];
}

class OrganisationLeavesLoaded extends LeaveState {
  final List<Leave> leaves;
  const OrganisationLeavesLoaded(this.leaves);

  @override
  List<Object?> get props => [leaves];
}

class LeaveActionSuccess extends LeaveState {
  final String message;
  const LeaveActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class LeaveError extends LeaveState {
  final String message;
  const LeaveError(this.message);

  @override
  List<Object?> get props => [message];
}
