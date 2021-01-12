import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_tests/Icons/e_d_l_icons_icons.dart';
import 'package:flutter_tests/models/StateOfPlay.dart'as sop;
import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/DateButton.dart';

import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/NewStateOfPlaySignature/NewStateOfPlaySignatureSignature.dart';
import 'package:flutter_tests/widgets/utilities/MyTextFormField.dart';
import 'package:flutter_tests/widgets/utilities/RaisedButtonLoading.dart';

import 'package:stripe_payment/stripe_payment.dart';


typedef SaveCallback = Function();

class NewStateOfPlaySignature extends StatefulWidget {
  NewStateOfPlaySignature({ Key key, this.onSave, this.stateOfPlay, this.formKey, this.isPdfLoading }) : super(key: key);

  //final only if signature not to set ? bad idea ?
  final SaveCallback onSave;
  final sop.StateOfPlay stateOfPlay;
  final GlobalKey<FormState> formKey;
  final bool isPdfLoading;

  @override
  _NewStateOfPlaySignatureState createState() => new _NewStateOfPlaySignatureState();
}

// TODO Get liste interlocuteurs pour les signatures et locataires pour misa à jour adresse
class _NewStateOfPlaySignatureState extends State<NewStateOfPlaySignature> {

  @override
  void initState() {
    widget.stateOfPlay.signatureTenants ??= new List();
    widget.stateOfPlay.signatureTenants.length = widget.stateOfPlay.tenants.length;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    double sizedBoxHeight = 8;  

    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(8.0),      
        child: Form(
          key: widget.formKey,
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
              MyTextFormField(
                initialValue: widget.stateOfPlay.documentHeader,
                decoration: InputDecoration(labelText: 'Entête du document'),
                onSaved: (value) => widget.stateOfPlay.documentHeader = value,
                keyboardType: TextInputType.multiline,
                validator: (value) {
                  if (value == null || value == "")
                    return "Ce champ est obligatoire.";
                  return null;
                },
                maxLength: 256,
                minLines: 1,
                maxLines: 2,
                textInputAction: TextInputAction.next,
                onEditingComplete: () => FocusScope.of(context).nextFocus(),
              ),
              SizedBox(height: sizedBoxHeight),
              MyTextFormField(
                initialValue: widget.stateOfPlay.documentEnd,
                decoration: InputDecoration(labelText: 'Mention en fin du document'),
                onSaved: (value) => widget.stateOfPlay.documentEnd = value,
                keyboardType: TextInputType.multiline,
                validator: (value) {
                  if (value == null || value == "")
                    return "Ce champ est obligatoire.";
                  return null;
                },
                maxLength: 1024,
                maxLines: 4,
                textInputAction: TextInputAction.next,
                onEditingComplete: () => FocusScope.of(context).nextFocus(),
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
              SizedBox(height: sizedBoxHeight*2),
              MyTextFormField(
                initialValue: widget.stateOfPlay.city,
                decoration: InputDecoration(labelText: 'Fait à'),
                textCapitalization: TextCapitalization.sentences,
                onSaved: (value) => widget.stateOfPlay.city = value,
                validator: (value) {
                  if (value == null || value == "")
                    return "Ce champ est obligatoire.";
                  return null;
                },
                maxLength: 24,
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
                    RaisedButtonLoading(
                      child: Text("Visualiser l'état des lieux"),
                      onPressed: () async {
                        widget.onSave();
                      },
                      loading: widget.isPdfLoading,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSignatures() {
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
                      Icon(Icons.check,),
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
                child: widget.stateOfPlay.signatureOwner != null ? Stack(
                  children: [
                    Image.memory(widget.stateOfPlay.signatureOwner,width: 150,),
                    Align(
                      alignment: Alignment.topRight,
                        child: ButtonTheme(    
                        minWidth: 26.0,
                        height: 60,
                        child: FlatButton(   
                          padding: EdgeInsets.fromLTRB(0, 0, 7.5, 0),   
                          shape: CircleBorder(),
                          child: Icon(Icons.close, size: 22),
                          onPressed: () { 
                            setState(() {
                              showDeleteSignature(widget.stateOfPlay.owner);
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ): Center(child: Icon(Icons.edit , color: Colors.grey[600],)),        
              ),
              onTap: () => {widget.stateOfPlay.signatureOwner != null ? showDeleteSignature(widget.stateOfPlay.owner) : goToSignatureSignature(widget.stateOfPlay.owner)},
            ),
          ],
        ),
        widget.stateOfPlay.representative != null && widget.stateOfPlay.representative.lastName != null ? SizedBox(width:16) : Container(),
        widget.stateOfPlay.representative != null && widget.stateOfPlay.representative.lastName != null ? Column(
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
                child: widget.stateOfPlay.signatureRepresentative != null ? Stack(
                  children: [
                    Image.memory(widget.stateOfPlay.signatureRepresentative,width: 150,),
                    Align(
                      alignment: Alignment.topRight,
                        child: ButtonTheme(    
                        minWidth: 26.0,
                        height: 60,
                        child: FlatButton(   
                          padding: EdgeInsets.fromLTRB(0, 0, 7.5, 0),   
                          shape: CircleBorder(),
                          child: Icon(Icons.close, size: 22),
                          onPressed: () { 
                            setState(() {
                              showDeleteSignature(widget.stateOfPlay.representative);
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ): Center(child: Icon(Icons.edit , color: Colors.grey[600],)),                 
              ),
              onTap: () => {widget.stateOfPlay.signatureRepresentative != null ? showDeleteSignature(widget.stateOfPlay.representative) : goToSignatureSignature(widget.stateOfPlay.representative)},
            ),
          ],
        ) : Container(),
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
                  onPressed: () => {widget.stateOfPlay.signatureTenants[index] != null ? showDeleteSignature(widget.stateOfPlay.tenants[index],index: index) : goToSignatureSignature(widget.stateOfPlay.tenants[index],index: index)},
                ),
            ),
            GestureDetector(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(),
                ), 
                height: 60,
                width: 150,
                child: widget.stateOfPlay.signatureTenants[index] != null ? Stack(
                  children: [
                    Image.memory(widget.stateOfPlay.signatureTenants[index],width: 150,),
                    Align(
                      alignment: Alignment.topRight,
                        child: ButtonTheme(    
                        minWidth: 26.0,
                        height: 60,
                        child: FlatButton(   
                          padding: EdgeInsets.fromLTRB(0, 0, 7.5, 0),   
                          shape: CircleBorder(),
                          child: Icon(Icons.close, size: 22),
                          onPressed: () { 
                            setState(() {
                              showDeleteSignature(widget.stateOfPlay.signatureTenants[index]);
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ): Center(child: Icon(Icons.edit , color: Colors.grey[600],)),                           
              ),
              onTap: () => {widget.stateOfPlay.signatureTenants[index] != null ? showDeleteSignature(widget.stateOfPlay.tenants[index],index: index) : goToSignatureSignature(widget.stateOfPlay.tenants[index],index: index)},
            ),
          ],
        ),
        )).values.toList(),
    );
  }

  goToSignatureSignature(person, {int index}) async {
    FocusScope.of(context).unfocus();
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
