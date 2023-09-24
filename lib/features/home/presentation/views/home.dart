import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_token/features/home/data/models/user_search_model.dart';
import 'package:graphql_token/features/home/presentation/manager/cubit/home_user_cubit.dart';
import 'package:graphql_token/features/home/presentation/manager/cubit/home_user_state.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // late final ScrollController _scrollController;

  final PagingController<String?, UserSearchModel> pagingController =
      PagingController(firstPageKey: null, invisibleItemsThreshold: 4);
  String query = '';

  @override
  void initState() {
    pagingController.itemList = [];
    pagingController.addPageRequestListener((nextCursor) {
      if (query.isNotEmpty) {
        context.read<HomeUserCubit>().getUsers(query, nextCursor);
      }
    });
    // _scrollController = ScrollController()
    //   ..addListener(() {
    //     if (query.isEmpty) {
    //       return;
    //     }

    //     context.read<UserBloc>().handlePagination(
    //         scrollController: _scrollController,
    //         query: query,
    //         loadMoreTrigger: MediaQuery.sizeOf(context).height * 0.15);
    //   });
    super.initState();
  }

  @override
  void dispose() {
    pagingController.dispose();
    // _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeUserCubit, HomeUserState>(
      listener: (context, state) {
        if (state is HomeUserFailed) {
          pagingController.error = state.errorMessage;
        } else if (state is HomeUserSuccess) {
          final usersList = state.userInfo.searchResults;
          final pageInfo = state.userInfo.pageInfo;

          if (usersList.isEmpty) return;
          final isLastPage = !(pageInfo.hasNextPage);
          if (isLastPage) {
            pagingController.appendLastPage(usersList);
          } else {
            final String nextCursor = pageInfo.endCursor;
            pagingController.appendPage(usersList, nextCursor);
          }
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey.shade300,
        appBar: AppBar(
          title: const Text('Flutter GraphQl Token Demo'),
          centerTitle: true,
        ),
        body: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.sizeOf(context).width,
          ),
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                margin:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.pink[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Users Search List',
                  style: TextStyle(
                    color: Colors.pink,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(
                height: 70,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    onSubmitted: (value) {
                      query = value.trim();
                      if (value.isEmpty) return;
                      query = value;
                      pagingController.refresh();
                      // if (query.isNotEmpty) {
                      //   BlocProvider.of<UserBloc>(context)
                      //       .add(FetchDataEvent(query));
                      // }
                    },
                    decoration: const InputDecoration(
                      hintText: 'Search...',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.pink),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.pink),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // SearchResult(scrollController: _scrollController),
              SearchResult(pagingController: pagingController),
            ],
          ),
        ),
      ),
    );
  }
}

// class SearchResult extends StatelessWidget {
//   final ScrollController scrollController;
//   const SearchResult({super.key, required this.scrollController});

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//         child: Stack(
//       fit: StackFit.expand,
//       children: [
//         const BuildLoadingWidge(),
//         BlocConsumer<UserBloc, UserState>(
//           builder: (context, state) {
//             final List<UserSearchModel> users = state.users;
//             return Positioned.fill(
//                 child: ListView.builder(
//               physics: const BouncingScrollPhysics(),
//               itemCount: users.length,
//               controller: scrollController,
//               itemBuilder: (context, index) {
//                 return _BuildUserListTile(userSearchModel: users[index]);
//               },
//             ));
//           },
//           listener: (context, state) {
//             if (state is UserError) {
//               Fluttertoast.showToast(msg: state.errorMessage);
//             }
//           },
//         )
//       ],
//     ));
//   }
// }

class SearchResult extends StatelessWidget {
  final PagingController<String?, UserSearchModel> pagingController;
  const SearchResult({super.key, required this.pagingController});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: RefreshIndicator(
        onRefresh: () async {
          pagingController.refresh();
        },
        child: PagedListView<String?, UserSearchModel>(
          pagingController: pagingController,
          builderDelegate: PagedChildBuilderDelegate(
            newPageProgressIndicatorBuilder: (context) {
              return const Center(child: CircularProgressIndicator());
            },
            firstPageErrorIndicatorBuilder: (context) {
              return Center(
                child: Text(pagingController.error.toString()),
              );
            },
            firstPageProgressIndicatorBuilder: (context) {
              return const Center(child: CircularProgressIndicator());
            },
            newPageErrorIndicatorBuilder: (context) {
              return TextButton(
                  onPressed: () {
                    pagingController.retryLastFailedRequest();
                  },
                  child: const Text('Retry'));
            },
            noItemsFoundIndicatorBuilder: (context) {
              return const Center(
                child: Text('No Data Found'),
              );
            },
            noMoreItemsIndicatorBuilder: (context) => const SizedBox.shrink(),
            itemBuilder: (context, item, index) {
              return _BuildUserListTile(userSearchModel: item);
            },
          ),
        ),
      ),
    );
  }
}

// class BuildLoadingWidge extends StatelessWidget {
//   const BuildLoadingWidge({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocSelector<UserBloc, UserState, bool>(
//       selector: (state) => state is UserLoading,
//       builder: (context, isLoading) {
//         if (isLoading) {
//           return const Positioned(
//             bottom: 10,
//             right: 10,
//             width: 20,
//             height: 20,
//             child: FittedBox(
//               child: CircularProgressIndicator(
//                 color: Colors.black,
//               ),
//             ),
//           );
//         }

//         return const SizedBox.shrink();
//       },
//     );
//   }
// }

class _BuildUserListTile extends StatelessWidget {
  final UserSearchModel userSearchModel;

  const _BuildUserListTile({required this.userSearchModel});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width * 0.96,
      height: MediaQuery.sizeOf(context).height * 0.12,
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            userSearchModel.avatarUrl,
            errorBuilder: (context, error, stackTrace) {
              return ColoredBox(color: Colors.grey.shade200);
            },
          ),
        ),
        title: Text(
          userSearchModel.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          userSearchModel.bio,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
