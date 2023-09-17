import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_token/draggable_container.dart';
import 'package:graphql_token/features/home/presentation/manager/cubit/home_user_cubit.dart';
import 'package:graphql_token/features/home/presentation/manager/cubit/home_user_state.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: const Text('Flutter GraphQl Token Demo'),
        centerTitle: true,
      ),
      body: Column(
        //crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
          const DraggableContainer(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onSubmitted: (value) {
                BlocProvider.of<HomeUserCubit>(context).getUsers(value, null);
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
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: BlocBuilder<HomeUserCubit, HomeUserState>(
              builder: (context, state) {
                if (state is HomeUserLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is HomeUserFailed) {
                  return Center(child: Text(state.errorMessage));
                } else if (state is HomeUserSuccess) {
                  var result = state.userList;
                  return GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: result.length,
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 1.0,
                        crossAxisSpacing: 4.0,
                        childAspectRatio: 0.6,
                      ),
                      itemBuilder: (_, index) {
                        return UserCard(
                          avatarUrl: result[index].avatarUrl,
                          userName: result[index].name ?? 'Unknown name',
                          bio: result[index].bio ?? 'No Bio founded',
                        );
                      });
                } else {
                  return const Center(
                    child: Text('Enter a letter and search for results'),
                  );
                }
              },
            ),
          ))
        ],
      ),
    );
  }
}

class UserCard extends StatelessWidget {
  const UserCard({
    super.key,
    required this.avatarUrl,
    required this.userName,
    required this.bio,
  });

  final String avatarUrl;
  final String userName;
  final String bio;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            child: Image.network(avatarUrl, fit: BoxFit.fitWidth),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              userName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Flexible(
              child: Text(
                bio,
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade700,
                ),
                maxLines: 3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
