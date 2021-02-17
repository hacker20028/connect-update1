import 'package:connect/helper/authenticate.dart';
import 'package:connect/helper/helperfunctions.dart';
import 'package:connect/views/chatRoomsScreen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState(
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown, DeviceOrientation.portraitUp])
  );
}

class _MyAppState extends State<MyApp> {

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  bool userIsLoggedIn;

  String title  ="title";
  String helper = "helper";

  _MyAppState(Future<void> setPreferredOrientations);

  @override
  void initState() {
   getLoggedInState();

   _firebaseMessaging.configure(
     onResume: (message) async {
     setState(() {
       title = message["notification"]["title"];
       helper = "You have received a Notification";
     });
     },
     onLaunch: (message) async {
       setState(() {
         title = message["notification"]["title"];
         helper = "You have received a Notification";
       });
     },
   );
    super.initState();
  }

  getLoggedInState()async{
    await HelperFunctions.getUserLoggedInSharedPreference().then((value){
      setState(() {
        userIsLoggedIn = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Connect',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.amberAccent,
        scaffoldBackgroundColor: Color(0xff1F1F1F),

        primarySwatch: Colors.blue,

        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: userIsLoggedIn!= null ? /**/ userIsLoggedIn ? ChatRoom() :  Authenticate() /**/
      : Authenticate(),

    );
  }
}



