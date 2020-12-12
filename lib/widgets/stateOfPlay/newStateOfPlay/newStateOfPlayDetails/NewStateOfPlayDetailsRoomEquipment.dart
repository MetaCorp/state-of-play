import 'package:flutter/material.dart';
import 'package:flutter_tests/models/StateOfPlay.dart' as sop;

class NewStateOfPlayDetailsRoomEquipment extends StatefulWidget {
  NewStateOfPlayDetailsRoomEquipment({ Key key, this.equipment, this.roomName }) : super(key: key);

  sop.Equipment equipment;
  String roomName;

  @override
  _NewStateOfPlayDetailsRoomEquipmentState createState() => new _NewStateOfPlayDetailsRoomEquipmentState();
}

class _NewStateOfPlayDetailsRoomEquipmentState extends State<NewStateOfPlayDetailsRoomEquipment> {

  final List<String> stateValues = ['Neuf', 'Bon', 'En état de marche', 'Défaillant'];

  @override
  Widget build(BuildContext context) {

    // print('equipment.state: ' + widget.equipment.state);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.roomName + ' / ' + widget.equipment.type)
      ),
      body: Column(
        children: [
          Text("Décoration: " + widget.equipment.type),
          Text("État"),
          DropdownButton(
            value: widget.equipment.state,
            items: stateValues.map((stateValue) => DropdownMenuItem(
              value: stateValue,
              child: Text(stateValue)
            )).toList(),
            onChanged: (value) {
              setState(() {
                widget.equipment.state = value;
              });
            },
          ),
          TextField(
            controller: TextEditingController(text: widget.equipment.brandOrObject),
            decoration: InputDecoration(labelText: 'Marque/Objet'),
            onChanged: (value) => widget.equipment.brandOrObject = value,
          ),
          TextField(
            controller: TextEditingController(text: widget.equipment.comment),
            decoration: InputDecoration(labelText: 'Commentaires'),
            onChanged: (value) => widget.equipment.comment = value,
          )
        ]
      ),
    );
  }
}