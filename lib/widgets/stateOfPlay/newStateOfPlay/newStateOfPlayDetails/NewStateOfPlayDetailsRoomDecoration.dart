import 'package:flutter/material.dart';
import 'package:flutter_tests/models/StateOfPlay.dart' as sop;

class NewStateOfPlayDetailsRoomDecoration extends StatefulWidget {
  NewStateOfPlayDetailsRoomDecoration({ Key key, this.decoration }) : super(key: key);

  sop.Decoration decoration;

  @override
  _NewStateOfPlayDetailsRoomDecorationState createState() => new _NewStateOfPlayDetailsRoomDecorationState();
}

class _NewStateOfPlayDetailsRoomDecorationState extends State<NewStateOfPlayDetailsRoomDecoration> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Décoration")
      ),
      body: Column(
        children: [
          Text("Décoration: " + widget.decoration.type),
        ]
      ),
    );
  }
}