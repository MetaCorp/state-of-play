import 'package:flutter/material.dart';
import 'package:flutter_tests/models/StateOfPlay.dart' as sop;

typedef SaveCallback = void Function(sop.Representative);

class NewStateOfPlayInterlocutorsRepresentative extends StatelessWidget {
  const NewStateOfPlayInterlocutorsRepresentative({ Key key, this.representative, this.onSave }) : super(key: key);

  final sop.Representative representative;
  final SaveCallback onSave;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Nouveau mandataire"),
        ),
        body: Column(
          children: [
            TextField(
              controller: TextEditingController(text: representative.firstName),
              decoration: InputDecoration(labelText: 'Prénom'),
              onChanged: (value) => representative.firstName = value,
            ),
            TextField(
              controller: TextEditingController(text: representative.lastName),
              decoration: InputDecoration(labelText: 'Nom'),
              onChanged: (value) => representative.lastName = value,
            ),
            TextField(
              controller: TextEditingController(text: representative.address),
              decoration: InputDecoration(labelText: 'Adresse'),
              onChanged: (value) => representative.address = value,
            ),
            TextField(
              controller: TextEditingController(text: representative.postalCode),
              decoration: InputDecoration(labelText: 'Code postal'),
              onChanged: (value) => representative.postalCode = value,
            ),
            TextField(
              controller: TextEditingController(text: representative.city),
              decoration: InputDecoration(labelText: 'Ville'),
              onChanged: (value) => representative.city = value,
            ),
            RaisedButton(
              child: Text('Sauvegarder'),
              onPressed: () {
                onSave(representative);
                Navigator.pop(context);
              }
            )
          ],
        )
      ),
    );
  }
}