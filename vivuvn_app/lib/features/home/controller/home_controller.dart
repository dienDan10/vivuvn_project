import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common/auth/controller/auth_controller.dart';

final homeControllerProvider = NotifierProvider<HomeController, HomeState>(
  () => HomeController(),
);

class HomeState {
  final int currentPage;
  final String? userName;

  const HomeState({this.currentPage = 1000, this.userName});

  HomeState copyWith({final int? currentPage, final String? userName}) {
    return HomeState(
      currentPage: currentPage ?? this.currentPage,
      userName: userName ?? this.userName,
    );
  }
}

class HomeController extends Notifier<HomeState> {
  @override
  HomeState build() {
    // Get username
    final authState = ref.watch(authControllerProvider);
    final userName = authState.user?.username;

    return HomeState(currentPage: 1000, userName: userName);
  }

  void updatePage(int page) {
    state = state.copyWith(currentPage: page);
  }
}
