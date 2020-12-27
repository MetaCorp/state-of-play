import 'package:flutter/material.dart';
import 'package:flutter_tests/models/StateOfPlay.dart' as sop;
import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/DateButton.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tests/widgets/utilities/MyTextField.dart';

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
      body:  Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            MyTextField(
              labelText: "Compagnie d'assurance",
              text: widget.insurance.company,
              onChanged: (value) => widget.insurance.company = value,
              maxLength: 24,
            ),
            SizedBox(
              height: 8,
            ),
            MyTextField(
              text: widget.insurance.number,
              labelText: "No de police d'assurance",
              onChanged: (value) => widget.insurance.number = value,
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
    );
  }
}