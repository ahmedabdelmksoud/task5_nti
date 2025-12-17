import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../models/task_model.dart';

class ProfilePage extends StatefulWidget {
  final int userId;
  const ProfilePage({super.key, required this.userId});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<Task> doneTasks = [];

  @override
  void initState() {
    super.initState();
    loadDoneTasks();
  }

  Future loadDoneTasks() async {
    final allTasks = await DBHelper.getTasks();
    doneTasks = allTasks.where((e) => e.isDone).toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Completed Tasks')),
      body: doneTasks.isEmpty
          ? const Center(child: Text('No completed tasks'))
          : ListView.builder(
              itemCount: doneTasks.length,
              itemBuilder: (context, i) {
                return ListTile(
                  leading: const Icon(Icons.check_circle, color: Colors.green),
                  title: Text(doneTasks[i].title),
                );
              },
            ),
    );
  }
}
