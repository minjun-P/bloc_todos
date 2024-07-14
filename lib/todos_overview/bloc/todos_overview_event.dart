part of 'todos_overview_bloc.dart';

// 투두라는 뷰모델과 관련하여 일어날 수 있는 모든 상호작용을 선언적으로 정의한다.
sealed  class TodosOverviewEvent extends Equatable {
  const TodosOverviewEvent();

  @override
  List<Object?> get props => [];
}

final class TodosOverviewSubscriptionRequested extends TodosOverviewEvent {
  const TodosOverviewSubscriptionRequested();
}

final class TodosOverviewTodoCompletionToggled extends TodosOverviewEvent {
  const TodosOverviewTodoCompletionToggled({
    required this.todo,
    required this.isCompleted,
  });

  final Todo todo;
  final bool isCompleted;

  @override
  List<Object?> get props => [todo, isCompleted];
}

final class TodosOverviewTodoDeleted extends TodosOverviewEvent {
  const TodosOverviewTodoDeleted(this.todo);

  final Todo todo;

  @override
  List<Object?> get props => [todo];
}

final class TodosOverviewUndoDeletionRequested extends TodosOverviewEvent {
  const TodosOverviewUndoDeletionRequested();
}

// filter enum을 받아 이벤트를 처리
class TodosOverviewFilterChanged extends TodosOverviewEvent {
  const TodosOverviewFilterChanged(this.filter);

  final TodosViewFilter filter;

  @override
  List<Object> get props => [filter];
}

class TodosOverviewToggleAllRequested extends TodosOverviewEvent {
  const TodosOverviewToggleAllRequested();
}

class TodosOverviewClearCompletedRequested extends TodosOverviewEvent {
  const TodosOverviewClearCompletedRequested();
}

