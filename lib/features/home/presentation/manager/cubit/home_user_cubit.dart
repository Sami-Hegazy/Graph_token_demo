import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_token/features/home/data/repo/home_data_source.dart';
import 'package:graphql_token/features/home/presentation/manager/cubit/home_user_state.dart';

class HomeUserCubit extends Cubit<HomeUserState> {
  HomeUserCubit(
    this._homeDataSource,
  ) : super(HomeUserInitial());

  final HomeDataSource _homeDataSource;

  Future<void> getUsers(String searchName, String? endCursor) async {
    emit(HomeUserLoading());
    var results = await _homeDataSource.getUsers(searchName, endCursor);

    await Future.delayed(const Duration(seconds: 2));

    results.fold((error) {
      emit(HomeUserFailed(error));
    }, (model) {
      emit(HomeUserSuccess(userInfo: model));
    });
  }
}
