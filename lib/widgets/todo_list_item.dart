import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/models/todo.dart';

class ToDoListItem extends StatelessWidget {
  const ToDoListItem({super.key, required this.todo, required this.deleteTodo});

  final Todo todo;
  final Function(Todo) deleteTodo;

  void deletar(BuildContext context) {
    deleteTodo(todo);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Slidable(
        child: Container(
          decoration: BoxDecoration(
              color: Color(0xe8e8e8e8), borderRadius: BorderRadius.circular(4.0)),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                Icons.assignment,
                size: 30,
              ),
              SizedBox(
                width: 8,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat('dd/MM/yyyy HH:mm').format(todo.dateTime),
                    style: TextStyle(fontSize: 12),
                  ),
                  Text(
                    todo.title,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  )
                ],
              ),
            ],
          ),
        ),
        endActionPane: ActionPane(
          extentRatio: 0.3,
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              flex: 1,
              onPressed: deletar,
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              label: "Remover",
              icon: Icons.delete,


            ),
          ],
        ),
      ),
    );
  }
}
