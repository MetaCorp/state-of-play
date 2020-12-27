import 'package:flutter/material.dart';

typedef ChangedCallback = Function(String);

class MyTextField extends StatefulWidget {
  MyTextField({ Key key, this.text, this.onChanged, this.maxLength, this.labelText }) : super(key: key);

  String text;
  ChangedCallback onChanged;
  int maxLength;
  String labelText;

  @override
  _MyTextFieldState createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  TextEditingController _controller;

  @override
  void initState() { 
    super.initState();
    _controller = TextEditingController(text: widget.text);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: InputDecoration(labelText: widget.labelText),
      onChanged: (String newVal) {
        // if(newVal.length <= widget.maxLength){
          widget.onChanged(newVal);
        // } else {
          // _controller.text = newVal.substring(0, widget.maxLength);
          // _controller.selection = TextSelection(baseOffset: widget.maxLength - 1);
        // }
      },
      // (value) => widget.insurance.company = value,
      maxLength: widget.maxLength,
    );
  }
}