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
              decoration: InputDecoration(hintText: 'Prénom'),
              onChanged: (value) => representative.firstName = value,
            ),
            TextField(
              controller: TextEditingController(text: representative.lastName),
              decoration: InputDecoration(hintText: 'Nom'),
              onChanged: (value) => representative.lastName = value,
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