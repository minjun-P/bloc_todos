import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todos/todos_overview/bloc/todos_overview_bloc.dart';
import 'package:flutter_todos/todos_overview/models/models.dart';

class TodosOverviewFilterButton extends StatelessWidget {
  const TodosOverviewFilterButton({super.key});

  @override
  Widget build(BuildContext context) {
    final activeFilter =
     context.select((TodosOverviewBloc bloc) => bloc.state.filter);
    return PopupMenuButton<TodosViewFilter>(
      shape: const ContinuousRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      initialValue: activeFilter,
      tooltip: "드랍다운 툴팁",
      onSelected: (filter) {
        context
            .read<TodosOverviewBloc>()
            .add(TodosOverviewFilterChanged(filter));
      },
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            value: TodosViewFilter.all,
            child: Text("모두 보기"),
          ),
          PopupMenuItem(
            value: TodosViewFilter.activeOnly,
            child: Text("완료되지 않은 항목만 보기"),
          ),
          PopupMenuItem(
            value: TodosViewFilter.completedOnly,
            child: Text("완료된 항목만 보기"),
          ),
        ];
      },
      icon: const Icon(Icons.filter_list_rounded),
    );

  }
}
