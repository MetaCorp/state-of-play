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
              decoration: InputDecoration(labelText: 'Prénom'),
              onChanged: (value) => owner.firstName = value,
            ),
            TextField(
              controller: TextEditingController(text: owner.lastName),
              decoration: InputDecoration(labelText: 'Nom'),
              onChanged: (value) => owner.lastName = value,
            ),
            TextField(
              controller: TextEditingController(text: owner.address),
              decoration: InputDecoration(labelText: 'Adresse'),
              onChanged: (value) => owner.address = value,
            ),
            TextField(
              controller: TextEditingController(text: owner.postalCode),
              decoration: InputDecoration(labelText: 'Code postal'),
              onChanged: (value) => owner.postalCode = value,
            ),
            TextField(
              controller: TextEditingController(text: owner.city),
              decoration: InputDecoration(labelText: 'Ville'),
              onChanged: (value) => owner.city = value,
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