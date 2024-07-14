
import 'package:todos_repository/todos_repository.dart';

enum TodosViewFilter { all, activeOnly, completedOnly }

extension TodosViewFilterX on TodosViewFilter {
  bool apply(Todo todo) {
    switch(this) {
      case TodosViewFilter.all:
        return true;
      case TodosViewFilter.activeOnly:
        return !todo.isCompleted;
      case TodosViewFilter.completedOnly:
        return todo.isCompleted;
    }
  }

  // 이 함수 구문 뭔가 멋있네. 깔끔하고 이쁘다.
  Iterable<Todo> applyAll(Iterable<Todo> todos) {
    return todos.where(apply);
  }
}