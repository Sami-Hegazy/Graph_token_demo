import 'package:graphql_token/features/home/data/models/user_search_model.dart';
import 'package:dartz/dartz.dart';

abstract class HomeDataSource {
  Future<Either<String, UserSearchResponseDataModel>> getUsers(
      String userName, String? endCursor);
}
