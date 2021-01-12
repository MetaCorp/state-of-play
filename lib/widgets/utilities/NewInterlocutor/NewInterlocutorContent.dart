import 'package:flutter/material.dart';
import 'package:flutter_tests/models/StateOfPlay.dart' as sop;
import 'package:flutter_tests/widgets/utilities/MyTextFormField.dart';
import 'package:flutter_tests/widgets/utilities/RaisedButtonLoading.dart';

typedef SaveCallback = Function(dynamic);
typedef DeleteCallback = Function();

class NewInterlocutorContent extends StatefulWidget {
  NewInterlocutorContent({ Key key, this.title, this.interlocutor, this.onSave, this.onDelete, this.saveLoading = false }) : super(key: key);

  final String title;
  final dynamic interlocutor;
  final SaveCallback onSave;
  final DeleteCallback onDelete;
  final bool saveLoading;

  @override
  _NewInterlocutorContentState createState() => new _NewInterlocutorContentState();
}

class _NewInterlocutorContentState extends State<NewInterlocutorContent> {

  final _formKey = GlobalKey<FormState>();
  
  _save() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      widget.onSave(widget.interlocutor);
    }
  }

 @override
  Widget build(BuildContext context) {

    return SingleChildScrollView( 
      child: Container(
        margin: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              MyTextFormField(
                initialValue: widget.interlocutor.firstName,
                decoration: InputDecoration(labelText: 'Prénom'),
                textCapitalization: TextCapitalization.sentences,
                onSaved: (value) => widget.interlocutor.firstName = value,
                validator: (value) {
                  if (value == null || value == "")
                    return "Ce champ est obligatoire.";
                  return null;
                },
                maxLength: 24,
                textInputAction: TextInputAction.next,
                onEditingComplete: () => FocusScope.of(context).nextFocus(),
              ),
              SizedBox(
                height: 8,
              ),
              MyTextFormField(
                initialValue: widget.interlocutor.lastName,
                decoration: InputDecoration(labelText: 'Nom'),
                textCapitalization: TextCapitalization.sentences,
                onSaved: (value) => widget.interlocutor.lastName = value,
                validator: (value) {
                  if (value == null || value == "")
                    return "Ce champ est obligatoire.";
                  return null;
                },
                maxLength: 24,
                textInputAction: TextInputAction.next,
                onEditingComplete: () => FocusScope.of(context).nextFocus(),
              ),
              !(widget.interlocutor is sop.Tenant) ? SizedBox(
                height: 8,
              ) : Container(),
              !(widget.interlocutor is sop.Tenant) ? MyTextFormField(
                initialValue: widget.interlocutor.company,
                decoration: InputDecoration(labelText: 'Entreprise'),
                textCapitalization: TextCapitalization.sentences,
                onSaved: (value) => widget.interlocutor.company = value,
                validator: (value) {
                  if (value == null || value == "")
                    return "Ce champ est obligatoire.";
                  return null;
                },
                maxLength: 24,
                textInputAction: TextInputAction.next,
                onEditingComplete: () => FocusScope.of(context).nextFocus(),
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
                    return "Ce champ est obligatoire.";
                  return null;
                },
                maxLength: 48,
                textInputAction: TextInputAction.next,
                onEditingComplete: () => FocusScope.of(context).nextFocus(),
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
                    return "Ce champ est obligatoire.";
                  return null;
                },
                maxLength: 12,
                textInputAction: TextInputAction.next,
                onEditingComplete: () => FocusScope.of(context).nextFocus(),
              ),
              SizedBox(
                height: 8,
              ),
              MyTextFormField(
                initialValue: widget.interlocutor.city,
                decoration: InputDecoration(labelText: 'Ville'),
                textCapitalization: TextCapitalization.sentences,
                onSaved: (value) => widget.interlocutor.city = value,
                validator: (value) {
                  if (value == null || value == "")
                    return "Ce champ est obligatoire.";
                  return null;
                },
                maxLength: 24,
                onEditingComplete: () => _save(),
              ),
              SizedBox(
                height: 16,
              ),
              RaisedButtonLoading(
                color: Colors.grey[100],
                loading: widget.saveLoading,
                child: Text('Sauvegarder'),
                onPressed: () => _save()
              )
            ],
          ),
        ),
      )
    );

   
  }
}