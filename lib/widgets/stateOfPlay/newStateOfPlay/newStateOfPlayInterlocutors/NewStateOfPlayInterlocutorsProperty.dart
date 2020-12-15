import 'package:flutter/material.dart';
import 'package:flutter_tests/models/StateOfPlay.dart' as sop;

typedef SaveCallback = void Function(sop.Property);

class NewStateOfPlayInterlocutorsProperty extends StatelessWidget {
  const NewStateOfPlayInterlocutorsProperty({ Key key, this.property, this.onSave }) : super(key: key);

  final sop.Property property;
  final SaveCallback onSave;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Nouvelle propriété"),
        ),
        body: Column(
          children: [
            TextField(
              controller: TextEditingController(text: property.address),
              decoration: InputDecoration(labelText: 'Adresse'),
              onChanged: (value) => property.address = value,
            ),
            TextField(
              controller: TextEditingController(text: property.postalCode),
              decoration: InputDecoration(labelText: 'Code postal'),
              onChanged: (value) => property.postalCode = value,
            ),
            TextField(
              controller: TextEditingController(text: property.city),
              decoration: InputDecoration(labelText: 'Ville'),
              onChanged: (value) => property.city = value,
            ),
            RaisedButton(
              child: Text('Sauvegarder'),
              onPressed: () {
                onSave(property);
                Navigator.pop(context);
              }
            )
          ],
        )
      ),
    );
  }
}