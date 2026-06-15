import 'package:flutter/material.dart';
import 'sqlhelper.dart';
import 'addrecord.dart';
import 'editrecord.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _tasks = [];

  void _refreshData() async {
    final data = await SQLHelper.getTasks();

    setState(() {
      _tasks = data;
      _isLoading = false;
    });
  }

  void _deleteTask(int id) async {
    await SQLHelper.deleteTask(id);
    _refreshData();
  }

  void _showDeleteDialog(int id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Task"),
          content: const Text("Are you sure you want to delete this task?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () {
                _deleteTask(id);
                Navigator.pop(context);
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  void _changeStatus(Map<String, dynamic> task) async {
    int newStatus = task['isComplete'] == 0 ? 1 : 0;

    await SQLHelper.updateTask(
      task['id'],
      task['title'],
      task['description'],
      newStatus,
    );

    _refreshData();
  }

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "To-Do App",
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("To-Do App"),
          backgroundColor: Colors.orange,
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _tasks.isEmpty
                ? const Center(
                    child: Text("No tasks found"),
                  )
                : ListView.builder(
                    itemCount: _tasks.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.all(10),
                        child: ListTile(
                          leading: IconButton(
                            icon: Icon(
                              _tasks[index]['isComplete'] == 1
                                  ? Icons.check_circle
                                  : Icons.radio_button_unchecked,
                              color: _tasks[index]['isComplete'] == 1
                                  ? Colors.green
                                  : Colors.grey,
                            ),
                            onPressed: () {
                              _changeStatus(_tasks[index]);
                            },
                          ),
                          title: Text(
                            _tasks[index]['title'],
                            style: TextStyle(
                              decoration: _tasks[index]['isComplete'] == 1
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                          subtitle: Text(_tasks[index]['description']),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditRecord(
                                        id: _tasks[index]['id'].toString(),
                                      ),
                                    ),
                                  ).then((_) => _refreshData());
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  _showDeleteDialog(_tasks[index]['id']);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.orange,
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddRecord(),
              ),
            ).then((_) => _refreshData());
          },
        ),
      ),
    );
  }
}
