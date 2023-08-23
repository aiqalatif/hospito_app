import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  FirebaseAuth _auth = FirebaseAuth.instance;
  //create user with email and password
  Future createUserWithEmailAndPassword(String email, String password) async {
    print(email);
    print(password);
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      print(user!.email);
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //Sign in user with existing email and password
  Future signInUserWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = userCredential.user;
      return user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  //check user in auth
  getUser() {
    if (_auth.currentUser != null) {
      return true;
    } else {
      return false;
    }
  }

  //log out
  Future logout() async {
    return _auth.signOut();
  }

  //get uid
  getUid() {
    return _auth.currentUser!.uid;
  }
}
