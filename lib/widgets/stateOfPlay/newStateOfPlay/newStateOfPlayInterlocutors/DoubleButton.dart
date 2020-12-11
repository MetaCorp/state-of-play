

import 'package:flutter/material.dart';

typedef PressCallback = void Function();
typedef PressAddCallback = void Function();

class DoubleButton extends StatelessWidget {
  const DoubleButton({ Key key, this.text, this.hintText, this.onPress, this.onPressAdd }) : super(key: key);

  final String text;
  final String hintText;
  final PressCallback onPress;
  final PressAddCallback onPressAdd;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        RaisedButton(
          child: Text(
            text != null ? text : hintText,
            style: TextStyle(
              color: text != null ? Colors.black : Colors.white
            ),
          ),
          onPressed: onPress,
        ),
        RaisedButton(
          child: Icon(Icons.add),
          onPressed: onPressAdd,
        )
      ],
    );
  }
}