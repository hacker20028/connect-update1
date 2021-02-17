import 'package:connect/helper/helperfunctions.dart';
import 'package:connect/services/auth.dart';
import 'package:connect/services/database.dart';
import 'package:connect/views/chatRoomsScreen.dart';
import 'package:connect/widgets/widget.dart';
import 'package:flutter/material.dart';

class SignUP extends StatefulWidget {
  final Function toggle;
  SignUP(this.toggle);

  @override
  _SignUPState createState() => _SignUPState();
}

class _SignUPState extends State<SignUP> {

  bool isLoading = false;

  AuthService authMethods = new AuthService();
  DatabaseMethods databaseMethods = new DatabaseMethods();



  final formKey = GlobalKey<FormState>();
  TextEditingController userNameTextEditingController = new TextEditingController();
  TextEditingController emailTextEditingController = new TextEditingController();
  TextEditingController passwordTextEditingController = new TextEditingController();

  signMeUp(){
    if(formKey.currentState.validate()){
      Map<String, String> userInfoMap = {
        "name" : userNameTextEditingController.text,
        "email" : emailTextEditingController.text

      };

     HelperFunctions.saveUserEmailSharedPreference(emailTextEditingController.text);
     HelperFunctions.saveUserNameSharedPreference(userNameTextEditingController.text);


      setState(() {
        isLoading = true;
      });
        authMethods.signUpWithEmailAndPassword(emailTextEditingController.text,
            passwordTextEditingController.text).then((val){
          //  print("${val.uId}");
          

          databaseMethods.uploadUserInfo(userInfoMap);
          HelperFunctions.saveUserLoggedInSharedPreference(true);

            Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) => ChatRoom()
            ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: isLoading ? Container(
        child: Center(child: CircularProgressIndicator()),
      ) : SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - 50,
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize:  MainAxisSize.min,
              children: [

                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (val){
                          return val.isEmpty || val.length < 3 ? "You know that won't work right?" : null;
                        },
                        controller: userNameTextEditingController,
                        style: simpleTexStyle(),
                        decoration: textFeildInputDecoration("username"),
                      ),

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
                    ],
                  ),
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
                   signMeUp();
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
                    child: Text("Sign Up", style: mediumTexStyle(),),
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
                  child: Text("Sign Up with Google", style: TextStyle(
                      color: Colors.black87,
                      fontSize: 17
                  ),),
                ),

                SizedBox(height: 16,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account?", style: mediumTexStyle(),),
                    GestureDetector(
                        onTap: (){
                          widget.toggle();
                        },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text("Login Now", style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        decoration: TextDecoration.underline
                    )),
                    )
                    )
                  ],
                ),
                SizedBox(height: 50,),
              ],
            ),
          ),
        ),
      )
    );
  }
}



