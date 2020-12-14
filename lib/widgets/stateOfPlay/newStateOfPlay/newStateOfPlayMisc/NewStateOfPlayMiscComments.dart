import 'package:flutter/material.dart';

class NewStateOfPlayMiscComments extends StatefulWidget {
  NewStateOfPlayMiscComments({Key key}) : super(key: key);

  @override
  _NewStateOfPlayMiscCommentsState createState() => _NewStateOfPlayMiscCommentsState();
}

class _NewStateOfPlayMiscCommentsState extends State<NewStateOfPlayMiscComments> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Commentaires'),
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