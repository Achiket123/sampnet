import 'dart:convert';
import 'package:hackathon/features/search/domain/entities/search_entity.dart';
import 'package:hackathon/globals/constants/api_end_points.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';
import 'package:hackathon/services/api_client.dart';

abstract class SearchRemoteDataSource {
  Future<SearchResults> searchRemote({
    required String query,
    List<String> types,
    int limit,
    int offset,
  });
}

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  final ApiClient apiClient;

  SearchRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<SearchResults> searchRemote({
    required String query,
    List<String> types = const [],
    int limit = 20,
    int offset = 0,
  }) async {
    // Build query string manually (ApiClient.get takes a plain endpoint string).
    final params = StringBuffer('?q=${Uri.encodeQueryComponent(query)}');
    if (types.isNotEmpty) {
      params.write('&types=${Uri.encodeQueryComponent(types.join(','))}');
    }
    params.write('&limit=$limit&offset=$offset');

    final endpoint = '${ApiConstants.globalSearch}$params';
    final response = await apiClient.get(endpoint);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      return SearchResults.fromJson(body);
    } else {
      throw ServerError(
        message: 'Search failed [${response.statusCode}]: ${response.body}',
      );
    }
  }
}