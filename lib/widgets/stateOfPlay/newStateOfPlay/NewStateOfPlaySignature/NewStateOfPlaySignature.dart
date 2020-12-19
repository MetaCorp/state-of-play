import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_tests/GeneratePdf.dart';
import 'package:flutter_tests/models/StateOfPlay.dart'as sop;
import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/DateButton.dart';

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

  @override
  void initState() {
    widget.stateOfPlay.signatureTenants = new List(widget.stateOfPlay.tenants.length);

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
            DateButton(
              labelText: widget.stateOfPlay.out ? "Date de sortie" : "Date d'entrée",
              value: widget.stateOfPlay.entryExitDate,
              onChange: (value) {
                widget.stateOfPlay.entryExitDate = value;
                setState(() { });
              }
            ),
            TextField(
              controller: TextEditingController(text: widget.stateOfPlay.documentHeader),// TODO: a récupérer dans les settings
              decoration: InputDecoration(labelText: 'Entête du document'),
              onChanged: (value) => widget.stateOfPlay.documentHeader = value,
            ),
            SizedBox(height: sizedBoxHeight),
            TextField(
              controller: TextEditingController(text: widget.stateOfPlay.documentEnd),// TODO: a récupérer dans les settings
              decoration: InputDecoration(labelText: 'Mention en fin du document'),
              onChanged: (value) => widget.stateOfPlay.documentEnd = value,
            ),
            // SizedBox(height: 24),             
            // Text("Nouvelle adresse des locataires"),
            // SizedBox(height: sizedBoxHeight),             
            // TextField(
            //   decoration: InputDecoration(
            //     labelText: "Nr° et Nom de voie",
            //   ),
            // ),   
            // SizedBox(height: sizedBoxHeight),             
            // Container(
            //   child: TextField(
            //     decoration: InputDecoration(
            //       labelText: "Code Postal",
            //     ),
            //   ),
            // ),
            // SizedBox(height: sizedBoxHeight),             
            // Container(
            //   child: TextField(
            //     decoration: InputDecoration(
            //       labelText: "Ville",
            //     ),
            //   ),
            // ),
            SizedBox(height: sizedBoxHeight),
            TextField(
              controller: TextEditingController(text: widget.stateOfPlay.city),// TODO: a récupérer dans les settings
              decoration: InputDecoration(labelText: 'Fait à'),
              onChanged: (value) => widget.stateOfPlay.city = value,
            ),
            DateButton(
              labelText: "le",
              value: widget.stateOfPlay.date,
              onChange: (value) {
                widget.stateOfPlay.entryExitDate = value;
                setState(() { });
              }
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
                  SizedBox(height: 16),             
                  buildSignatures(),
                  buildSignatureRowsTenants(),
                  SizedBox(height: 24),             
                  RaisedButton(
                    child: Text("Visualiser l'état des lieux"),
                    onPressed: () {

                      for (var i = 0; i < widget.stateOfPlay.rooms.length; i++) {
                        
                        for (var j = 0; j < widget.stateOfPlay.rooms[i].decorations.length; j++) {
                          
                          for (var k = 0; k < widget.stateOfPlay.rooms[i].decorations[j].newImages.length; k++) {
                            
                            widget.stateOfPlay.rooms[i].decorations[j].imageIndexes.add(widget.stateOfPlay.images.length);

                            widget.stateOfPlay.images.add(widget.stateOfPlay.rooms[i].decorations[j].newImages[k]);

                          }
                        }
                      }

                      for (var i = 0; i < widget.stateOfPlay.meters.length; i++) {
                        
                        for (var j = 0; j < widget.stateOfPlay.meters[i].newImages.length; j++) {
                          
                          widget.stateOfPlay.meters[i].imageIndexes.add(widget.stateOfPlay.images.length);

                          widget.stateOfPlay.images.add(widget.stateOfPlay.meters[i].newImages[j]);
                        }
                      }

                      for (var i = 0; i < widget.stateOfPlay.keys.length; i++) {
                        
                        for (var j = 0; j < widget.stateOfPlay.keys[i].newImages.length; j++) {
                          
                          widget.stateOfPlay.keys[i].imageIndexes.add(widget.stateOfPlay.images.length);

                          widget.stateOfPlay.images.add(widget.stateOfPlay.keys[i].newImages[j]);
                        }
                      }


                      generatePdf(widget.stateOfPlay);
                      // widget.onSave();// TODO: save
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
            SizedBox(
              width: 150,
              child: RaisedButton(
                color: widget.stateOfPlay.signatureOwner != null ? Theme.of(context).primaryColor : Theme.of(context).buttonColor,
                child: widget.stateOfPlay.signatureOwner != null ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(widget.stateOfPlay.owner.lastName),
                      Icon(Icons.check),
                    ],
                  ) : Text(widget.stateOfPlay.owner.lastName),    
                onPressed: () => {widget.stateOfPlay.signatureOwner != null ? showDeleteSignature(widget.stateOfPlay.owner) : goToSignatureSignature(widget.stateOfPlay.owner)},
              ),
            ),
            GestureDetector(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(),
                ), 
                height: 60,
                width: 150,
                child: widget.stateOfPlay.signatureOwner != null ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //here
                    Image.memory(widget.stateOfPlay.signatureOwner,width: 100,),
                    ButtonTheme(    
                      minWidth: 26.0,
                      height: 60,
                      child: FlatButton(   
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),   
                        shape: CircleBorder(),
                        child: Icon(Icons.close,size: 22,),
                        onPressed: () { 
                          setState(() {
                            widget.stateOfPlay.signatureOwner = null;
                          });
                        },
                      ),
                    ),
                  ],
                ): null,        
              ),
              onTap: () => {widget.stateOfPlay.signatureOwner != null ? showDeleteSignature(widget.stateOfPlay.owner) : goToSignatureSignature(widget.stateOfPlay.owner)},
            ),
          ],
        ),
        SizedBox(width:16),
        Column(
          children: [
            // TODO foreach on list 
            SizedBox(
              width: 150,
              child: RaisedButton(
                color: widget.stateOfPlay.signatureRepresentative != null ? Theme.of(context).primaryColor : Theme.of(context).buttonColor,
                child: widget.stateOfPlay.signatureRepresentative != null ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(widget.stateOfPlay.representative.lastName),
                      Icon(Icons.check),
                    ],
                  ) : Text(widget.stateOfPlay.representative.lastName),              
                onPressed: () => {widget.stateOfPlay.signatureRepresentative != null ? showDeleteSignature(widget.stateOfPlay.representative) : goToSignatureSignature(widget.stateOfPlay.representative)},
              ),
            ),
            GestureDetector(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(),
                ), 
                height: 60,
                width: 150,
                child: widget.stateOfPlay.signatureRepresentative != null ? Image.memory(widget.stateOfPlay.signatureRepresentative) : null,          
              ),
              onTap: () => {widget.stateOfPlay.signatureRepresentative != null ? showDeleteSignature(widget.stateOfPlay.representative) : goToSignatureSignature(widget.stateOfPlay.representative)},
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
            SizedBox(
              width: 150,
                  child: RaisedButton(
                  color: widget.stateOfPlay.signatureTenants[index] != null ? Theme.of(context).primaryColor : Theme.of(context).buttonColor,
                  child: widget.stateOfPlay.signatureTenants[index] != null ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(tenant.lastName),
                      Icon(Icons.check),
                    ],
                  ) : Text(tenant.lastName),
                  onPressed: () => {widget.stateOfPlay.signatureTenants[index] != null ? showDeleteSignature(tenant,index: index) : goToSignatureSignature(tenant,index: index)},
                ),
            ),
            GestureDetector(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(),
                ), 
                height: 60,
                width: 150,
                child: widget.stateOfPlay.signatureTenants[index] != null ? Image.memory(widget.stateOfPlay.signatureTenants[index]) : null,          
              ),
              onTap: () => {widget.stateOfPlay.signatureTenants[index] != null ? showDeleteSignature(tenant,index: index) : goToSignatureSignature(tenant,index: index)},
            ),
          ],
        ),
        )).values.toList(),
    );
  }

  goToSignatureSignature(person, {int index}) async {
   
    Uint8List data = await Navigator.push(context, PageRouteBuilder(pageBuilder: (_, __, ___) => NewStateOfPlaySignatureSignature(
      interlocutor: person,
    )));
    // TODO catch null
    if (person is sop.Owner) { 
      setState(() {
        widget.stateOfPlay.signatureOwner = data;
      }); 
    } else if (person is sop.Representative){
      setState(() {
        widget.stateOfPlay.signatureRepresentative = data;
      }); 
    } else if (person is sop.Tenant){
      setState(() {
        widget.stateOfPlay.signatureTenants[index] = data;
      }); 
    }
  }

  showDeleteSignature(person, {int index}) async  {
    await showDialog(
      context: context,
      child: AlertDialog(
        content: Text("Supprimer la signature de '" + person.firstName + ' ' + person.lastName + "' ?"),
        actions: [
          new FlatButton(
            child: Text('ANNULER'),
            onPressed: () {
              Navigator.pop(context);
            }
          ),
          new FlatButton(
            child: Text('SUPPRIMER'),
            onPressed: () async {
              if (person is sop.Owner) { 
                setState(() {
                  widget.stateOfPlay.signatureOwner = null;
                }); 
              } else if (person is sop.Representative){
                setState(() {
                  widget.stateOfPlay.signatureRepresentative = null;
                }); 
              } else if (person is sop.Tenant){
                setState(() {
                  widget.stateOfPlay.signatureTenants[index] = null;
                }); 
              }
              Navigator.pop(context);
            }
          )
        ],
      )
    );
  }  
}
