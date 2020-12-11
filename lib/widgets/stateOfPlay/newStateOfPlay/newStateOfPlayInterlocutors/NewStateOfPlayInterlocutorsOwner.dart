import 'package:flutter/material.dart';
import 'package:flutter_tests/models/StateOfPlay.dart' as sop;

typedef SaveCallback = void Function(sop.Owner);

class NewStateOfPlayInterlocutorsOwner extends StatelessWidget {
  const NewStateOfPlayInterlocutorsOwner({ Key key, this.owner, this.onSave }) : super(key: key);

  final sop.Owner owner;
  final SaveCallback onSave;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Nouveau propriétaire"),
        ),
        body: Column(
          children: [
            TextField(
              controller: TextEditingController(text: owner.firstName),
              decoration: InputDecoration(hintText: 'Prénom'),
              onChanged: (value) => owner.firstName = value,
            ),
            TextField(
              controller: TextEditingController(text: owner.lastName),
              decoration: InputDecoration(hintText: 'Nom'),
              onChanged: (value) => owner.lastName = value,
            ),
            RaisedButton(
              child: Text('Sauvegarder'),
              onPressed: () {
                onSave(owner);
                Navigator.pop(context);
              }
            )
          ],
        )
      ),
    );
  }
}