import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hackathon/features/upload_files/domain/use_cases/upload_file_usecase.dart';
import 'package:hackathon/globals/constants/api_end_points.dart';
import 'package:hackathon/globals/error_handling/error_messages.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';

abstract class UploadFileDataSource {
  Future<Either<ErrorModel, UploadFileResponse>> uploadFile(UploadFileParams file);
}

class UploadFileDataSourceImpl
    with ErrorMessages
    implements UploadFileDataSource {
  final Client apiClient;
  UploadFileDataSourceImpl({required this.apiClient});

  @override
  Future<Either<ErrorModel, UploadFileResponse>> uploadFile(UploadFileParams file) async {
    try {
      // Create multipart request
      final request =
          MultipartRequest('POST', Uri.parse(ApiConstants.uploadFile));
      request.headers['Content-Type'] = 'multipart/form-data';

      // Add file to request
      final multipartFile = MultipartFile.fromBytes(
        'data',
        file.file,
        filename: file.fileName,
        contentType: MediaType('application', 'octet-stream'),
      );
      request.files.add(multipartFile);

      // Add other fields
      request.fields.addAll({
        "file_type": file.fileType,
        "file_name": file.fileName,
        "file_size": file.fileSize.toString(),
      });

      // Log request details
      debugPrint('Requesting ${ApiConstants.uploadFile}');
      request.headers
          .forEach((key, value) => debugPrint('Header $key: $value'));

      // Send request and handle timeout
      final streamedResponse = await apiClient
          .send(request)
          .timeout(const Duration(seconds: 60), onTimeout: () {
        throw TimeoutException('Request timed out');
      });

      // Get response body
      final response = await Response.fromStream(streamedResponse);
      debugPrint('Upload response status: ${response.statusCode}');
      debugPrint('Upload response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return right(UploadFileResponse(
          fileId: jsonResponse['file_id'],
          url: jsonResponse['url'] ?? '',
        ));
      } else {
        return left(ServerError(
            message: 'Server error: ${response.statusCode} ${response.body}'));
      }
    } on TimeoutException {
      return left(ErrorModel(message: 'Request timed out'));
    } on SocketException {
      return left(
          ErrorModel(message: 'Network error: Unable to reach the server.'));
    } catch (e) {
      debugPrint('Upload error: $e');
      return left(ErrorModel(
          message: 'Upload failed: ${e.runtimeType} - ${e.toString()}'));
    }
  }
}
