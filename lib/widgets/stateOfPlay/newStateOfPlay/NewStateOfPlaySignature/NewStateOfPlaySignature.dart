import 'package:flutter/material.dart';

import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/NewStateOfPlaySignature/NewStateOfPlaySignatureSignature.dart';

typedef SaveCallback = void Function();


class NewStateOfPlaySignature extends StatefulWidget {
  NewStateOfPlaySignature({ Key key, this.onSave}) : super(key: key);

  final SaveCallback onSave;

  @override
  _NewStateOfPlaySignatureState createState() => new _NewStateOfPlaySignatureState();
}

// TODO Get liste interlocuteurs pour les signatures et locataires pour misa à jour adresse
class _NewStateOfPlaySignatureState extends State<NewStateOfPlaySignature> {

  @override
  Widget build(BuildContext context) {

    double sizedBoxHeight = 8;  

    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(8.0),      
        child: Column(
          children: [
            Text("Entête document"),
            SizedBox(height: sizedBoxHeight),             
            Container(
              decoration: BoxDecoration(
                border: Border.all(),
              ), 
              child: Opacity(
                opacity: 0.5,
                child: Text(
                  "text de l'entête du document à récupérer dans les settingstext de l'entête du document à récupérer dans les settingstext de l'entête du document à récupérer dans les settingstext de l'entête du document à récupérer dans les settingstext de l'entête du document à récupérer dans les settingstext de l'entête du document à récupérer dans les settingstext de l'entête du document à récupérer dans les settingstext de l'entête du document à récupérer dans les settings"),
              ),
            ),
            SizedBox(height: sizedBoxHeight),             
            Text("Mention en Fin de document"),
            SizedBox(height: sizedBoxHeight),             
            Container(
              decoration: BoxDecoration(
                border: Border.all(),
              ), 
              child: Opacity(
                opacity: 0.5,
                child: Text("text de Mention en Fin de document à récupérer dans les settings"),
              ),
            ),
            SizedBox(height: sizedBoxHeight),             
            Text("Nouvelle adresse des locataires"),
            SizedBox(height: sizedBoxHeight),             
            TextField(
              decoration: InputDecoration(
                labelText: "Nr° et Nom voie",
              ),
            ),   
            SizedBox(height: sizedBoxHeight),             
            Container(
              child: TextField(
                decoration: InputDecoration(
                  labelText: "Code Postal",
                ),
              ),
            ),
            SizedBox(height: sizedBoxHeight),             
            Container(
              child: TextField(
                decoration: InputDecoration(
                  labelText: "Ville",
                ),
              ),
            ),
            SizedBox(height: sizedBoxHeight),             
            Container(
              child: Column( 
                children: [
                  SizedBox(height: sizedBoxHeight),             
                  Text("Signatures"),
                  SizedBox(height: sizedBoxHeight),             
                  Opacity(
                    opacity: 0.5,
                    child: Text(
                      "Cliquez sur les cadres pour procéder au signatures:", maxLines: 1,
                    ),
                  ),
                  SizedBox(height: sizedBoxHeight),             
                  buildSignatures(),
                  RaisedButton(
                    child: Text("Visualiser l'état des lieux"),
                    onPressed: widget.onSave,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSignatures(){
    return Column(
      children: [
        MaterialButton(
          child: Text("@Interlo1"),
          onPressed: () { 
            Navigator.push(context, PageRouteBuilder(pageBuilder: (_, __, ___) => NewStateOfPlaySignatureSignature()));
          },
        )     
      ],
    );
  }
}