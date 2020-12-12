import 'package:flutter/material.dart';
import 'package:flutter_tests/models/StateOfPlay.dart' as sop;

class NewStateOfPlayDetailsRoomElectricity extends StatefulWidget {
  NewStateOfPlayDetailsRoomElectricity({ Key key, this.electricity, this.roomName }) : super(key: key);

  sop.Electricity electricity;
  String roomName;

  @override
  _NewStateOfPlayDetailsRoomElectricityState createState() => new _NewStateOfPlayDetailsRoomElectricityState();
}

class _NewStateOfPlayDetailsRoomElectricityState extends State<NewStateOfPlayDetailsRoomElectricity> {

  final List<String> stateValues = ['Neuf', 'Bon', 'En état de marche', 'Défaillant'];

  @override
  Widget build(BuildContext context) {

    // print('electricity.state: ' + widget.electricity.state);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.roomName + ' / ' + widget.electricity.type)
      ),
      body: Column(
        children: [
          Text("Décoration: " + widget.electricity.type),
          Text("État"),
          DropdownButton(
            value: widget.electricity.state,
            items: stateValues.map((stateValue) => DropdownMenuItem(
              value: stateValue,
              child: Text(stateValue)
            )).toList(),
            onChanged: (value) {
              setState(() {
                widget.electricity.state = value;
              });
            },
          ),
          TextField(
            controller: TextEditingController(text: widget.electricity.comment),
            decoration: InputDecoration(labelText: 'Commentaires'),
            onChanged: (value) => widget.electricity.comment = value,
          )
        ]
      ),
    );
  }
}