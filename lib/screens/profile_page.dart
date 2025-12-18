import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task5_nti/database/db_helper.dart';
import 'package:task5_nti/models/task_model.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({super.key});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<Task> doneTasks = [];
  File? profileImage;
  @override
  void initState() {
    super.initState();
    _loadDoneTasks();
  }


  void _loadDoneTasks() async {
    final tasks = await DBHelper.getTasks();
    setState(() {
      doneTasks = tasks.where((Task) => Task.isDone).toList();
    });
  }


  Future pickImage() async {
    final picker = ImagePicker();
    final PickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (PickedFile != null) {
      setState(() {
        profileImage = File(PickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: profileImage != null
                    ? FileImage(profileImage!)
                    : null,
                child: profileImage == null
                    ? Icon(Icons.person, size: 50)
                    : null,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'My Profile',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: doneTasks.length,
                itemBuilder: (context, index) {
                  final task = doneTasks[index];
                  return Card(
                    child: ListTile(
                      leading: Icon(Icons.check_box, color: Colors.green),
                      title: Text(task.title),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
