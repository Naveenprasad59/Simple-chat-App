import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ChatImageScreen extends StatelessWidget {
  ChatImageScreen({this.url});
  final url;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("FULL IMAGE"),
      ),
      body: Container(
     //   margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
               child: CachedNetworkImage(
                 imageUrl: url,
                 placeholder: (context, url) => CircularProgressIndicator(
                   valueColor: AlwaysStoppedAnimation<Color>(
                       Colors.blueAccent),
                 ),
                 errorWidget: (context, url, error) => Material(
                   borderRadius:
                   BorderRadius.all(Radius.circular(8.0)),
                   child: Image.asset('images/notavailable.png'),
                   clipBehavior: Clip.hardEdge,
                 ),
               ),
              // Image(
              //   image: NetworkImage(url),
              //   fit: BoxFit.fill,
              // ),
            ),
          ],
        ),
      ),
    );
  }
}
