import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hackathon/features/leave/domain/use_cases/approve_leave_usecase.dart';
import 'package:hackathon/features/leave/domain/use_cases/cancel_leave_usecase.dart';
import 'package:hackathon/features/leave/domain/use_cases/get_all_leave_requests_usecase.dart';
import 'package:hackathon/features/leave/domain/use_cases/get_leave_history_usecase.dart';
import 'package:hackathon/features/leave/domain/use_cases/reject_leave_usecase.dart';
import 'package:hackathon/features/leave/domain/use_cases/submit_leave_request_usecase.dart';
import 'package:hackathon/features/leave/presentation/blocs/leave_bloc/leave_event.dart';
import 'package:hackathon/features/leave/presentation/blocs/leave_bloc/leave_state.dart';

class LeaveBloc extends Bloc<LeaveEvent, LeaveState> {
  final SubmitLeaveRequestUsecase submitLeaveRequestUsecase;
  final GetLeaveHistoryUsecase getLeaveHistoryUsecase;
  final GetAllLeaveRequestsUsecase getAllLeaveRequestsUsecase;
  final ApproveLeaveUsecase approveLeaveUsecase;
  final RejectLeaveUsecase rejectLeaveUsecase;
  final CancelLeaveUsecase cancelLeaveUsecase;

  LeaveBloc({
    required this.submitLeaveRequestUsecase,
    required this.getLeaveHistoryUsecase,
    required this.getAllLeaveRequestsUsecase,
    required this.approveLeaveUsecase,
    required this.rejectLeaveUsecase,
    required this.cancelLeaveUsecase,
  }) : super(LeaveInitial()) {
    on<RequestLeaveEvent>(_onRequestLeave);
    on<GetMyLeavesEvent>(_onGetMyLeaves);
    on<GetOrganisationLeavesEvent>(_onGetOrganisationLeaves);
    on<ApproveLeaveEvent>(_onApproveLeave);
    on<RejectLeaveEvent>(_onRejectLeave);
    on<CancelLeaveEvent>(_onCancelLeave);
  }

  Future<void> _onRequestLeave(RequestLeaveEvent event, Emitter<LeaveState> emit) async {
    emit(LeaveLoading());
    final result = await submitLeaveRequestUsecase(
      organisationId: event.organisationId,
      leaveType: event.leaveType,
      startDate: event.startDate,
      endDate: event.endDate,
      reason: event.reason,
    );
    result.fold(
      (failure) => emit(LeaveError(failure.message)),
      (leave) => emit(LeaveRequestSuccess(leave)),
    );
  }

  Future<void> _onGetMyLeaves(GetMyLeavesEvent event, Emitter<LeaveState> emit) async {
    emit(LeaveLoading());
    final result = await getLeaveHistoryUsecase(offset: event.offset);
    result.fold(
      (failure) => emit(LeaveError(failure.message)),
      (leaves) => emit(MyLeavesLoaded(leaves)),
    );
  }

  Future<void> _onGetOrganisationLeaves(GetOrganisationLeavesEvent event, Emitter<LeaveState> emit) async {
    emit(LeaveLoading());
    final result = await getAllLeaveRequestsUsecase(
      organisationId: event.organisationId,
      status: event.status,
      offset: event.offset,
    );
    result.fold(
      (failure) => emit(LeaveError(failure.message)),
      (leaves) => emit(OrganisationLeavesLoaded(leaves)),
    );
  }

  Future<void> _onApproveLeave(ApproveLeaveEvent event, Emitter<LeaveState> emit) async {
    emit(LeaveLoading());
    final result = await approveLeaveUsecase(
      leaveId: event.leaveId,
      managerNote: event.managerNote,
    );
    result.fold(
      (failure) => emit(LeaveError(failure.message)),
      (_) => emit(const LeaveActionSuccess("Leave approved successfully")),
    );
  }

  Future<void> _onRejectLeave(RejectLeaveEvent event, Emitter<LeaveState> emit) async {
    emit(LeaveLoading());
    final result = await rejectLeaveUsecase(
      leaveId: event.leaveId,
      managerNote: event.managerNote,
    );
    result.fold(
      (failure) => emit(LeaveError(failure.message)),
      (_) => emit(const LeaveActionSuccess("Leave rejected successfully")),
    );
  }

  Future<void> _onCancelLeave(CancelLeaveEvent event, Emitter<LeaveState> emit) async {
    emit(LeaveLoading());
    final result = await cancelLeaveUsecase(leaveId: event.leaveId);
    result.fold(
      (failure) => emit(LeaveError(failure.message)),
      (_) => emit(const LeaveActionSuccess("Leave cancelled successfully")),
    );
  }
}
