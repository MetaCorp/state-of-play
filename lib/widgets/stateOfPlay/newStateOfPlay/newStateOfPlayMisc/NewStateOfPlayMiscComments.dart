import 'package:flutter/material.dart';
import 'package:flutter_tests/models/StateOfPlay.dart' as sop;

class NewStateOfPlayMiscComments extends StatefulWidget {
  NewStateOfPlayMiscComments({ Key key, this.stateOfPlay }) : super(key: key);

  sop.StateOfPlay stateOfPlay;

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
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: TextEditingController(text: widget.stateOfPlay.comments),
              decoration: InputDecoration(labelText: 'Commentaires'),
              onChanged: (value) => widget.stateOfPlay.comments = value,
            ),
            SizedBox(
              height: 8,
            ),
            TextField(
              controller: TextEditingController(text: widget.stateOfPlay.reserve),
              decoration: InputDecoration(labelText: 'Réserve'),
              onChanged: (value) => widget.stateOfPlay.reserve = value,
            )
          ],
        ),
      ),
    );
  }
}