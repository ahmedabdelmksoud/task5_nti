import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../database/db_helper.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  final VoidCallback onChanged;

  const TaskItem({super.key, required this.task, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListTile(
        title: Text(task.title),
        leading: Checkbox(
          value: task.isDone,
          onChanged: (v) async {
            task.isDone = v!;
            await DBHelper.updateTask(task);
            onChanged();
          },
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () async {
            await DBHelper.deleteTask(task.id!);
            onChanged();
          },
        ),
      ),
    );
  }
}
