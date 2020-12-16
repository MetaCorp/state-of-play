import 'package:flutter/material.dart';
import 'package:flutter_tests/models/StateOfPlay.dart' as sop;

typedef SaveCallback = Function(sop.Representative);

class NewRepresentativeContent extends StatefulWidget {
  NewRepresentativeContent({ Key key, this.title, this.representative, this.onSave }) : super(key: key);

  final String title;
  final sop.Representative representative;
  final SaveCallback onSave;

  @override
  _NewRepresentativeContentState createState() => new _NewRepresentativeContentState();
}

class _NewRepresentativeContentState extends State<NewRepresentativeContent> {

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                widget.onSave(widget.representative);
              }
            }
          )
        ],
      ),
      body: Container(
        margin: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: widget.representative.firstName,
                decoration: InputDecoration(labelText: 'Prénom'),
                onSaved: (value) => widget.representative.firstName = value,
                validator: (value) {
                  if (value == null || value == "")
                    return "Ce champs est obligatoire.";
                  return null;
                },
              ),
              TextFormField(
                initialValue: widget.representative.lastName,
                decoration: InputDecoration(labelText: 'Nom'),
                onSaved: (value) => widget.representative.lastName = value,
                validator: (value) {
                  if (value == null || value == "")
                    return "Ce champs est obligatoire.";
                  return null;
                },
              ),
              TextFormField(
                initialValue: widget.representative.address,
                decoration: InputDecoration(labelText: 'Adresse'),
                onSaved: (value) => widget.representative.address = value,
                validator: (value) {
                  if (value == null || value == "")
                    return "Ce champs est obligatoire.";
                  return null;
                },
              ),
              TextFormField(
                initialValue: widget.representative.postalCode,
                decoration: InputDecoration(labelText: 'Code postal'),
                keyboardType: TextInputType.number,
                onSaved: (value) => widget.representative.postalCode = value,
                validator: (value) {
                  if (value == null || value == "")
                    return "Ce champs est obligatoire.";
                  return null;
                },
              ),
              TextFormField(
                initialValue: widget.representative.city,
                decoration: InputDecoration(labelText: 'Ville'),
                onSaved: (value) => widget.representative.city = value,
                validator: (value) {
                  if (value == null || value == "")
                    return "Ce champs est obligatoire.";
                  return null;
                },
              ),
              RaisedButton(
                child: Text('Sauvegarder'),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    widget.onSave(widget.representative);
                  }
                }
              )
            ],
          ),
        ),
      )
    );
  }
}