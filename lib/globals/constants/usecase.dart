import 'package:fpdart/fpdart.dart';
import 'package:hackathon/globals/error_handling/error_model.dart';

abstract class Usecase<T, P> {
  Future<Either<ErrorModel, T>> call(P params);
}

abstract class NonFutureUsecase<T, P> {
  Either<ErrorModel, T> call(P params);
}

abstract class StreamUsecase<T, P> {
  Stream call(P params);
}
