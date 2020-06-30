import 'package:flutter/material.dart';
import 'package:flutter_tests/models/StateOfPlay.dart' as sop;

class PropertyForm extends StatefulWidget {
  PropertyForm({
    Key key,
    this.property,
    this.text = 'Hello World'
  }) : super(key: key);

  final String text;
  final sop.Property property;

  @override
  _PropertyFormState createState() => _PropertyFormState();
}

class _PropertyFormState extends State<PropertyForm> {

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Adresse',
            ),
            initialValue: widget.property.address,
            validator: (value) {
              if (value.isEmpty) {
                return 'Préciser une adresse';
              }
              return null;
            },
            onSaved: (String value) {
              widget.property.address = value;
            },
          ),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Code Postal',
            ),
            initialValue: widget.property.postalCode,
            validator: (value) {
              if (value.isEmpty) {
                return 'Préciser une adresse';
              }
              return null;
            },
            onSaved: (String value) {
              widget.property.postalCode = value;
            },
          ),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Ville',
            ),
            initialValue: widget.property.city,
            validator: (value) {
              if (value.isEmpty) {
                return 'Préciser une adresse';
              }
              return null;
            },
            onSaved: (String value) {
              widget.property.city = value;
            },
          ),
          RaisedButton(
            onPressed: () {
              if (_formKey.currentState.validate()) {
                Scaffold
                  .of(context)
                  .showSnackBar(SnackBar(content: Text('Processing Data')));
              }
            },
            child: Text('Submit'),
          )
        ]
      )
    );
  }
}