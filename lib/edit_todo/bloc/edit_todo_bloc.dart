import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todos_repository/todos_repository.dart';

part 'edit_todo_event.dart';

part 'edit_todo_state.dart';

class EditTodoBloc extends Bloc<EditTodoEvent, EditTodoState> {
  EditTodoBloc({
    required TodosRepository todosRepository,
    required Todo? initialTodo,
  })  : _todosRepository = todosRepository,
        super(
          EditTodoState(
            initialTodo: initialTodo,
            title: initialTodo?.title ?? '',
            description: initialTodo?.description ?? '',
          ),
        ) {
    on<EditTodoTitleChanged>(_onTitleChanged);
    on<EditTodoDescriptionChanged>(_onDescriptionChanged);
    on<EditTodoSubmitted>(_onSubmitted);
  }

  final TodosRepository _todosRepository;

  void _onTitleChanged(
    EditTodoTitleChanged event,
    Emitter<EditTodoState> emit,
  ) {
    emit(state.copyWith(title: event.title));
  }

  void _onDescriptionChanged(
    EditTodoDescriptionChanged event,
    Emitter<EditTodoState> emit,
  ) {
    emit(state.copyWith(description: event.description));
  }

  Future<void> _onSubmitted(
    EditTodoSubmitted event,
    Emitter<EditTodoState> emit,
  ) async {
    emit(state.copyWith(status: EditTodoStatus.loading));
    // 위의 2가지 이벤트를 통해서 계속 state를 업뎃하여 state 내이ㅡ title, description을
    // 그냥 갖다 쓰면 된다.
    final todo = (state.initialTodo ?? Todo(title: '')).copyWith(
      title: state.title,
      description: state.description,
    );
    try {
      // IMPORTANT
      // 다른 view model은 관심이 없다. 그냥 깡으로 repo에 데이터 변화를 알리기만 한다.
      // 이 변화된 데이터를 다른 뷰모델에서 반영하고 처리하는 것은 이 뷰모델의 책임이 아니라는 것을
      // 잘 반영한 예시다...
      // 이런 패턴은 확실히 Repo가 Stream 방식으로 구현되어야 가능한 패턴인 듯 하다.
      await _todosRepository.saveTodo(todo);
      emit(state.copyWith(status: EditTodoStatus.success));
    } catch(e) {
      emit(state.copyWith(status: EditTodoStatus.failure));
    }
  }
}
