

import 'package:flutter/material.dart';
import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/newStateOfPlayInterlocutors/DoubleButton.dart';

typedef PressAddCallBack = void Function();

class Header extends StatelessWidget {
  const Header({ Key key, this.title, this.onPressAdd }) : super(key: key);

  final String title;
  final PressAddCallback onPressAdd;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title),
        Spacer(),
        RaisedButton(
          child: Icon(Icons.add),
          onPressed: onPressAdd
        )
      ],
    );
  }
}