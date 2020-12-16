import 'package:flutter/material.dart';
import 'package:flutter_tests/models/StateOfPlay.dart' as sop;

typedef SaveCallback = Function(sop.Tenant);

class NewTenantContent extends StatefulWidget {
  NewTenantContent({ Key key, this.title, this.tenant, this.onSave }) : super(key: key);

  final String title;
  final sop.Tenant tenant;
  final SaveCallback onSave;

  @override
  _NewTenantContentState createState() => new _NewTenantContentState();
}

class _NewTenantContentState extends State<NewTenantContent> {

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
                widget.onSave(widget.tenant);
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
                initialValue: widget.tenant.firstName,
                decoration: InputDecoration(labelText: 'Prénom'),
                onSaved: (value) => widget.tenant.firstName = value,
                validator: (value) {
                  if (value == null || value == "")
                    return "Ce champs est obligatoire.";
                  return null;
                },
              ),
              TextFormField(
                initialValue: widget.tenant.lastName,
                decoration: InputDecoration(labelText: 'Nom'),
                onSaved: (value) => widget.tenant.lastName = value,
                validator: (value) {
                  if (value == null || value == "")
                    return "Ce champs est obligatoire.";
                  return null;
                },
              ),
              TextFormField(
                initialValue: widget.tenant.address,
                decoration: InputDecoration(labelText: 'Adresse'),
                onSaved: (value) => widget.tenant.address = value,
                validator: (value) {
                  if (value == null || value == "")
                    return "Ce champs est obligatoire.";
                  return null;
                },
              ),
              TextFormField(
                initialValue: widget.tenant.postalCode,
                decoration: InputDecoration(labelText: 'Code postal'),
                keyboardType: TextInputType.number,
                onSaved: (value) => widget.tenant.postalCode = value,
                validator: (value) {
                  if (value == null || value == "")
                    return "Ce champs est obligatoire.";
                  return null;
                },
              ),
              TextFormField(
                initialValue: widget.tenant.city,
                decoration: InputDecoration(labelText: 'Ville'),
                onSaved: (value) => widget.tenant.city = value,
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
                    widget.onSave(widget.tenant);
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