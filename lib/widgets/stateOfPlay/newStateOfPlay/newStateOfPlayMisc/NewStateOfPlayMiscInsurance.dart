import 'package:flutter/material.dart';

class NewStateOfPlayMiscInsurance extends StatefulWidget {
  NewStateOfPlayMiscInsurance({Key key}) : super(key: key);

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
      body: Text('Comments'),
    );
  }
}