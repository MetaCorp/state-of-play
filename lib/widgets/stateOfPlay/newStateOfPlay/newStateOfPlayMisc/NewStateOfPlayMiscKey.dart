import 'package:flutter/material.dart';
import 'package:flutter_tests/models/StateOfPlay.dart' as sop;

class NewStateOfPlayMiscKey extends StatefulWidget {
  NewStateOfPlayMiscKey({ Key key, this.sKey }) : super(key: key);

  sop.Key sKey;

  @override
  _NewStateOfPlayMiscKeyState createState() => new _NewStateOfPlayMiscKeyState();
}

class _NewStateOfPlayMiscKeyState extends State<NewStateOfPlayMiscKey> {

  @override
  Widget build(BuildContext context) {

    // print('sKey.state: ' + widget.sKey.state);

    return Scaffold(
      appBar: AppBar(
        title: Text('Clés / ' + widget.sKey.type),
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
          Text("Clé: " + widget.sKey.type),
          TextField(
            controller: TextEditingController(text: widget.sKey.comments),
            decoration: InputDecoration(labelText: 'Commentaires'),
            onChanged: (value) => widget.sKey.comments = value,
          )
        ]
      ),
    );
  }
}