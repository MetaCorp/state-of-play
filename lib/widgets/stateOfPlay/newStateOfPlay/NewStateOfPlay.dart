import 'package:flutter/material.dart';

class NewStateOfPlay extends StatelessWidget {
  const NewStateOfPlay({ Key key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nouvel états des lieux'),
      ),
      body: Text("new stateOfPlay")
    );
  }
}