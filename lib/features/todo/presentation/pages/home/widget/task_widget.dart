import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskee/app/extension/context_extension.dart';
import 'package:taskee/app/extension/widget_padding_extension.dart';
import 'package:taskee/features/todo/domain/entities/todo.dart';
import 'package:taskee/features/todo/presentation/bloc/todo_bloc.dart';
import 'package:taskee/features/todo/presentation/bloc/todo_event.dart';
import 'package:taskee/features/todo/presentation/bloc/todo_state.dart';
import 'package:taskee/features/todo/presentation/pages/add/create_taskOrNote_screen.dart';
import 'package:taskee/features/todo/presentation/pages/home/widget/todo_list_item.dart';
import 'package:taskee/features/widget/empty_state_widget.dart';

class TaskWidget extends StatelessWidget {
  const TaskWidget({super.key});

  void onClickUndo(Todo todo, BuildContext context) {
    context.read<TodoBloc>().add(TodoItemUndoDeletedEvent(todo));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoBloc, TodoState>(
      builder: (context, state) {
        if (state is TodoLoadingState) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is TodoLoadedState) {
          if (state.todoModel.todoList.isEmpty) {
            // استبدال الصورة بالويدجت الجديد
            return const EmptyStateWidget(
              title: 'All Clear',
              subtitle: 'You have no tasks today.\nTap the + button to add one.',
              icon: Icons.task_alt_rounded,
            );
          }
          return ListView.builder(
            padding: pagePadding,
            shrinkWrap: true,
            itemCount: state.todoModel.todoList.length,
            itemBuilder: (context, index) {
              final todo = state.todoModel.todoList[index];
              return TodoListItem(
                todo: todo,
                onClickItem: () {
                  context.gotTo(
                    CreateTaskOrNoteScreen(
                      todo: todo,
                      isUpdateTaskscreen: true,
                    ),
                  );
                },
                onClickDelete: () {
                  context.read<TodoBloc>().add(TodoItemDeletedEvent(todo.id));
                },
                onToggleComplete: () {
                  context.read<TodoBloc>().add(
                    TodoItemToggleCompletedEvent(todo),
                  );
                },
              );
            },
          );
        }
        return Text('State: ${state.runtimeType}');
      },
    );
  }
}