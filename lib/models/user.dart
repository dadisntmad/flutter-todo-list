import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String uid;
  String email;

  UserModel({
    required this.uid,
    required this.email,
  });

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'email': email,
      };

  static UserModel fromSnap(DocumentSnapshot snapshot) {
    var snap = snapshot.data() as Map<String, dynamic>;

    return UserModel(
      uid: snap['uid'],
      email: snap['email'],
    );
  }
}
