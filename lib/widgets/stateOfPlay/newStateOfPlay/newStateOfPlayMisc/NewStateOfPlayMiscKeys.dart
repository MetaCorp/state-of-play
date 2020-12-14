import 'package:flutter/material.dart';

class NewStateOfPlayMiscKeys extends StatefulWidget {
  NewStateOfPlayMiscKeys({Key key}) : super(key: key);

  @override
  _NewStateOfPlayMiscKeysState createState() => _NewStateOfPlayMiscKeysState();
}

class _NewStateOfPlayMiscKeysState extends State<NewStateOfPlayMiscKeys> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Clés'),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: Text('Comments'),
    );
  }
}