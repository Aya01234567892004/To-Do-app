import 'package:flutter/material.dart';
import 'sqlhelper.dart';

class EditRecord extends StatefulWidget {
  final String id;

  const EditRecord({super.key, required this.id});

  @override
  State<EditRecord> createState() => _EditRecordState();
}

class _EditRecordState extends State<EditRecord> {
  TextEditingController titlecontroller = TextEditingController();
  TextEditingController descriptioncontroller = TextEditingController();

  int isComplete = 0;

  Future<void> _getTask() async {
    final data = await SQLHelper.getTask(int.parse(widget.id));

    setState(() {
      titlecontroller.text = data[0]['title'] as String;
      descriptioncontroller.text = data[0]['description'] as String;
      isComplete = data[0]['isComplete'];
    });
  }

  Future<void> _updateTask() async {
    await SQLHelper.updateTask(
      int.parse(widget.id),
      titlecontroller.text,
      descriptioncontroller.text,
      isComplete,
    );

    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    _getTask();
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
        title: const Text("Edit Task"),
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
            Row(
              children: [
                const Text("Completed"),
                Checkbox(
                  value: isComplete == 1,
                  onChanged: (value) {
                    setState(() {
                      isComplete = value == true ? 1 : 0;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                _updateTask();
              },
              child: const Text("Update Task"),
            ),
          ],
        ),
      ),
    );
  }
}