import 'package:flutter/material.dart';
import 'sqlhelper.dart';

class AddRecord extends StatefulWidget {
  const AddRecord({super.key});

  @override
  State<AddRecord> createState() => _AddRecordState();
}

class _AddRecordState extends State<AddRecord> {
  TextEditingController titlecontroller = TextEditingController();
  TextEditingController descriptioncontroller = TextEditingController();

  Future<void> _addTask() async {
    if (titlecontroller.text.isNotEmpty &&
        descriptioncontroller.text.isNotEmpty) {
      await SQLHelper.createTask(
        titlecontroller.text,
        descriptioncontroller.text,
      );

      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    titlecontroller.dispose();
    descriptioncontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Task"),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titlecontroller,
              decoration: const InputDecoration(
                hintText: "title",
                labelText: "Task Title",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: descriptioncontroller,
              decoration: const InputDecoration(
                hintText: "description",
                labelText: "Task Description",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                _addTask();
              },
              child: const Text("Add Task"),
            ),
          ],
        ),
      ),
    );
  }
}