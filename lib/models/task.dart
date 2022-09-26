// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  final String uid;
  final String taskId;
  final String task;
  final createdOn;
  final bool isDone;

  TaskModel({
    required this.uid,
    required this.taskId,
    required this.task,
    required this.createdOn,
    this.isDone = false,
  });

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'taskId': taskId,
        'task': task,
        'createdOn': createdOn,
        'isDone': isDone,
      };

  static TaskModel fromSnap(DocumentSnapshot snapshot) {
    var snap = snapshot.data() as Map<String, dynamic>;

    return TaskModel(
      uid: snap['uid'],
      taskId: snap['taskId'],
      task: snap['task'],
      createdOn: snap['createdOn'],
      isDone: snap['isDone'],
    );
  }
}
