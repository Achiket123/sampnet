import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hackathon/features/attendence/data/models/attendence_model.dart';
import 'package:hackathon/features/attendence/domain/use_cases/attendence_params.dart';
import 'package:hackathon/globals/constants/api_end_points.dart';
import 'package:hackathon/globals/constants/user.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';
import 'package:http/http.dart' as http;

abstract class AttendenceRemoteDataSource {
  Future<Either<ErrorModel, AttendenceModel>> checkInAttendence(
      AttendenceParams params);
  Future<Either<ErrorModel, AttendenceModel>> checkOutAttendence(
      AttendenceParams params);
  Future<Either<ErrorModel, AttendenceModel>> getAttendence(int userId);
}

class AttendenceRemoteDataSourceImpl extends AttendenceRemoteDataSource {
  final http.Client client;
  AttendenceRemoteDataSourceImpl({required this.client});
  @override
  Future<Either<ErrorModel, AttendenceModel>> checkInAttendence(
      AttendenceParams params) async {
    try {
      final data = AttendenceModel(
              checkinTime: params.dateTime,
              userId: params.userId,
              checkInPicture: params.picture,
              organisationId: params.organisationId)
          .toMap();

      debugPrint(
        data.toString(),
      );
      final response =
          await client.post(Uri.parse(ApiConstants.attendenceCheckInUrl),
              headers: {
                'Authorization': User.token,
              },
              body: jsonEncode(data));
      debugPrint(
        response.body,
      );
      debugPrint(
        response.statusCode.toString(),
      );
      if (response.statusCode == 200) {
        return right(
            AttendenceModel.fromJson(jsonDecode(response.body)['attendance']));
      }

      return left(ErrorModel(message: response.body));
    } catch (e) {
      debugPrint(
        e.toString(),
      );
      return left(ErrorModel(message: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, AttendenceModel>> checkOutAttendence(
      AttendenceParams params) async {
    try {
      final data = AttendenceModel(
              id: params.id,
              checkoutTime: params.dateTime,
              userId: params.userId,
              checkOutPicture: params.picture,
              organisationId: params.organisationId)
          .toMap();
      final response = await client.put(
          Uri.parse("${ApiConstants.attendenceCheckOutUrl}/${User.user.id}"),
          headers: {
            'Authorization': User.token,
          },
          body: jsonEncode(data));
      if (response.statusCode == 200) {
        return right(
            AttendenceModel.fromJson(jsonDecode(response.body)['attendance']));
      } else if (response.statusCode == 404) {
        return left(ErrorModel(message: jsonDecode(response.body)['message']));
      }
      return left(ErrorModel(message: response.body));
    } catch (e) {
      debugPrint(
        e.toString(),
      );
      return left(ErrorModel(message: e.toString()));
    }
  }

  @override
  Future<Either<ErrorModel, AttendenceModel>> getAttendence(int userId) async {
    try {
      final response = await client
          .get(Uri.parse("${ApiConstants.getAttendence}/$userId"), headers: {
        'Authorization': User.token,
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)["attendance"];
        debugPrint(
          data.toString(),
        );
        return right(AttendenceModel.fromJson(data));
      } else if (response.statusCode == 404) {
        return right(AttendenceModel(
            userId: userId, organisationId: User.organisation.id!));
      }
      return left(ErrorModel(message: response.body));
    } catch (e) {
      return left(ErrorModel(message: e.toString()));
    }
  }
}
