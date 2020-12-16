import 'package:flutter/material.dart';

typedef SaveCallback = Function(dynamic);
typedef DeleteCallback = Function();

class NewInterlocutorContent extends StatefulWidget {
  NewInterlocutorContent({ Key key, this.title, this.interlocutor, this.onSave, this.onDelete }) : super(key: key);

  final String title;
  final dynamic interlocutor;
  final SaveCallback onSave;
  final DeleteCallback onDelete;

  @override
  _NewInterlocutorContentState createState() => new _NewInterlocutorContentState();
}

class _NewInterlocutorContentState extends State<NewInterlocutorContent> {

  final _formKey = GlobalKey<FormState>();

  
  void _showDialogDelete(context) async {
    await showDialog(
      context: context,
      child: AlertDialog(
        content: Text("Supprimer '" + widget.interlocutor.firstName + ' ' + widget.interlocutor.lastName + "' ?"),
        actions: [
          new FlatButton(
            child: Text('ANNULER'),
            onPressed: () {
              Navigator.pop(context);
            }
          ),
          new FlatButton(
            child: Text('SUPPRIMER'),
            onPressed: () {
              widget.onDelete();
            }
          )
        ],
      )
    );
  }

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
          ),
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text("Supprimer"),
                value: "delete",
              )
            ],
            onSelected: (result) {
              print("onSelected: " + result);
              if (result == "delete")
                _showDialogDelete(context);
            }
          ),
        ],
      ),
      body: body
    ) : body;
  }
}