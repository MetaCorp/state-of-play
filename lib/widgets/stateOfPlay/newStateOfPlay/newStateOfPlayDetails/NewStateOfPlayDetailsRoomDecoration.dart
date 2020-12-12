import 'package:flutter/material.dart';
import 'package:flutter_tests/models/StateOfPlay.dart' as sop;
import 'package:flutter_tests/utils.dart';

class NewStateOfPlayDetailsRoomDecoration extends StatefulWidget {
  NewStateOfPlayDetailsRoomDecoration({ Key key, this.decoration, this.roomName }) : super(key: key);

  sop.Decoration decoration;
  String roomName;

  @override
  _NewStateOfPlayDetailsRoomDecorationState createState() => new _NewStateOfPlayDetailsRoomDecorationState();
}

class _NewStateOfPlayDetailsRoomDecorationState extends State<NewStateOfPlayDetailsRoomDecoration> {

  final List<String> stateValues = ['Neuf', 'Bon', 'En état de marche', 'Défaillant'];

  @override
  Widget build(BuildContext context) {

    // print('decoration.state: ' + widget.decoration.state);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.roomName + ' / ' + widget.decoration.type)
      ),
      body: Column(
        children: [
          Text("Décoration: " + widget.decoration.type),
          Text("État"),
          DropdownButton(
            value: widget.decoration.state,
            items: stateValues.map((stateValue) => DropdownMenuItem(
              value: stateValue,
              child: Text(stateValue)
            )).toList(),
            onChanged: (value) {
              setState(() {
                widget.decoration.state = value;
              });
            },
          )
        ]
      ),
    );
  }
}