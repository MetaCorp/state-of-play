import 'package:flutter/material.dart';
import 'package:flutter_tests/models/StateOfPlay.dart' as sop;

typedef NextCallback = void Function();

class NewStateOfPlayProperty extends StatelessWidget {
  NewStateOfPlayProperty({ Key key, this.property, this.onNext }) : super(key: key);

  final sop.Property property;
  final NextCallback onNext;

  @override
  Widget build(BuildContext context) {

    // TextEditingController _addressController = TextEditingController(text: widget.property.address);
    // TextEditingController _postalCodeController = TextEditingController(text: "75001");
    // TextEditingController _cityController = TextEditingController(text: "Paris");

    return Column(
      children: [
        TextField(
          controller: TextEditingController(text: property.address),
          decoration: InputDecoration(labelText: 'Adresse'),
          onChanged: (value) => property.address = value,
        ),
        TextField(
          controller: TextEditingController(text: property.postalCode),
          decoration: InputDecoration(labelText: 'Code postal'),
          onChanged: (value) => property.postalCode = value,
        ),
        TextField(
          controller: TextEditingController(text: property.city),
          decoration: InputDecoration(labelText: 'Ville'),
          onChanged: (value) => property.city = value,
        ),
        RaisedButton(
          child: Text('Suivant'),
          onPressed: onNext
        )
      ],
    );
  }
}