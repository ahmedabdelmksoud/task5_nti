import 'package:flutter/material.dart';
import 'package:task5_nti/models/task_model.dart';
import 'package:task5_nti/screens/profile_page.dart';
import '../database/db_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Task> tasks = [];
  TextEditingController taskController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  Future<void> loadTasks() async {
    tasks = await DBHelper.getTasks();
    setState(() {});
  }

  void addTask() async {
    if (taskController.text.isEmpty) return;

    await DBHelper.insertTask(Task(title: taskController.text));

    taskController.clear();
    loadTasks();
    Navigator.pop(context);
  }

  void showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add Task"),
        content: TextField(
          controller: taskController,
          decoration: const InputDecoration(hintText: "Enter task"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(onPressed: addTask, child: const Text("Add")),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int totalTasks = tasks.length;
    int doneTasks = tasks.where((e) => e.isDone).length;

    return Scaffold(
      appBar: AppBar(title: const Text("Tasks Page")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Counters
            Text(
              "Total Tasks: $totalTasks",
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              "Done Tasks: $doneTasks",
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 16),

            /// Add Task Field
            TextField(
              controller: taskController,
              decoration: InputDecoration(
                hintText: "add your task here",
                suffixIcon: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: showAddTaskDialog,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// Tasks List
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];

                  return Card(
                    child: ListTile(
                      leading: Checkbox(
                        value: task.isDone,
                        onChanged: (value) async {
                          task.isDone = value!;
                          await DBHelper.updateTask(task);
                          loadTasks();
                        },
                      ),
                      title: Text(
                        task.title,
                        style: TextStyle(
                          decoration: task.isDone
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          await DBHelper.deleteTask(task.id!);
                          loadTasks();
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage()),
            );
          },
          child: const Text("Go to Profile Page"),
        ),
      ),
    );
  }
}
