import 'dart:convert';
import 'package:hackathon/features/leave/data/models/leave_model.dart';
import 'package:hackathon/globals/constants/api_end_points.dart';
import 'package:hackathon/services/api_client.dart';

abstract class LeaveRemoteDataSource {
  Future<LeaveModel> requestLeave({
    required int organisationId,
    required String leaveType,
    required DateTime startDate,
    required DateTime endDate,
    required String reason,
  });

  Future<List<LeaveModel>> getMyLeaves({int offset = 0});

  Future<List<LeaveModel>> getOrganisationLeaves({
    required int organisationId,
    String status = '',
    int offset = 0,
  });

  Future<void> approveLeave({
    required int leaveId,
    String? managerNote,
  });

  Future<void> rejectLeave({
    required int leaveId,
    String? managerNote,
  });

  Future<void> cancelLeave({required int leaveId});
}

class LeaveRemoteDataSourceImpl implements LeaveRemoteDataSource {
  final ApiClient apiClient;

  LeaveRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<LeaveModel> requestLeave({
    required int organisationId,
    required String leaveType,
    required DateTime startDate,
    required DateTime endDate,
    required String reason,
  }) async {
    final response = await apiClient.post(
      ApiConstants.leaveRequest,
      body: {
        'organisation_id': organisationId,
        'leave_type': leaveType,
        'start_date': startDate.toUtc().toIso8601String(),
        'end_date': endDate.toUtc().toIso8601String(),
        'reason': reason,
      },
    );

    if (response.statusCode == 201) {
      return LeaveModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to request leave: ${response.body}');
    }
  }

  @override
  Future<List<LeaveModel>> getMyLeaves({int offset = 0}) async {
    final response =
        await apiClient.get('${ApiConstants.myLeaves}?offset=$offset');

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> leavesJson = data['leaves'];
      return leavesJson.map((json) => LeaveModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get my leaves: ${response.body}');
    }
  }

  @override
  Future<List<LeaveModel>> getOrganisationLeaves({
    required int organisationId,
    String status = '',
    int offset = 0,
  }) async {
    final response = await apiClient.get(
      '${ApiConstants.organisationLeaves(organisationId)}?status=$status&offset=$offset',
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> leavesJson = data['leaves'];
      return leavesJson.map((json) => LeaveModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get organisation leaves: ${response.body}');
    }
  }

  @override
  Future<void> approveLeave({required int leaveId, String? managerNote}) async {
    final response = await apiClient.put(
      ApiConstants.approveLeave(leaveId),
      body: {'manager_note': managerNote},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to approve leave: ${response.body}');
    }
  }

  @override
  Future<void> rejectLeave({required int leaveId, String? managerNote}) async {
    final response = await apiClient.put(
      ApiConstants.rejectLeave(leaveId),
      body: {'manager_note': managerNote},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to reject leave: ${response.body}');
    }
  }

  @override
  Future<void> cancelLeave({required int leaveId}) async {
    final response = await apiClient.put(ApiConstants.cancelLeave(leaveId));

    if (response.statusCode != 200) {
      throw Exception('Failed to cancel leave: ${response.body}');
    }
  }
}
