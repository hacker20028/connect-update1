import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect/helper/constants.dart';
import 'package:connect/services/database.dart';
import 'package:connect/widgets/widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'conversation_screen.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

String _myName;

class _SearchScreenState extends State<SearchScreen> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController searchTextEditingController = new TextEditingController();

  QuerySnapshot searchSnapshot;


  Widget searchList(){
    return searchSnapshot !=null ? ListView.builder(
        itemCount: searchSnapshot.documents.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return searchTile(
            userName: searchSnapshot.documents[index].data["name"],
          );
        }) : Container();
  }

  initiateSearch(){
    databaseMethods.getUserByUsername(searchTextEditingController.text).then((val){
     setState(() {
       searchSnapshot = val;
     });
    });
  }

  /// create chatroom, send user to Conversation screen, pushreplacement
  /// Cannot send yourself message disabled function below
  createChatRoomAndStartConversation({String userName}){

    print("${Constants.myName}");
   if(userName != Constants.myName) {
     String chatRoomId = getChatRoomId(userName, Constants.myName);

     List<String> users = [userName, Constants.myName];
     Map<String, dynamic> chatRoomMap = {
       "users" : users,
       "chatroomId" : chatRoomId
     };

     DatabaseMethods().createChatRoom(chatRoomId, chatRoomMap);
     Navigator.push(context, MaterialPageRoute(
         builder: (context) => ConversationScreen(
           chatRoomId
         )
     ));
   }else{
     print ("You cannot send message to yourself");
   }
  }

  Widget searchTile({String userName}){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(userName, style: mediumTexStyle(),),
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              createChatRoomAndStartConversation(
                userName:  userName
              );
            },

            child: Container(
              decoration: BoxDecoration(
                  color: Colors.amberAccent,
                  borderRadius: BorderRadius.circular(30)
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Text("Message", style: mediumTexStyle(),),
            ),
          ),
        ],
      ),
    );
  }


  @override
  void initState() {
    initiateSearch();
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        child: Column(
          children: [
            Container(
              //Search Bar Color. TODO Put Gradient effect
              color: Color(0x54FFFFFF),
              //Search Icon Measurements=>
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                  child: TextField(
                    controller: searchTextEditingController,
                    style: TextStyle(
                        color: Colors.white
                    ),
                      decoration: InputDecoration(
                        hintText: "Search username...",
                        hintStyle: TextStyle(
                          color: Colors.white
                        ),
                          border:InputBorder.none
                      )
                  ),
                  ),
                  GestureDetector(
                    onTap: (){
                      initiateSearch();
                    },
                    child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.amberAccent,
                              Colors.yellow
                           //  const Color(0xff002fff),
                          //   const Color(0xff00f4ff)
                            ]
                          ),
                              borderRadius: BorderRadius.circular(40)
                        ),
                        padding: EdgeInsets.all(8),
                        child: Icon(Icons.search),
                       // alignment: Alignment.topLeft,


                      //  Image.asset("assets/images/search_icon.png")
                    ),
                  )
                ],
              ),
            ),
            searchList()
          ],
        ),
      ),
    );
  }
}


getChatRoomId(String a, String b) {
  if (a.substring(0,1).codeUnitAt(0) > b.substring(0 , 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}