import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String text;
  final String sender;
  final bool isMe;

  MessageBubble({this.text, this.sender, this.isMe});

  @override
  Widget build(BuildContext context) {
    Color bubbleColor = Colors.green[600];
    Color textColor = Colors.white;
    var alignment = CrossAxisAlignment.start;
    double topLeftRadius = 0;
    double topRightRadius = 30;

    if (isMe) {
      bubbleColor = Colors.lightBlueAccent;
      textColor = Colors.white;
      alignment = CrossAxisAlignment.end;
      topLeftRadius = 30;
      topRightRadius = 0;
    }

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: alignment,
        children: <Widget>[
          Text(
            sender,
            style: TextStyle(color: Colors.black54, fontSize: 10),
          ),
          Material(
            color: bubbleColor,
            elevation: 6,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(topLeftRadius),
              topRight: Radius.circular(topRightRadius),
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                '$text',
                style: TextStyle(color: textColor, fontSize: 17),
              ),
            ),
          ),
        ],
      ),
    );
  }
} // MessageBubble
