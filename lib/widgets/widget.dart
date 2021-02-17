import 'package:flutter/material.dart';

Widget appBarMain(BuildContext context){
  return AppBar(
    title: Container(
        child: Text("Connect"))
    //Image.asset("assets/images/title.png",height: 40,),
  );
}

InputDecoration textFeildInputDecoration(String hintText){
  return  InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        color: Colors.white54,
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color:  Colors.white),
      ),
      enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white)
      )
  );
}

TextStyle simpleTexStyle(){
  return TextStyle(
      color: Colors.white,
    fontSize: 17,
  );
}

TextStyle mediumTexStyle() {
  return TextStyle(
      color: Colors.white,
      fontSize: 17
  );

}

TextStyle blackTextStyle() {
  return TextStyle(
      color: Colors.black,
      fontSize: 17
  );

}
