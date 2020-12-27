import 'package:flutter/material.dart';
import 'package:flutter_tests/models/StateOfPlay.dart' as sop;
import 'package:flutter_tests/widgets/utilities/MyTextFormField.dart';

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
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Supprimer '" + widget.interlocutor.firstName + ' ' + widget.interlocutor.lastName + "' ?"),
            widget.interlocutor.stateOfPlays.length > 0 ? Text("Ceci entrainera la suppression de '" + widget.interlocutor.stateOfPlays.length.toString() + "' état" + (widget.interlocutor.stateOfPlays.length > 1 ? "s" : "") + " des lieux.") : Container(),
          ]
        ),
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

    Widget body = SingleChildScrollView( 
      child: Container(
        margin: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              MyTextFormField(
                initialValue: widget.interlocutor.firstName,
                decoration: InputDecoration(labelText: 'Prénom'),
                onSaved: (value) => widget.interlocutor.firstName = value,
                validator: (value) {
                  if (value == null || value == "")
                    return "Ce champs est obligatoire.";
                  return null;
                },
                maxLength: 24,
              ),
              SizedBox(
                height: 8,
              ),
              MyTextFormField(
                initialValue: widget.interlocutor.lastName,
                decoration: InputDecoration(labelText: 'Nom'),
                onSaved: (value) => widget.interlocutor.lastName = value,
                validator: (value) {
                  if (value == null || value == "")
                    return "Ce champs est obligatoire.";
                  return null;
                },
                maxLength: 24,
              ),
              !(widget.interlocutor is sop.Tenant) ? SizedBox(
                height: 8,
              ) : Container(),
              !(widget.interlocutor is sop.Tenant) ? MyTextFormField(
                initialValue: widget.interlocutor.company,
                decoration: InputDecoration(labelText: 'Entreprise'),
                onSaved: (value) => widget.interlocutor.company = value,
                validator: (value) {
                  if (value == null || value == "")
                    return "Ce champs est obligatoire.";
                  return null;
                },
                maxLength: 24,
              ) : Container(),
              SizedBox(
                height: 8,
              ),
              MyTextFormField(
                initialValue: widget.interlocutor.address,
                decoration: InputDecoration(labelText: 'Adresse'),
                onSaved: (value) => widget.interlocutor.address = value,
                validator: (value) {
                  if (value == null || value == "")
                    return "Ce champs est obligatoire.";
                  return null;
                },
                maxLength: 48,
              ),
              SizedBox(
                height: 8,
              ),
              MyTextFormField(
                initialValue: widget.interlocutor.postalCode,
                decoration: InputDecoration(labelText: 'Code postal'),
                keyboardType: TextInputType.number,
                onSaved: (value) => widget.interlocutor.postalCode = value,
                validator: (value) {
                  if (value == null || value == "")
                    return "Ce champs est obligatoire.";
                  return null;
                },
                maxLength: 12,
              ),
              SizedBox(
                height: 8,
              ),
              MyTextFormField(
                initialValue: widget.interlocutor.city,
                decoration: InputDecoration(labelText: 'Ville'),
                onSaved: (value) => widget.interlocutor.city = value,
                validator: (value) {
                  if (value == null || value == "")
                    return "Ce champs est obligatoire.";
                  return null;
                },
                maxLength: 24,
              ),
              SizedBox(
                height: 16,
              ),
              RaisedButton(
                color: Colors.grey[100],
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
      )
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
          widget.onDelete != null ? PopupMenuButton(
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
          ) : Container(),
        ],
      ),
      body: body
    ) : body;
  }
}