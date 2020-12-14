import 'package:flutter/material.dart';
import 'package:flutter_tests/models/StateOfPlay.dart' as sop;

class NewStateOfPlayMiscMeter extends StatefulWidget {
  NewStateOfPlayMiscMeter({ Key key, this.meter }) : super(key: key);

  sop.Meter meter;

  @override
  _NewStateOfPlayMiscMeterState createState() => new _NewStateOfPlayMiscMeterState();
}

class _NewStateOfPlayMiscMeterState extends State<NewStateOfPlayMiscMeter> {

  @override
  Widget build(BuildContext context) {

    // print('meter.state: ' + widget.meter.state);

    return Scaffold(
      appBar: AppBar(
        title: Text('Compteurs / ' + widget.meter.type),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: Column(
        children: [
          Text("Compteur: " + widget.meter.type),
          TextField(
            controller: TextEditingController(text: widget.meter.location),
            decoration: InputDecoration(labelText: 'Emplacement'),
            onChanged: (value) => widget.meter.location = value,
          )
        ]
      ),
    );
  }
}