import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:message_test/screens/chat_image_screen.dart';

class MessageBubble extends StatefulWidget {
  MessageBubble({this.text, this.sender, this.isMe, this.isImage, this.time});
  final String sender;
  final String text;
  final bool isMe;
  final int isImage;
  final String time;

  @override
  _MessageBubbleState createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  bool isloading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.isImage == 2) {
      loadDocument();
    }
  }

  void loadDocument() async {
    setState(() {
      isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            widget.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            '${widget.sender}',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          Material(
            color: widget.isMe
                ? widget.isImage == 0
                    ? Colors.blueAccent
                    : Colors.lightBlueAccent
                : widget.isImage == 0 ? Colors.white : Colors.lightBlueAccent,
            elevation: widget.isImage != 0 ? 0.0 : 5.0,
            borderRadius: BorderRadius.circular(10.0),
            child: Padding(
                padding: widget.isImage == 0
                    ? EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0)
                    : EdgeInsets.all(5),
                child: widget.isImage == 0
                    ? Text(
                        '${widget.text}',
                        style: TextStyle(
                          color: widget.isMe ? Colors.white : Colors.black,
                          fontSize: 15.0,
                        ),
                      )
                    :
                    //widget.isImage == 1 ?
                    GestureDetector(
                        onDoubleTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatImageScreen(
                                  url: widget.text,
                                ),
                              ));
                        },
                        child: Material(
                          child: CachedNetworkImage(
                            placeholder: (context, url) => Container(
                              child: Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.blueAccent),
                                ),
                              ),
                              width: 200,
                              height: 200,
                            ),
                            errorWidget: (context, url, error) => Material(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                              child: Image.asset(
                                'images/notavailable.png',
                                width: 200,
                                height: 200,
                              ),
                              clipBehavior: Clip.hardEdge,
                            ),
                            imageUrl: widget.text,
                            width: 200,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(18.0)),
                          clipBehavior: Clip.hardEdge,
                        ),
                      )),
          ),
          Text(
            widget.time,
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
