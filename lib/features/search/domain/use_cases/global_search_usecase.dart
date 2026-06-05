import 'package:fpdart/fpdart.dart';
import 'package:hackathon/features/search/domain/entities/search_entity.dart';
import 'package:hackathon/features/search/domain/repositories/search_repository.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';

class GlobalSearchUsecase {
  final SearchRepository repository;

  GlobalSearchUsecase({required this.repository});

  Future<Either<ErrorModel, SearchResults>> call({
    required String query,
    List<String> types = const [],
    int limit = 20,
    int offset = 0,
  }) {
    return repository.search(
      query: query,
      types: types,
      limit: limit,
      offset: offset,
    );
  }
}