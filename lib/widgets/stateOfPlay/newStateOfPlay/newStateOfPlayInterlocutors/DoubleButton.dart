

import 'package:flutter/material.dart';

typedef PressCallback = void Function();
typedef PressAddCallback = void Function();
typedef PressRemoveCallback = void Function();

class DoubleButton extends StatelessWidget {
  const DoubleButton({ Key key, this.text, this.labelText, this.onPress, this.onPressAdd, this.onPressRemove }) : super(key: key);

  final String text;
  final String labelText;
  final PressCallback onPress;
  final PressAddCallback onPressAdd;
  final PressRemoveCallback onPressRemove;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        RaisedButton(
          child: Text(
            text != null ? text : labelText,
            style: TextStyle(
              color: text != null ? Colors.black : Colors.black
            ),
          ),
          onPressed: text != null ? null : onPress,
        ),
        text != null ? RaisedButton(
          child: Icon(Icons.close),
          onPressed: onPressRemove,
        ) : Container(),
        onPressAdd != null && text == null ? RaisedButton(
          child: Icon(Icons.add),
          onPressed: onPressAdd,
        ) : Container()
      ],
    );
  }
}