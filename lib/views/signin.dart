import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect/helper/helperfunctions.dart';
import 'package:connect/services/auth.dart';
import 'package:connect/services/database.dart';
import 'package:connect/widgets/widget.dart';
import 'package:flutter/material.dart';

import 'chatRoomsScreen.dart';

class SignIn extends StatefulWidget {
  final Function toggle;
  SignIn(this.toggle);
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final formKey = GlobalKey<FormState>();
  AuthService authMethods = new AuthService();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  TextEditingController emailTextEditingController = new TextEditingController();
  TextEditingController passwordTextEditingController = new TextEditingController();

  bool isLoading = false;
  QuerySnapshot snapshotUserInfo;

  signIn () {
    if(formKey.currentState.validate()){
      HelperFunctions.saveUserEmailSharedPreference(emailTextEditingController.text);

      setState(() {
        isLoading = true;
      });
      databaseMethods.getUserByUserEmail(emailTextEditingController.text)
      .then((val){
        snapshotUserInfo = val;
        HelperFunctions.saveUserNameSharedPreference(snapshotUserInfo.documents[0].data["name"]);

        //print("${snapshotUserInfo.documents[0].data["name"]} Creating this app was a real Headache!!");
      });

      authMethods.signInWithEmailAndPassword(emailTextEditingController.text,
          passwordTextEditingController.text).then((val){
       if (val != null){

         HelperFunctions.saveUserLoggedInSharedPreference(true);
         Navigator.pushReplacement(context, MaterialPageRoute(
             builder: (context) => ChatRoom()
         ));
       }
      });


    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - 50,
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize:  MainAxisSize.min,
              children: [
               Form(
                 key: formKey ,
                 child: Column(children: [
                   TextFormField(
                     validator: (val){
                       return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val) ?
                       null : "Damn! Check your Email";
                     },
                     controller: emailTextEditingController,
                     style: simpleTexStyle(),
                     decoration: textFeildInputDecoration("Email"),
                   ),

                   TextFormField(
                     obscureText: true,
                     validator: (val){
                       return val.length > 6 ? null : "I have some Hacker Friends,\nSo better make your password of 6+ Characters";
                     },
                     controller: passwordTextEditingController,
                     style: simpleTexStyle(),
                     decoration: textFeildInputDecoration("Password"),
                   ),
                 ],),
               ),

                SizedBox(height: 8,),

                Container(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text("Forgot Password?", style: simpleTexStyle(),),
                  ),
                ),

                SizedBox(height: 8,),

                GestureDetector(
                  onTap: (){
                    signIn();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xff007EF4),
                          const Color(0xff2A75BC)
                        ]
                      ),
                          borderRadius: BorderRadiusDirectional.circular(30)
                    ),
                    child: Text("Login", style: mediumTexStyle(),),
                  ),
                ),

                SizedBox(height: 16,),

                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                      color:  Colors.white,
                      borderRadius: BorderRadiusDirectional.circular(30)
                  ),
                  child: Text("Sign In with Google", style: TextStyle(
                      color: Colors.black87,
                      fontSize: 17
                  ),),
                ),

                SizedBox(height: 16,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account?", style: mediumTexStyle(),),
                    GestureDetector(
                      onTap: (){
                        widget.toggle();
                      },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child:Text("Register Now", style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        decoration: TextDecoration.underline ,
                    ),)
                    )
                    )
                  ],
                ),
                SizedBox(height: 50,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
