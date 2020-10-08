import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'messagebubble.dart';

class MessageStream extends StatefulWidget {
  MessageStream({this.loggedinuser});
  final User loggedinuser;

  @override
  _MessageStreamState createState() => _MessageStreamState();
}

class _MessageStreamState extends State<MessageStream> {
  int _limit = 20;
  final int _limitIncrement = 20;
  final _controller = ScrollController();
  final _store = FirebaseFirestore.instance;

  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      print("reach the bottom");
      setState(() {
        print("reach the bottom");
        _limit += _limitIncrement;
      });
    }
    if (_controller.offset <= _controller.position.minScrollExtent &&
        !_controller.position.outOfRange) {
      print("reach the top");
      setState(() {
        print("reach the top");
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _store
          .collection('messages')
          .orderBy('messageTime', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        Timer(
          Duration(seconds: 1),
          () => _controller.animateTo(
            //  _controller.position.maxScrollExtent,
            0.0,
            duration: Duration(seconds: 1),
            curve: Curves.fastOutSlowIn,
          ),
        );
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        var messages = snapshot.data.docs;
        List<MessageBubble> textwidgets = messages
            .map((message) => MessageBubble(
                  text: message.get('text'),
                  sender: message.get('sender'),
                  isMe: message.get('sender') == widget.loggedinuser.email,
                  isImage: message.get('isImage'),
                  time: DateFormat("dd MMM,yy - hh:mm:aa").format(
                      DateTime.parse(
                          message.get('messageTime').toDate().toString())),
                ))
            .toList();
        return Expanded(
          // child: ListView.builder(
          //   itemCount: messages.length,
          //   itemBuilder: (context, index) => MessageBubble(
          //     text: messages[index].get('text'),
          //     sender: messages[index].get('sender'),
          //     isMe: messages[index].get('sender') == widget.loggedinuser.email,
          //     isImage: messages[index].get('isImage'),
          //     time: DateFormat("dd MMM,yy - hh:mm:aa").format(DateTime.parse(
          //         messages[index].get('messageTime').toDate().toString())),
          //   ),
          //   controller: _controller,
          // ),
          child: ListView(
            children: textwidgets,
            controller: _controller,
            reverse: true,
          ),
        );
      },
    );
  }
}
