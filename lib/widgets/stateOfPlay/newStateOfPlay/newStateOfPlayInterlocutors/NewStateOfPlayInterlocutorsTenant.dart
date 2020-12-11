import 'package:flutter/material.dart';
import 'package:flutter_tests/models/StateOfPlay.dart' as sop;

typedef SaveCallback = void Function(sop.Tenant);

class NewStateOfPlayInterlocutorsTenant extends StatelessWidget {
  const NewStateOfPlayInterlocutorsTenant({ Key key, this.tenant, this.onSave }) : super(key: key);

  final sop.Tenant tenant;
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
              controller: TextEditingController(text: tenant.firstName),
              decoration: InputDecoration(hintText: 'Prénom'),
              onChanged: (value) => tenant.firstName = value,
            ),
            TextField(
              controller: TextEditingController(text: tenant.lastName),
              decoration: InputDecoration(hintText: 'Nom'),
              onChanged: (value) => tenant.lastName = value,
            ),
            RaisedButton(
              child: Text('Sauvegarder'),
              onPressed: () {
                onSave(tenant);
                Navigator.pop(context);
              }
            )
          ],
        )
      ),
    );
  }
}