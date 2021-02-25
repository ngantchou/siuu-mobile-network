import 'package:flutter/material.dart';

class MessageDynamicPage extends StatefulWidget {
  @override
  _MessageDynamicPageState createState() => _MessageDynamicPageState();
}

class _MessageDynamicPageState extends State<MessageDynamicPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 150),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Image.asset("assets/images/logo.png",
            width: 120,
            height: 120,
            fit: BoxFit.fill,
          ),
          Text("You have no activity yet",
              style: TextStyle(color: Color(0xff333333), fontSize: 14)),
        ],
      ),
    );
  }
}
