import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'home_state.dart';

/// 다른 부분은 다 Bloc 베이스의 ViewModel로 처리히면서
/// 여기만 Cubit으로, 확실한 역할 분리. 쉽고 간단한 것들은
/// 오버헤드를 줄이기 위해 Cubit으로
class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState());

  void setTab(HomeTab tab) => emit(HomeState(tab: tab));
}
