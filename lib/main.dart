import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:graphql_token/core/utils/graph_service.dart';
import 'package:graphql_token/core/utils/network_service.dart';
import 'package:graphql_token/features/home/data/repo/home_repo_impl.dart';
import 'package:graphql_token/features/home/presentation/manager/cubit/home_user_cubit.dart';
import 'package:graphql_token/features/home/presentation/views/home.dart';
import 'core/utils/consts.dart';

void main() {
  runApp(BlocProvider(
    create: (context) => HomeUserCubit(HomeRepoImpl(NetworkService())),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: GraphService().graphInit(),
      child: MaterialApp(
        title: 'Flutter Graphql Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          appBarTheme: appBarTheme,
        ),
        home: const Home(),
      ),
    );
  }
}
