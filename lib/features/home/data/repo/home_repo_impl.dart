import 'package:dartz/dartz.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:graphql_token/core/utils/graph_service.dart';
import 'package:graphql_token/core/utils/network_service.dart';
import 'package:graphql_token/features/home/data/models/user_search_model.dart';
import 'package:graphql_token/features/home/data/repo/home_data_source.dart';

class HomeRepoImpl extends HomeDataSource {
  final NetworkService networkService;

  HomeRepoImpl(this.networkService);

  @override
  Future<Either<String, UserSearchResponseDataModel>> getUsers(
      String userName, String? endCursor) async {
    final isConnected = await networkService.isConnected();
    if (isConnected) {
      try {
        final QueryOptions options = QueryOptions(
          document: gql(r'''
          query SearchForUser(
            $query: String!
            $type: SearchType!
            $first: Int
            $after: String
            $last: Int
          ) {
            search(query: $query, type: $type, last: $last, after: $after, first: $first) {
              nodes {
                ... on User {
                  bio
                  id
                  avatarUrl
                  name
                  email
                }
              }
              pageInfo {
                endCursor
                hasNextPage
              }
            }
          }
        '''),
          fetchPolicy: FetchPolicy.noCache,
          variables: {
            'query': userName,
            'type': 'USER',
            'after': endCursor,
            'first': 10,
            'last': null,
          },
        );

        final request = await GraphService().clientToQuery().query(options);
        final data = request.data;

        if (data != null) {
          final responseDataModel =
              UserSearchResponseModel.fromJson(data).search;
          return right(responseDataModel);
        } else {
          return left('No Data');
        }
      } on LinkException catch (e) {
        if (e is ServerException) {
          return left(e.parsedResponse?.response['message'] ??
              'Something went wrong with message');
        }
        return left('An unexpected error occurred');
      } on Exception catch (e) {
        return left('An unexpected error occurred: $e');
      }
    } else {
      return left('No network connection');
    }
  }
}
