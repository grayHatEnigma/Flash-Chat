import 'package:cloud_firestore/cloud_firestore.dart'
    show Firestore, FieldValue, QuerySnapshot;
import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseUser, FirebaseAuth;

import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flutter/material.dart';

import 'package:flash_chat/components/message_bubble.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart' show SpinKitFadingCircle;

FirebaseUser loggedInUser;

class ChatScreen extends StatefulWidget {
  static const String id = '/chat';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  ///Variables
  final textFieldController = TextEditingController();
  final _firestore = Firestore.instance;
  final _auth = FirebaseAuth.instance;

  String userInputMsg;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                logOut();
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessagesStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: textFieldController,
                      onChanged: (value) {
                        //Do something with the user input.
                        userInputMsg = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      textFieldController.clear();
                      var data = {
                        'text': userInputMsg,
                        'sender': loggedInUser.email,
                        'timestamp': FieldValue.serverTimestamp(),
                      };
                      _firestore.collection('messages').add(data);
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///Functions

  void getCurrentUser() async {
    final user = await _auth.currentUser();
    try {
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  } // getCurrentUser

  void logOut() async {
    try {
      await _auth.signOut();
      Navigator.pushNamedAndRemoveUntil(
          context, WelcomeScreen.id, (route) => false);
    } catch (e) {
      print(e);
    }
  }
}

class MessagesStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('messages')
          .orderBy('timestamp')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: SpinKitFadingCircle(
                color: Colors.lightBlue,
                size: 50.0,
              ),
            ),
          );
        }

        var messages = snapshot.data.documents.reversed;
        List<MessageBubble> messagesBubbles = [];
        for (var message in messages) {
          final messageText = message.data['text'];
          final messageSender = message.data['sender'];

          var currentUser = loggedInUser.email;

          final messageBubble = MessageBubble(
            text: messageText,
            sender: messageSender,
            isMe: currentUser == messageSender,
          );
          messagesBubbles.add(messageBubble);
        }

        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            children: messagesBubbles,
          ),
        );
      },
    );
  }
} // MessagesStream
