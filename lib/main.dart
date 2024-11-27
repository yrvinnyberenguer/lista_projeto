import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Tarefas',
      theme: ThemeData(
        primaryColor: Color.fromARGB(255, 93, 113, 224), // Cor primária
        scaffoldBackgroundColor: Color.fromARGB(255, 167, 193, 245), // Cor de fundo
        textTheme: TextTheme(
          bodyMedium: TextStyle(fontFamily: 'Arial'),
          titleLarge: TextStyle(
            fontFamily: 'Times New Roman', 
            fontWeight: FontWeight.bold, 
            fontSize: 24,
          ), // Título com "Times New Roman"
        ),
      ),
      home: TodoApp(),
    );
  }
}

class TodoApp extends StatefulWidget {
  @override
  _TodoAppState createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  // Lista de tarefas com seu estado (concluída ou não)
  final List<Map<String, dynamic>> _tasks = [];
  final TextEditingController _taskController = TextEditingController();

  // Adiciona uma nova tarefa
  void _addTask(String task) {
    if (task.isNotEmpty) {
      setState(() {
        _tasks.add({'title': task, 'done': false});
      });
      _taskController.clear(); // Limpa o campo de texto
      Navigator.of(context).pop(); // Fecha o modal
    }
  }

  // Remove uma tarefa
  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  // Marca ou desmarca uma tarefa como concluída
  void _toggleTaskStatus(int index) {
    setState(() {
      _tasks[index]['done'] = !_tasks[index]['done'];
    });
  }

  // Modal para adicionar tarefa
  void _showAddTaskModal() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Nova Tarefa',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              TextField(
                controller: _taskController,
                decoration: InputDecoration(
                  hintText: 'Digite sua tarefa',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => _addTask(_taskController.text),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 93, 113, 224),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text('Adicionar'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Lista de Tarefas',
          style: TextStyle(
            fontFamily: 'Times New Roman', 
            fontWeight: FontWeight.bold, 
            fontSize: 24,
          ),
        ),
        centerTitle: true,
      ),
      body: _tasks.isEmpty
          ? Center(
              child: Text(
                'Nenhuma tarefa adicionada!',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 2,
                  margin: EdgeInsets.symmetric(vertical: 5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    leading: Checkbox(
                      value: _tasks[index]['done'],
                      onChanged: (bool? value) {
                        _toggleTaskStatus(index);
                      },
                    ),
                    title: Text(
                      _tasks[index]['title'],
                      style: TextStyle(
                        fontSize: 16,
                        decoration: _tasks[index]['done']
                            ? TextDecoration.lineThrough
                            : null,
                        color: _tasks[index]['done']
                            ? Colors.grey
                            : Colors.black,
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () => _deleteTask(index),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskModal,
        backgroundColor: Colors.indigo,
        child: Icon(Icons.add),
      ),
    );
  }
}
