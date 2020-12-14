import 'package:flutter/material.dart';
import 'package:flutter_tests/models/StateOfPlay.dart' as sop;

class NewStateOfPlayMiscInsurance extends StatefulWidget {
  NewStateOfPlayMiscInsurance({ Key key, this.insurance }) : super(key: key);

  sop.Insurance insurance;

  @override
  _NewStateOfPlayMiscInsuranceState createState() => _NewStateOfPlayMiscInsuranceState();
}

class _NewStateOfPlayMiscInsuranceState extends State<NewStateOfPlayMiscInsurance> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Assurance'),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
      body:  Column(
        children: [
          TextField(
            controller: TextEditingController(text: widget.insurance.company),
            decoration: InputDecoration(labelText: "Compagnie d'assurance"),
            onChanged: (value) => widget.insurance.company = value,
          ),
          TextField(
            controller: TextEditingController(text: widget.insurance.number),
            decoration: InputDecoration(labelText: "No de police d'assurance"),
            onChanged: (value) => widget.insurance.number = value,
          )
        ],
      ),
    );
  }
}