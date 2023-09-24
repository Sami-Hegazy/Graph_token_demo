import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_token/features/home/data/models/user_search_model.dart';
import 'package:graphql_token/features/home/data/repo/home_repo_impl.dart';
part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final HomeRepoImpl _homeRepoImpl;
  UserBloc(this._homeRepoImpl)
      : super(const UserInitial(users: [], endCursor: null, hasMore: true)) {
    on<FetchDataEvent>((event, emit) async {
      emit(const UserLoading(users: [], endCursor: null, hasMore: true));

      final results =
          await _homeRepoImpl.getUsers(event.query, state.endCursor);
      results.fold((errorMessage) {
        emit(UserError(errorMessage,
            users: state.users,
            endCursor: state.endCursor,
            hasMore: state.hasMore));
      }, (data) {
        emit(UserSuccess(
            users: data.searchResults,
            endCursor: data.pageInfo.endCursor,
            hasMore: data.pageInfo.hasNextPage));
      });
    });

    on<LoadMoreDataEvent>((event, emit) async {
      if (!state.hasMore) return;
      emit(UserLoading(
          users: state.users,
          endCursor: state.endCursor,
          hasMore: state.hasMore));

      final results =
          await _homeRepoImpl.getUsers(event.query, state.endCursor);
      results.fold((errorMessage) {
        emit(UserError(
          errorMessage,
          users: state.users,
          endCursor: state.endCursor,
          hasMore: state.hasMore,
        ));
      }, (data) {
        final List<UserSearchModel> newUsersList = [
          ...state.users,
          ...data.searchResults
        ];
        emit(UserSuccess(
          users: newUsersList,
          endCursor: data.pageInfo.endCursor,
          hasMore: data.pageInfo.hasNextPage,
        ));
      });
    }, transformer: droppable());
  }

  handlePagination({
    required ScrollController scrollController,
    required String query,
    required double loadMoreTrigger,
  }) {
    final offset = scrollController.offset;
    final maxExtent = scrollController.position.maxScrollExtent;

    if (offset >= maxExtent - loadMoreTrigger) {
      add(LoadMoreDataEvent(query));
    }
  }
}
