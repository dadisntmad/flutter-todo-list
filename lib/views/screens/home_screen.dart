import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:todo/constants.dart';
import 'package:todo/controllers/auth_controller.dart';
import 'package:todo/controllers/task_controller.dart';
import 'package:todo/navigation/navigation.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _taskController = TextEditingController();

  void logout() async {
    await AuthController().signOut();
    Navigator.of(context).popAndPushNamed(NavigationRoute.signin);
  }

  void onRemoveTask(BuildContext context, String taskId) async {
    await TaskController().remove(taskId);
  }

  void onAddTask() async {
    await TaskController().addTask(_taskController.text);
  }

  void onMakeDone(String taskId, bool done) async {
    await TaskController().markAsDone(taskId, done);
  }

  void onEditTask(BuildContext context, String taskId, String taskText) async {
    if (taskText.isNotEmpty) {
      showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: double.infinity,
            color: Colors.white,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    TextField(
                      controller: _taskController,
                      decoration: const InputDecoration(
                        hintText: 'Edit your task...',
                      ),
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          TaskController()
                              .editTask(taskId, _taskController.text);
                          Navigator.pop(context);
                          _taskController.clear();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: backgroundColor,
                        ),
                        child: const Text('Save Task'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        elevation: 0,
        actions: [
          IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onPressed: logout,
            icon: const Icon(
              Icons.logout,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('tasks')
            .orderBy('createdOn', descending: true)
            .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              final data = snapshot.data!.docs[index].data();
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Slidable(
                  endActionPane: ActionPane(
                    motion: const DrawerMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) => onRemoveTask(
                          context,
                          data['taskId'],
                        ),
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'Delete',
                      ),
                      SlidableAction(
                        onPressed: (context) => onEditTask(
                          context,
                          data['taskId'],
                          data['task'],
                        ),
                        backgroundColor: Colors.grey,
                        foregroundColor: Colors.white,
                        icon: Icons.edit,
                        label: 'Edit',
                      ),
                    ],
                  ),
                  child: ListTile(
                    tileColor: Colors.white,
                    contentPadding: const EdgeInsets.all(0),
                    leading: IconButton(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onPressed: () {
                        onMakeDone(
                          data['taskId'],
                          data['isDone'],
                        );
                      },
                      icon: Icon(
                        Icons.done,
                        color: data['isDone'] ? Colors.green : Colors.grey,
                      ),
                    ),
                    title: Text(
                      data['task'],
                      style: TextStyle(
                        decoration: data['isDone']
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    subtitle: Text(
                      DateFormat.yMMMd().format(
                        data['createdOn'].toDate(),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: backgroundColor,
        onPressed: () {
          showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) {
              return Container(
                height: double.infinity,
                color: Colors.white,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        TextField(
                          controller: _taskController,
                          decoration: const InputDecoration(
                            hintText: 'My first task...',
                          ),
                        ),
                        const SizedBox(height: 15),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              onAddTask();
                              Navigator.pop(context);
                              _taskController.clear();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: backgroundColor,
                            ),
                            child: const Text('Add Task'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
