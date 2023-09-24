part of 'user_bloc.dart';

sealed class UserEvent extends Equatable {
  final String query;
  const UserEvent(this.query);

  @override
  List<Object> get props => [query];
}

class FetchDataEvent extends UserEvent {
  const FetchDataEvent(super.query);
}

class LoadMoreDataEvent extends UserEvent {
  const LoadMoreDataEvent(super.query);
}
