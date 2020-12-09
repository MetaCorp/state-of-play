import 'package:flutter/material.dart';

class NewProperty extends StatelessWidget {
  const NewProperty({ Key key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nouvelle propriété'),
      ),
      body: Text("new property")
    );
  }
}