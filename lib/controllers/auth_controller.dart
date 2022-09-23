import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo/models/user.dart';

class AuthController {
  final FirebaseAuth _authInstance = FirebaseAuth.instance;
  final FirebaseFirestore _firestoreInstance = FirebaseFirestore.instance;

  // sign up
  Future<String> signUp(String email, String password) async {
    String res = 'Some error occured';
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        UserCredential cred = await _authInstance
            .createUserWithEmailAndPassword(email: email, password: password);
        UserModel user = UserModel(uid: cred.user!.uid, email: email);
        await _firestoreInstance
            .collection('users')
            .doc(_authInstance.currentUser?.uid)
            .set(user.toJson());
        res = 'Success';
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        res = 'Email is badly formatted.';
      } else if (e.code == 'weak-password') {
        res = 'Your password is too weak.';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // sign in
  Future<String> signIn(String email, String password) async {
    String res = 'Some error occured';
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await _authInstance.signInWithEmailAndPassword(
            email: email, password: password);
        res = 'Success';
      } else {
        res = 'Please enter all the fields';
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        res = 'User not found.';
      } else if (e.code == 'wrong-password') {
        res = 'Invalid email or password';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // sign out
  Future<void> signOut() async {
    await _authInstance.signOut();
  }
}
