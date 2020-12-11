

import 'package:flutter/material.dart';

class EditStateOfPlay extends StatelessWidget {
  const EditStateOfPlay({ Key key, this.stateOfPlayId }) : super(key: key);

  final String stateOfPlayId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Éditer un état des lieux"),
      ),
      body: Text("Edit stateOfPlay: " + stateOfPlayId),
    );
  }
}