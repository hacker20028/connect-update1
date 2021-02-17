import 'package:connect/helper/authenticate.dart';
import 'package:connect/helper/constants.dart';
import 'package:connect/helper/helperfunctions.dart';
import 'package:connect/services/auth.dart';
import 'package:connect/services/database.dart';
import 'package:connect/views/conversation_screen.dart';
import 'package:connect/views/search.dart';
import 'package:connect/widgets/widget.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {

  AuthService authMethods = new AuthService();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  Stream chatRoomStream;

  Widget chatRoomList(){
    return StreamBuilder(
      stream: chatRoomStream,
      builder: (context, snapshot){
        return snapshot.hasData ? ListView.builder(
          itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index){
           return ChatRoomTile(
             snapshot.data.documents[index].data["chatroomId"]
                 .toString().replaceAll("_", "").replaceAll(Constants.myName, ""),
               snapshot.data.documents[index].data["chatroomId"]
           );
        }) : Container();
      },
    );
  }

  @override
  void initState() {
    getUserInfo();

    super.initState();
  }

  getUserInfo()async{
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    databaseMethods.getChatRooms(Constants.myName).then((value){
      setState(() {
        chatRoomStream = value;
      });
    });
   setState(() {

   });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Connect") ,
        //Image.asset("assets/images/title.png",height: 40,);
        actions: [
          GestureDetector(
            onTap: (){
              authMethods.signOut();
              Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) => Authenticate()
              ) );

            },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child:Icon(Icons.exit_to_app))
          )
        ],
      ),
      body: chatRoomList(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amberAccent,
        child: Icon(Icons.search, color: Colors.black,),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(
              builder: (context) => SearchScreen()
          ));
        },
      ),
    );
  }
}

class ChatRoomTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;
  ChatRoomTile(this.userName, this.chatRoomId);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => ConversationScreen(chatRoomId)
        ));
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 1),
        child: Container(
          color: Colors.black26,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Container(
                height: 40,
                width: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.amberAccent,
                  borderRadius: BorderRadius.circular(40)
                ),
                child: Container(

                 // color: Colors.black,


                  child: Text("${userName.substring(0,1).toUpperCase()}",
                    style: blackTextStyle(),),
                )),

              SizedBox(width: 8,),
              Text(userName, style: mediumTexStyle(),)
            ],
          ),
        ),
      ),
    );
  }
}

