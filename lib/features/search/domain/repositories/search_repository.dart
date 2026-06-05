import 'package:fpdart/fpdart.dart';
import 'package:hackathon/features/search/domain/entities/search_entity.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';

abstract class SearchRepository {
  Future<Either<ErrorModel, SearchResults>> search({
    required String query,
    List<String> types = const [],
    int limit = 20,
    int offset = 0,
  });
}
