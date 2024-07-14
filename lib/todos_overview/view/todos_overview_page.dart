import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todos/edit_todo/view/edit_todo_page.dart';
import 'package:flutter_todos/todos_overview/bloc/todos_overview_bloc.dart';
import 'package:flutter_todos/todos_overview/widgets/widgets.dart';
import 'package:todos_repository/todos_repository.dart';

class TodosOverviewPage extends StatelessWidget {
  const TodosOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TodosOverviewBloc(
        todosRepository: context.read<TodosRepository>(),
        // IMPORTANT
        // bloc create와 동시에 특정 이벤트를 발생시키는 케이스
        // 데이터를 처음 가져오는 경우에 보편적인 케이스일 듯 하다. 주목할 것.
      )..add(const TodosOverviewSubscriptionRequested()),
      child: const TodosOverviewView(),
    );
  }
}

class TodosOverviewView extends StatelessWidget {
  const TodosOverviewView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todos Overview"),
        actions: const [
          TodosOverviewFilterButton(),
          TodosOverviewOptionsButton(),
        ],
      ),
      // IMPORTANT
      // 여러 bloc에 대한 listen을 하는 경우 아래 위젯을 사용
      // 특이한 점은 같은 bloc 에 대한 Listen을 함에도 불구하고, listenWhen을 달리하여
      // 다른 용도로의 listener를 여러개 뒀다는 것이다.
      body: MultiBlocListener(
        listeners: [
          BlocListener<TodosOverviewBloc, TodosOverviewState>(
            listenWhen: (previous, current) =>
                previous.status != current.status,
            listener: (context, state) {
              if (state.status == TodosOverviewStatus.failure) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                      const SnackBar(content: Text("todo error 발생")));
              }
            },
          ),
          BlocListener<TodosOverviewBloc, TodosOverviewState>(
            listenWhen: (previous, current) =>
                // 즉, 없던 lastDeletedTodo가 추가되었을 때만 이 리스너가 작동한다.
                previous.lastDeletedTodo != current.lastDeletedTodo &&
                current.lastDeletedTodo != null,
            listener: (context, state) {
              final deletedTodo = state.lastDeletedTodo!;
              final messenger = ScaffoldMessenger.of(context);
              messenger
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text("todo 삭제됨: ${deletedTodo.title}"),
                    action: SnackBarAction(
                      label: "취소",
                      onPressed: () {
                        messenger.hideCurrentSnackBar();
                        context
                            .read<TodosOverviewBloc>()
                            .add(const TodosOverviewUndoDeletionRequested());
                      },
                    ),
                  ),
                );
            },
          ),
        ],
        child: BlocBuilder<TodosOverviewBloc, TodosOverviewState>(
          builder: (context, state) {
            if (state.todos.isEmpty) {
              if (state.status == TodosOverviewStatus.loading) {
                return const Center(child: CupertinoActivityIndicator());
              } else if (state.status != TodosOverviewStatus.success) {
                return const SizedBox();
              } else {
                return Center(
                  child: Text(
                    "No todos",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                );
              }
            }

            return CupertinoScrollbar(
                child: ListView(
              children: [
                for (final todo in state.filteredTodos)
                  TodoListTile(
                    todo: todo,
                    onToggleCompleted: (isCompleted) {
                      context.read<TodosOverviewBloc>().add(
                            TodosOverviewTodoCompletionToggled(
                              todo: todo,
                              isCompleted: isCompleted,
                            ),
                          );
                    },
                    onDismissed: (_) {
                      context.read<TodosOverviewBloc>()
                          .add(TodosOverviewTodoDeleted(todo));
                    },
                    onTap: () {
                      Navigator.of(context).push(
                        EditTodoPage.route(initialTodo: todo)
                      );
                    },
                  )
              ],
            ));
          },
        ),
      ),
    );
  }
}
