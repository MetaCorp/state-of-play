import 'package:flutter/material.dart';
import 'package:flutter_tests/models/StateOfPlay.dart' as sop;
import 'package:flutter_tests/utils.dart';

class NewStateOfPlayDetailsRoomDecoration extends StatefulWidget {
  NewStateOfPlayDetailsRoomDecoration({ Key key, this.decoration }) : super(key: key);

  sop.Decoration decoration;

  @override
  _NewStateOfPlayDetailsRoomDecorationState createState() => new _NewStateOfPlayDetailsRoomDecorationState();
}

class _NewStateOfPlayDetailsRoomDecorationState extends State<NewStateOfPlayDetailsRoomDecoration> {

  final List<String> stateValues = ['Neuf', 'Bon', 'En état de marche', 'Défaillant'];

  @override
  Widget build(BuildContext context) {

    print('decoration.state: ' + widget.decoration.state);

    return Scaffold(
      appBar: AppBar(
        title: Text("Décoration")
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
            )).toList()
          )
        ]
      ),
    );
  }
}