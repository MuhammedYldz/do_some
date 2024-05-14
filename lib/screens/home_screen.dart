import 'package:do_some/blocs/todo_bloc';
import 'package:do_some/widgets/todo_items';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Today\'s Todos'),
      ),
      body: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          if (state is TodoLoading) {
            return const CircularProgressIndicator();
          } else if (state is TodoLoaded) {
            return ListView.builder(
              itemCount: state.todos.length,
              itemBuilder: (context, index) => TodoItem(todo: state.todos[index]),
            );
          } else if (state is TodoError) {
            return Text('Error: ${state.message}');
          } else {
            return const Text('Something went wrong!');
          }
        },
      ),
    );
  }
}

