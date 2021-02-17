import 'package:connect/modal/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService{

  final FirebaseAuth _auth = FirebaseAuth.instance;
  ///Condition ? TRUE:FALSE
  // ignore: non_constant_identifier_names
  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(userId: user.uid) : null;
  }

  getCurrentUser(){
    return _auth.currentUser();
  }

  signInWithGoogle(BuildContext context){
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    final GoogleSignIn _googleSignIn = GoogleSignIn();
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try{
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      // ignore: deprecated_member_use
      return _userFromFirebaseUser(user);

    }catch(e){
      print(e.toString());
      return null;
    }

  }

  Future signUpWithEmailAndPassword(String email,String password) async {

    try{
      AuthResult result = await _auth.createUserWithEmailAndPassword
        (email: email, password: password);
      FirebaseUser firebaseUser = result.user;
      return _userFromFirebaseUser(firebaseUser);
    }catch(e){
      print(e.toString());
    }
  }

  Future resetPass(String email) async {
    try{
      return await _auth.sendPasswordResetEmail(email: email);
    }catch(e){
      print(e.toString());
    }
  }

  Future signOut() async {
    try{
      return await  _auth.signOut();
    }catch(e){
      print(e.toString());
      return null;
    }
  }
}






