import 'package:flutter/material.dart';

typedef SaveCallback = void Function();


class NewStateOfPlaySignature extends StatefulWidget {
  NewStateOfPlaySignature({ Key key, this.onSave}) : super(key: key);

  final SaveCallback onSave;

  @override
  _NewStateOfPlaySignatureState createState() => new _NewStateOfPlaySignatureState();
}

class _NewStateOfPlaySignatureState extends State<NewStateOfPlaySignature> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Signature"),
        RaisedButton(
          child: Text("Visualiser l'état des lieux"),
          onPressed: widget.onSave,
        )
      ]
    );
  }
}