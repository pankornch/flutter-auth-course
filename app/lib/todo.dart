import 'package:flutter/material.dart';

class TodoModel {
  final String name;
  final bool completed;

  TodoModel({
    required this.name,
    required this.completed,
  });
}

class TodoScreen extends StatefulWidget {
  const TodoScreen({Key? key}) : super(key: key);

  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final todoNameController = TextEditingController();

  final todos = [
    TodoModel(name: "Todo1", completed: false),
    TodoModel(name: "Todo2", completed: true),
    TodoModel(name: "Todo3", completed: true),
    TodoModel(name: "Todo4", completed: false),
    TodoModel(name: "Todo5", completed: true),
  ];

  void addTodo() {
    setState(() {
      todos.add(TodoModel(name: todoNameController.text, completed: false));
      todoNameController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todo Screen"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Row(
                children: [
                  Flexible(
                    child: TextField(
                      controller: todoNameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Todo name',
                      ),
                    ),
                  ),
                  SizedBox(width: 24),
                  IconButton(
                    onPressed: addTodo,
                    icon: Icon(Icons.add),
                  ),
                ],
              ),
              SizedBox(height: 24),
              Column(
                children: [
                  for (var todo in todos)
                    TodoCard(
                      todo: todo,
                    ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class TodoCard extends StatefulWidget {
  final TodoModel todo;
  TodoCard({Key? key, required this.todo}) : super(key: key);

  @override
  _TodoCardState createState() => _TodoCardState();
}

class _TodoCardState extends State<TodoCard> {
  late String name;

  late bool completed;
  late bool isEdit = false;
  final todoNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      name = widget.todo.name;
      completed = widget.todo.completed;
    });
  }

  void toggleCompleted() {
    setState(() {
      completed = !completed;
    });
  }

  void toggleEditName() {
    setState(() {
      isEdit = !isEdit;

      if (isEdit) {
        todoNameController.text = name;
      } else {
        name = todoNameController.text;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 12),
      child: ListTile(
        leading: GestureDetector(
          onTap: toggleCompleted,
          child: completed
              ? Icon(
                  Icons.check_box,
                  color: Colors.blue,
                )
              : Icon(Icons.check_box_outline_blank),
        ),
        title: isEdit
            ? TextField(
                controller: todoNameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Todo name',
                ),
              )
            : Text(name),
        trailing: IconButton(
            onPressed: toggleEditName,
            icon: isEdit ? Icon(Icons.check) : Icon(Icons.edit)),
      ),
    );
  }
}
