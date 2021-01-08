import 'package:flutter/material.dart';
import 'package:flutter_tests/models/StateOfPlay.dart' as sop;
import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/DateButton.dart';
import 'package:flutter_tests/widgets/utilities/MyTextFormField.dart';

class NewStateOfPlayMiscInsurance extends StatefulWidget {
  NewStateOfPlayMiscInsurance({ Key key, this.insurance }) : super(key: key);

  sop.Insurance insurance;

  @override
  _NewStateOfPlayMiscInsuranceState createState() => _NewStateOfPlayMiscInsuranceState();
}

class _NewStateOfPlayMiscInsuranceState extends State<NewStateOfPlayMiscInsurance> {
  final _formKey = GlobalKey<FormState>();

  _onSave() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      Navigator.pop(context);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => _onSave(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Assurance'),
          actions: [
            IconButton(
              icon: Icon(Icons.check),
              onPressed: _onSave
            )
          ]
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                MyTextFormField(
                  decoration: InputDecoration(labelText: "Compagnie d'assurance"),
                  initialValue: widget.insurance.company,
                  onSaved: (value) => widget.insurance.company = value,
                  textCapitalization: TextCapitalization.sentences,
                  maxLength: 24,
                ),
                SizedBox(
                  height: 8,
                ),
                MyTextFormField(
                  decoration: InputDecoration(labelText: "No de police d'assurance"),
                  initialValue: widget.insurance.number,
                  onSaved: (value) => widget.insurance.number = value,
                  maxLength: 24,
                ),
                SizedBox(
                  height: 8,
                ),
                DateButton(
                  labelText: "Date de début",
                  value: widget.insurance.dateStart,
                  onChange: (value) {
                    widget.insurance.dateStart = value;
                    setState(() { });
                  },
                ),
                DateButton(
                  labelText: "Date de fin",
                  value: widget.insurance.dateEnd,
                  onChange: (value) {
                    widget.insurance.dateEnd = value;
                    setState(() { });
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}