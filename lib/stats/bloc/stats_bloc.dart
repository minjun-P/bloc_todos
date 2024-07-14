import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todos_repository/todos_repository.dart';

part 'stats_event.dart';
part 'stats_state.dart';

class StatsBloc extends Bloc<StatsEvent, StatsState> {
  StatsBloc({
    required TodosRepository todosRepository,
}) : _todosRepository = todosRepository,super(const StatsState()) {
    on<StatsSubscriptionRequested>(_onSubscriptionRequested);
  }
  final TodosRepository _todosRepository;

  Future<void> _onSubscriptionRequested(
      StatsSubscriptionRequested event,
      Emitter<StatsState> emit,
      ) async {
    emit(state.copyWith(status: StatsStatus.loading));

    // IMPORTANT
    // view model 간 융합이 필요할 때, service, repo 수준에서 합치라고 했던 부분이 이해가 간다.
    // 같은 repo의 같은 subscription을 구독함으로써, 뷰모델끼리 서로의 존재와 값을 몰라도
    // 알아서 싱크를 맞춘 상태로 독립적으로 관리하는 것이 가능해진다.
    await emit.forEach<List<Todo>>(
      _todosRepository.getTodos(),
      onData: (todos) => state.copyWith(
        status: StatsStatus.success,
        completedTodos: todos.where((todo) => todo.isCompleted).length,
        activeTodos: todos.where((todo) => !todo.isCompleted).length,
      ),
      onError: (_, __) => state.copyWith(status: StatsStatus.failure),
    );
  }
}
