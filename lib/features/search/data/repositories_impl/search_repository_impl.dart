import 'package:fpdart/fpdart.dart';
import 'package:hackathon/features/search/data/data_sources/search_remote_data_source.dart';
import 'package:hackathon/features/search/domain/entities/search_entity.dart';
import 'package:hackathon/features/search/domain/repositories/search_repository.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchRemoteDataSource remoteDataSource;

  SearchRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<ErrorModel, SearchResults>> search({
    required String query,
    List<String> types = const [],
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final results = await remoteDataSource.searchRemote(
        query: query,
        types: types,
        limit: limit,
        offset: offset,
      );
      return Right(results);
    } catch (e) {
      return Left(ServerError(message: e.toString()));
    }
  }
}
