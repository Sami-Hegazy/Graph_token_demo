import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:graphql_token/core/utils/consts.dart';

class GraphService {
  static const _token = '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';
  String get token => _token;

  static final GraphService _instance = GraphService._();
  GraphService._();

  factory GraphService() {
    return _instance;
  }

  static final HttpLink _httpLink = HttpLink(sBaseUrl);
  static final AuthLink _authLink = AuthLink(
    getToken: () {
      return 'Bearer $_token';
    },
    headerKey: "Authorization",
  );

  ValueNotifier<GraphQLClient> graphInit() {
    final ValueNotifier<GraphQLClient> client = ValueNotifier<GraphQLClient>(
      GraphQLClient(
        link: _authLink.concat(_httpLink),
        cache: GraphQLCache(
          store: InMemoryStore(),
        ),
      ),
    );
    return client;
  }

  GraphQLClient clientToQuery() {
    final GraphQLClient client = GraphQLClient(
      link: _authLink.concat(_httpLink),
      cache: GraphQLCache(
        store: InMemoryStore(),
      ),
    );

    return client;
  }
}
