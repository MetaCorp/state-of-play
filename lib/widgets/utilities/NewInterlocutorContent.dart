import 'package:flutter/material.dart';

typedef SaveCallback = Function(dynamic);

class NewInterlocutorContent extends StatefulWidget {
  NewInterlocutorContent({ Key key, this.title, this.interlocutor, this.onSave }) : super(key: key);

  final String title;
  final dynamic interlocutor;
  final SaveCallback onSave;

  @override
  _NewInterlocutorContentState createState() => new _NewInterlocutorContentState();
}

class _NewInterlocutorContentState extends State<NewInterlocutorContent> {

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
              initialValue: widget.interlocutor.firstName,
              decoration: InputDecoration(labelText: 'Prénom'),
              onSaved: (value) => widget.interlocutor.firstName = value,
              validator: (value) {
                if (value == null || value == "")
                  return "Ce champs est obligatoire.";
                return null;
              },
            ),
            SizedBox(
              height: 8,
            ),
            TextFormField(
              initialValue: widget.interlocutor.lastName,
              decoration: InputDecoration(labelText: 'Nom'),
              onSaved: (value) => widget.interlocutor.lastName = value,
              validator: (value) {
                if (value == null || value == "")
                  return "Ce champs est obligatoire.";
                return null;
              },
            ),
            SizedBox(
              height: 8,
            ),
            TextFormField(
              initialValue: widget.interlocutor.address,
              decoration: InputDecoration(labelText: 'Adresse'),
              onSaved: (value) => widget.interlocutor.address = value,
              validator: (value) {
                if (value == null || value == "")
                  return "Ce champs est obligatoire.";
                return null;
              },
            ),
            SizedBox(
              height: 8,
            ),
            TextFormField(
              initialValue: widget.interlocutor.postalCode,
              decoration: InputDecoration(labelText: 'Code postal'),
              keyboardType: TextInputType.number,
              onSaved: (value) => widget.interlocutor.postalCode = value,
              validator: (value) {
                if (value == null || value == "")
                  return "Ce champs est obligatoire.";
                return null;
              },
            ),
            SizedBox(
              height: 8,
            ),
            TextFormField(
              initialValue: widget.interlocutor.city,
              decoration: InputDecoration(labelText: 'Ville'),
              onSaved: (value) => widget.interlocutor.city = value,
              validator: (value) {
                if (value == null || value == "")
                  return "Ce champs est obligatoire.";
                return null;
              },
            ),
            SizedBox(
              height: 16,
            ),
            RaisedButton(
              child: Text('Sauvegarder'),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  widget.onSave(widget.interlocutor);
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
                widget.onSave(widget.interlocutor);
              }
            }
          )
        ],
      ),
      body: body
    ) : body;
  }
}