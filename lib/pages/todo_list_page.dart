import "package:flutter/material.dart";
import "package:todo_list/models/todo.dart";
import "package:todo_list/repositories/todo_repository.dart";
import "package:todo_list/widgets/todo_list_item.dart";

class ToDoListPage extends StatefulWidget {
  ToDoListPage({super.key});

  @override
  State<ToDoListPage> createState() => _ToDoListPageState();
}

class _ToDoListPageState extends State<ToDoListPage> {
  List<Todo> todos = [];
  Todo? deletedTodo;
  int? deletedTodoPos;

  String? errorTextMessage;

  final TextEditingController todoController = TextEditingController();
  final TodoRepository todoRepository = TodoRepository();

  void onDelete(Todo todo) {
    deletedTodo = todo;
    deletedTodoPos = todos.indexOf(todo);

    setState(() {
      todos.remove(todo);
    });

    todoRepository.saveTodoList(todos);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Tarefa ${todo.title} foi removida com sucesso!",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
        action: SnackBarAction(
          label: "Desfazer",
          onPressed: () {
            setState(() {
              todos.insert(deletedTodoPos!, deletedTodo!);
            });
            todoRepository.saveTodoList(todos);
          },
          textColor: Colors.deepPurple,
        ),
        duration: const Duration(seconds: 5),
        backgroundColor: Colors.white,
      ),
    );
  }

  deleteAllTodos() {
    setState(() {
      todos.clear();
    });
    todoRepository.saveTodoList(todos);
  }

  void showDialogConfirmationDeleteAllTodos() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Limpar tudo?"),
        content: Text("Você tem certeza que deseja limpar todas as tarefas?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              "Cancelar",
              style: TextStyle(color: Colors.deepPurple),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              deleteAllTodos();
            },
            child: Text(
              "Limpar Tudo",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    todoRepository.getTodoList().then((value) {
      setState(() {
        todos = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: todoController,
                        decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.deepPurple,
                                width: 2,
                              ),
                            ),
                            border: OutlineInputBorder(),
                            labelStyle: TextStyle(
                              color: Colors.deepPurple,
                            ),
                            errorText: errorTextMessage,
                            labelText: "Adicione uma tarefa",
                            hintText: "Ex. Fazer compras"),
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        String text = todoController.text;

                        if (text.isEmpty) {
                          setState(() {
                            errorTextMessage =
                                'Ops, título não pode ser vazio!';
                          });
                          return;
                        }

                        setState(() {
                          Todo newTodo = Todo(
                            title: text,
                            dateTime: DateTime.now(),
                          );
                          todos.add(newTodo);
                          errorTextMessage = null;
                        });
                        todoController.clear();
                        todoRepository.saveTodoList(todos);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          padding: EdgeInsets.all(12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          )),
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                Flexible(
                  child: ListView(shrinkWrap: true, children: [
                    for (Todo todo in todos)
                      ToDoListItem(
                        todo: todo,
                        deleteTodo: onDelete,
                      ),
                  ]),
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    Expanded(
                      child:
                          Text("Você possui ${todos.length} tarefas pendentes"),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    ElevatedButton(
                      onPressed: showDialogConfirmationDeleteAllTodos,
                      child: Text(
                        "Limpar tudo",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          padding: EdgeInsets.all(12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4))),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
