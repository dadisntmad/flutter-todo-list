import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo/models/task.dart';
import 'package:uuid/uuid.dart';

class TaskController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // add task
  Future<void> addTask(String taskText) async {
    try {
      String taskId = const Uuid().v1();

      TaskModel task = TaskModel(
        uid: _auth.currentUser!.uid,
        taskId: taskId,
        task: taskText,
        createdOn: FieldValue.serverTimestamp(),
        isDone: false,
      );

      await _firestore.collection('tasks').doc(taskId).set(task.toJson());
    } catch (e) {
      print(e.toString());
    }
  }

  // edit task
  Future<void> editTask(String taskId, String taskText) async {
    try {
      await _firestore.collection('tasks').doc(taskId).update({
        'task': taskText,
      });
    } catch (e) {
      print(e.toString());
    }
  }

  // isDone
  Future<void> markAsDone(String taskId, bool isDone) async {
    try {
      await _firestore.collection('tasks').doc(taskId).update(
        {
          'isDone': !isDone,
        },
      );
    } catch (e) {
      print(e.toString());
    }
  }

  // remove task
  Future<void> remove(String taskId) async {
    try {
      await _firestore.collection('tasks').doc(taskId).delete();
    } catch (e) {
      print(e.toString());
    }
  }
}
