import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todos/todos_overview/bloc/todos_overview_bloc.dart';

@visibleForTesting
enum TodosOverviewOption { toggleAll, clearCompleted }

class TodosOverviewOptionsButton extends StatelessWidget {
  const TodosOverviewOptionsButton({super.key});

  @override
  Widget build(BuildContext context) {
    final todos = context.select((TodosOverviewBloc bloc) => bloc.state.todos);
    final hasTodos = todos.isNotEmpty;
    final completedTodosAmount = todos.where((todo) => todo.isCompleted).length;
    return PopupMenuButton<TodosOverviewOption>(
      shape: const ContinuousRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16))
      ),
      tooltip: "드랍다운 툴팁",
      onSelected: (options) {
        switch (options) {
          case TodosOverviewOption.toggleAll:
            context.read<TodosOverviewBloc>().add(const TodosOverviewToggleAllRequested());
            break;
          case TodosOverviewOption.clearCompleted:
            context.read<TodosOverviewBloc>().add(const TodosOverviewClearCompletedRequested());
            break;
        }
      },
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            value: TodosOverviewOption.toggleAll,
            enabled: hasTodos,
            child: Text(
              completedTodosAmount == todos.length
                  ? "모두 완료 취소"
                  : "모두 완료",
            ),
          ),
          PopupMenuItem(
            value: TodosOverviewOption.clearCompleted,
            enabled: hasTodos && completedTodosAmount > 0,
            child: Text("완료된 항목 지우기"),
          ),
        ];
      },
    );
  }
}
