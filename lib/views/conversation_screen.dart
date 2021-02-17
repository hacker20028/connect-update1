import 'package:connect/helper/constants.dart';
import 'package:connect/services/database.dart';
import 'package:connect/widgets/widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ConversationScreen extends StatefulWidget {

 final String chatRoomId;
  ConversationScreen(this.chatRoomId);
  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
DatabaseMethods databaseMethods = new DatabaseMethods();
TextEditingController messageController = new TextEditingController();
Stream chatMessageStream;

  Widget chatMessageList(){
    return StreamBuilder(
      stream: chatMessageStream,
      builder: (context, snapshot){
      return snapshot.hasData ? Container(
        margin: EdgeInsets.only(bottom: 64),
        child: ListView.builder(
          reverse: true,
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index){
              return  MessageTile(snapshot.data.documents[index].data["message"],
                  snapshot.data.documents[index].data["sendBy"] == Constants.myName,
                  snapshot.data.documents[index].data["time"]);
            }),
      ) : Container();
      },
    );
  }

  sendMessage(){
    if (messageController.text.isNotEmpty){
      Map<String,dynamic> messageMap = {
        "message" : messageController.text,
        "sendBy" : Constants.myName,
        "time" : DateTime.now().microsecondsSinceEpoch,
      };
      databaseMethods.addConversationMessages(widget.chatRoomId, messageMap);
      messageController.text = "";
    }

  }

  @override
  void initState() {
   databaseMethods.getConversationMessages(widget.chatRoomId).then((value){
   setState(() {
     chatMessageStream = value;
   });
   });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
       // padding: EdgeInsets.symmetric(vertical: 50),
        child: Stack(
          children: [
            chatMessageList(),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                //Search Bar Color. TODO Put Gradient effect
                color: Color(0x54FFFFFF),
                //Search Icon Measurements=>
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                          controller: messageController,
                          style: TextStyle(
                              color: Colors.white
                          ),
                          decoration: InputDecoration(
                              hintText: "Message...",
                              hintStyle: TextStyle(
                                  color: Colors.white54
                              ),
                              border:InputBorder.none
                          )
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                       sendMessage();
                      },
                      child: Container(
                        alignment: Alignment.center,
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [
                                    Colors.yellowAccent,
                                    Colors.yellow
                                  ]
                              ),
                              borderRadius: BorderRadius.circular(40)
                          ),
                          padding: EdgeInsets.all(9),
                          ///TODO Change the icon to send icon
                          child: Icon(Icons.send),
                          //Image.asset("assets/images/search.png")
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool isSendByMe;

  MessageTile(this.message, this.isSendByMe, data, );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: isSendByMe ? 0 : 15, right: isSendByMe ? 15: 0),
      margin: EdgeInsets.symmetric(vertical: 6),
      width: MediaQuery.of(context).size.width,
      alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft ,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isSendByMe ? [
              Colors.cyanAccent,
              Colors.cyan
            ] : [
             // Colors.yellowAccent,
              Colors.amber,
              Colors.yellowAccent
            ]
          ),
              borderRadius: isSendByMe ?
            BorderRadius.only(
            topLeft: Radius.circular(23),
            topRight: Radius.circular(23),
            bottomLeft: Radius.circular(23)
        ) :
        BorderRadius.only(
        topLeft: Radius.circular(23),
    topRight: Radius.circular(23),
    bottomRight: Radius.circular(23)
    )
        ),
        child: Text(message, style: TextStyle(
          color: Colors.black,
          fontSize: 16
        ),),
      ),
    );
  }
}

