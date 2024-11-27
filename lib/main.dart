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
        primaryColor: Color.fromARGB(255, 93, 113, 224),
        scaffoldBackgroundColor: Color.fromARGB(255, 167, 193, 245),
        textTheme: TextTheme(
          bodyMedium: TextStyle(fontFamily: 'Arial'),
          titleLarge: TextStyle(
            fontFamily: 'Times New Roman',
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
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
  final Map<String, List<Map<String, dynamic>>> _tasksByCategory = {
    "A Fazer": [],
    "Em Andamento": [],
    "Concluído": [],
  };

  final TextEditingController _taskController = TextEditingController();
  String _selectedCategory = "A Fazer";

  void _addTask() {
    if (_taskController.text.isNotEmpty) {
      setState(() {
        _tasksByCategory[_selectedCategory]!.add({'title': _taskController.text});
      });
      _taskController.clear();
      Navigator.of(context).pop();
    }
  }

  void _deleteTask(String category, int index) {
    setState(() {
      _tasksByCategory[category]!.removeAt(index);
    });
  }

  void _moveTask(String task, String fromCategory, String toCategory) {
    setState(() {
      _tasksByCategory[fromCategory]!.removeWhere((item) => item['title'] == task);
      _tasksByCategory[toCategory]!.add({'title': task});
    });
  }

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
                'Adicionar Nova Tarefa',
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
                onSubmitted: (_) => _addTask(), // Adiciona a tarefa ao pressionar Enter
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: _tasksByCategory.keys.map((String category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelText: 'Selecione a categoria',
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _addTask,
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

  Widget _buildTaskBox(String category) {
    return Expanded(
      child: DragTarget<Map<String, String>>(
        onWillAccept: (data) => data != null && data['from'] != category,
        onAccept: (data) {
          _moveTask(data['task']!, data['from']!, category);
        },
        builder: (context, candidateData, rejectedData) {
          return Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 5,
                  offset: Offset(2, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  category,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                Divider(),
                if (_tasksByCategory[category]!.isEmpty)
                  Text(
                    'Sem tarefas',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  )
                else
                  ..._tasksByCategory[category]!.asMap().entries.map((entry) {
                    final index = entry.key;
                    final task = entry.value;
                    return Draggable<Map<String, String>>(
                      data: {'task': task['title'], 'from': category},
                      child: ListTile(
                        title: Text(
                          task['title'],
                          style: TextStyle(
                            decoration: category == "Concluído"
                                ? TextDecoration.lineThrough
                                : null,
                            color: category == "Concluído"
                                ? Colors.grey
                                : Colors.black,
                          ),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.redAccent),
                          onPressed: () => _deleteTask(category, index),
                        ),
                      ),
                      feedback: Material(
                        child: Container(
                          padding: EdgeInsets.all(8),
                          color: Colors.blueAccent,
                          child: Text(
                            task['title'],
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      childWhenDragging: Opacity(
                        opacity: 0.5,
                        child: ListTile(
                          title: Text(
                            task['title'],
                            style: TextStyle(
                              decoration: category == "Concluído"
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
              ],
            ),
          );
        },
      ),
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildTaskBox("A Fazer"),
            _buildTaskBox("Em Andamento"),
            _buildTaskBox("Concluído"),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskModal,
        backgroundColor: Colors.indigo,
        child: Icon(Icons.add),
      ),
    );
  }
}
