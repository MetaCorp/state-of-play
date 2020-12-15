import 'package:flutter/material.dart';
import 'package:flutter_tests/GeneratePdf.dart';
import 'package:flutter_tests/models/StateOfPlay.dart'as sop;

import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/NewStateOfPlaySignature/NewStateOfPlaySignatureSignature.dart';

typedef SaveCallback = void Function();


class NewStateOfPlaySignature extends StatefulWidget {
  NewStateOfPlaySignature({ Key key, this.onSave, this.stateOfPlay }) : super(key: key);

  //final only if signature not to set ? bad idea ?
  final SaveCallback onSave;
  final sop.StateOfPlay stateOfPlay;

  @override
  _NewStateOfPlaySignatureState createState() => new _NewStateOfPlaySignatureState();
}

// TODO Get liste interlocuteurs pour les signatures et locataires pour misa à jour adresse
class _NewStateOfPlaySignatureState extends State<NewStateOfPlaySignature> {

  var signatureOwner;
  var signatureRepresentative;
  var signatureTenants; 

  @override
  void initState() {
    signatureTenants = new List(widget.stateOfPlay.tenants.length);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    double sizedBoxHeight = 8;  

    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(8.0),      
        child: Column(
          children: [
            TextField(
              controller: TextEditingController(text: 'Entête'),// TODO: a récupérer dans les settings
              decoration: InputDecoration(labelText: 'Entête du document'),
              onChanged: (value) => widget.stateOfPlay.documentHeader = value,
            ),
            SizedBox(height: sizedBoxHeight),
            TextField(
              controller: TextEditingController(text: 'Mention en fin'),// TODO: a récupérer dans les settings
              decoration: InputDecoration(labelText: 'Mention en fin du document'),
              onChanged: (value) => widget.stateOfPlay.documentEnd = value,
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
                  buildSignatureRowsTenants(),
                  RaisedButton(
                    child: Text("Visualiser l'état des lieux"),
                    onPressed: () {
                      generatePdf(widget.stateOfPlay);
                      widget.onSave();
                    },
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
    return Row(     
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            MaterialButton(
              minWidth: 150,
              color: Colors.blue,
              child: Text(widget.stateOfPlay.owner.lastName),
              onPressed: () => goToSignatureSignature(widget.stateOfPlay.owner),
            ),
            GestureDetector(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(),
                ), 
                height: 60,
                width: 150,
                child: signatureOwner ?? null,          
              ),
              onTap: () => goToSignatureSignature(widget.stateOfPlay.owner),
            ),
          ],
        ),
        SizedBox(width:16),
        Column(
          children: [
            // TODO foreach on list 
            MaterialButton(
              minWidth: 150,
              color: Colors.blue,
              child: Text(widget.stateOfPlay.representative.lastName),
              onPressed: () => goToSignatureSignature(widget.stateOfPlay.representative),
            ),
            GestureDetector(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(),
                ), 
                height: 60,
                width: 150,
                child: signatureRepresentative ?? null,          
              ),
              onTap: () => goToSignatureSignature(widget.stateOfPlay.representative),
            ),
          ],
        ),
      ],   
    );
  }

  Widget buildSignatureRowsTenants(){
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: widget.stateOfPlay.tenants.asMap().map((index,tenant) => MapEntry(index, 
        Column(
          children: [
          MaterialButton(
              minWidth: 150,
              color: Colors.blue,
              child: Text(tenant.lastName),
              onPressed: () => goToSignatureSignature(tenant,index: index),
            ),
            GestureDetector(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(),
                ), 
                height: 60,
                width: 150,
                child: signatureTenants[index] ??  null,          
              ),
              onTap: () => goToSignatureSignature(tenant,index: index),
            ),
          ],
        ),
        )).values.toList(),
    );
  }

  goToSignatureSignature(person, {int index}) async {
    
    final data = await Navigator.push(context, PageRouteBuilder(pageBuilder: (_, __, ___) => NewStateOfPlaySignatureSignature()));
    //TODO catch null
    if (person is sop.Owner) { 
      setState(() {
        signatureOwner = Image.memory(data);
        print(signatureOwner.toString());
      }); 
    } else if (person is sop.Representative){
      setState(() {
        signatureRepresentative = Image.memory(data);
        print(signatureOwner.toString());
      }); 
    } else if (person is sop.Tenant){
      setState(() {
        signatureTenants[index] = Image.memory(data);
        print(signatureOwner.toString());
      }); 
    }
  }
}