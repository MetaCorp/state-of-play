import 'package:flutter/material.dart';
import 'package:flutter_tests/models/StateOfPlay.dart' as sop;

typedef SaveCallback = Function(sop.Owner);

class NewOwnerContent extends StatefulWidget {
  NewOwnerContent({ Key key, this.title, this.owner, this.onSave }) : super(key: key);

  final String title;
  final sop.Owner owner;
  final SaveCallback onSave;

  @override
  _NewOwnerContentState createState() => new _NewOwnerContentState();
}

class _NewOwnerContentState extends State<NewOwnerContent> {

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    Widget body = Container(
      margin: EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              initialValue: widget.owner.firstName,
              decoration: InputDecoration(labelText: 'Prénom'),
              onSaved: (value) => widget.owner.firstName = value,
              validator: (value) {
                if (value == null || value == "")
                  return "Ce champs est obligatoire.";
                return null;
              },
            ),
            TextFormField(
              initialValue: widget.owner.lastName,
              decoration: InputDecoration(labelText: 'Nom'),
              onSaved: (value) => widget.owner.lastName = value,
              validator: (value) {
                if (value == null || value == "")
                  return "Ce champs est obligatoire.";
                return null;
              },
            ),
            TextFormField(
              initialValue: widget.owner.address,
              decoration: InputDecoration(labelText: 'Adresse'),
              onSaved: (value) => widget.owner.address = value,
              validator: (value) {
                if (value == null || value == "")
                  return "Ce champs est obligatoire.";
                return null;
              },
            ),
            TextFormField(
              initialValue: widget.owner.postalCode,
              decoration: InputDecoration(labelText: 'Code postal'),
              keyboardType: TextInputType.number,
              onSaved: (value) => widget.owner.postalCode = value,
              validator: (value) {
                if (value == null || value == "")
                  return "Ce champs est obligatoire.";
                return null;
              },
            ),
            TextFormField(
              initialValue: widget.owner.city,
              decoration: InputDecoration(labelText: 'Ville'),
              onSaved: (value) => widget.owner.city = value,
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
                  widget.onSave(widget.owner);
                }
              }
            )
          ],
        ),
      ),
    );

    return widget.title != null ? Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                widget.onSave(widget.owner);
              }
            }
          )
        ],
      ),
      body: body
    ) : body;
  }
}