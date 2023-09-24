import 'package:graphql_token/features/home/data/models/user_search_model.dart';

sealed class HomeUserState {}

final class HomeUserInitial extends HomeUserState {}

final class HomeUserLoading extends HomeUserState {}

final class HomeUserSuccess extends HomeUserState {
  final UserSearchResponseDataModel userInfo;

  HomeUserSuccess({required this.userInfo});
}

final class HomeUserFailed extends HomeUserState {
  final String errorMessage;

  HomeUserFailed(this.errorMessage);
}
