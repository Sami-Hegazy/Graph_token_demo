part of 'user_bloc.dart';

sealed class UserState extends Equatable {
  final List<UserSearchModel> users;
  final String? endCursor;
  final bool hasMore;
  const UserState(
      {required this.users, required this.endCursor, required this.hasMore});

  @override
  List<Object> get props => [users, hasMore];
}

final class UserInitial extends UserState {
  const UserInitial(
      {required super.users, required super.endCursor, required super.hasMore});
}

final class UserLoading extends UserState {
  const UserLoading(
      {required super.users, required super.endCursor, required super.hasMore});
}

final class UserSuccess extends UserState {
  const UserSuccess(
      {required super.users, required super.endCursor, required super.hasMore});
}

final class UserError extends UserState {
  final String errorMessage;

  const UserError(this.errorMessage,
      {required super.users, required super.endCursor, required super.hasMore});
}
