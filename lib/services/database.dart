import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
class DatabaseMethods{
  var _fcm;

  var uid;

  var _db;


  getUserByUsername(String username)async{
   return await Firestore.instance.collection("users")
        .where("name", isEqualTo: username)
        .getDocuments();

  }

  getUserByUserEmail(String userEmail)async{
    return await Firestore.instance.collection("users")
        .where("email", isEqualTo: userEmail)
        .getDocuments();

  }

  uploadUserInfo(userMap){
    Firestore.instance.collection("users")
        .add(userMap).catchError((e){
         print(e.toString());
    });
  }

  createChatRoom(String chatRoomId, chatRoomMap){
    Firestore.instance.collection("ChatRoom")
        .document(chatRoomId).setData(chatRoomMap).catchError((e){
          print(e.toString());
    });
  }

  addConversationMessages (String chatRoomId, messageMap){
    Firestore.instance.collection("ChatRoom")
        .document(chatRoomId)
        .collection("chats")
        .add(messageMap).catchError((e){print(e.toString());});

  }

  getConversationMessages (String chatRoomId)async{
   return await Firestore.instance.collection("ChatRoom")
        .document(chatRoomId)
        .collection("chats")
        .orderBy("time", descending: true)
        .snapshots();

  }
  
  getChatRooms(String userName)async{
    return await Firestore.instance.collection("ChatRoom")
        .where("users", arrayContains: userName)
        .snapshots();
  }
  _saveDeviceToken()async{
    FirebaseUser user = await _auth.currentUser();
    String fcmToken = await _fcm.getTocken();
    if(fcmToken != null) {
      var tokenRef = _db
          .collection('users')
          .documents(uid)
          .collection('tokens');

      await tokenRef.setData({
        'token' : fcmToken,
        'createdAt' : FieldValue.serverTimestamp(),
       // 'platform' : Platform.Operating
      });
    }
  }

}