import 'package:flutter/material.dart';

typedef SavedCallback = Function(String);

typedef ValidatorCallback = String Function(String);

class MyTextFormField extends StatelessWidget {

  const MyTextFormField({
    Key key,
    this.initialValue,
    this.decoration,
    this.onSaved,
    this.maxLength,
    this.validator,
    this.keyboardType,
    this.maxLines,
    this.minLines,
  }) : super(key: key);

  final String initialValue;
  final InputDecoration decoration;
  final SavedCallback onSaved;
  final int maxLength;
  final ValidatorCallback validator;
  final TextInputType keyboardType;
  final int maxLines;
  final int minLines;


  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      decoration: decoration,
      onSaved: (value) => onSaved(maxLength != null && value.length > maxLength ? value.substring(0, maxLength) : value),
      validator: validator,
      maxLength: maxLength,
      keyboardType: keyboardType,
      maxLines: maxLines,
      minLines: minLines,
    );
  }
}