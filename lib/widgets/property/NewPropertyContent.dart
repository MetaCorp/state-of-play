import 'package:flutter/material.dart';
import 'package:flutter_tests/models/StateOfPlay.dart' as sop;


typedef SaveCallback = Function(sop.Property);

class NewPropertyContent extends StatefulWidget {
  NewPropertyContent({ Key key, this.title, this.property, this.onSave }) : super(key: key);

  final String title;
  final sop.Property property;
  final SaveCallback onSave;

  @override
  _NewPropertyContentState createState() => new _NewPropertyContentState();
}

class _NewPropertyContentState extends State<NewPropertyContent> {

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    print('NewPropertyContent: ' + widget.property.roomCount.toString());

    Widget body = Container(
      margin: EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              initialValue: widget.property.reference,
              decoration: InputDecoration(labelText: 'Référence interne'),
              onSaved: (value) => widget.property.reference = value,
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
              initialValue: widget.property.address,
              decoration: InputDecoration(labelText: 'Adresse'),
              onSaved: (value) => widget.property.address = value,
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
              initialValue: widget.property.postalCode,
              decoration: InputDecoration(labelText: 'Code postal'),
              keyboardType: TextInputType.number,
              onSaved: (value) => widget.property.postalCode = value,
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
              initialValue: widget.property.city,
              decoration: InputDecoration(labelText: 'Ville'),
              onSaved: (value) => widget.property.city = value,
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
              initialValue: widget.property.lot,
              decoration: InputDecoration(labelText: 'Numéro de lot'),
              onSaved: (value) => widget.property.lot = value,
            ),
            SizedBox(
              height: 8,
            ),
            TextFormField(
              initialValue: widget.property.floor == null ? "" : widget.property.floor.toString(),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Étage'),
              onSaved: (value) => widget.property.floor = int.parse(value),
            ),
            SizedBox(
              height: 8,
            ),
            TextFormField(
              initialValue: widget.property.roomCount == null ? "" : widget.property.roomCount.toString(),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Nombre de pièces'),
              onSaved: (value) => widget.property.roomCount = int.parse(value),
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
              initialValue: widget.property.area == null ? "" : widget.property.area.toString(),
              decoration: InputDecoration(labelText: 'Surface'),
              keyboardType: TextInputType.number,
              onSaved: (value) => widget.property.area = int.parse(value),
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
              initialValue: widget.property.heatingType,
              decoration: InputDecoration(labelText: 'Type de chauffage'),
              onSaved: (value) => widget.property.heatingType = value,
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
              initialValue: widget.property.hotWater,
              decoration: InputDecoration(labelText: 'Eau chaude'),
              onSaved: (value) => widget.property.hotWater = value,
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
                  widget.onSave(widget.property);
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
                widget.onSave(widget.property);
              }
            }
          )
        ],
      ),
      body: body
    ) : body;
  }
}