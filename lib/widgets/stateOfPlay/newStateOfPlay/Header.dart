

import 'package:flutter/material.dart';
import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/newStateOfPlayInterlocutors/ListTileInterlocutor.dart';

typedef PressAddCallBack = void Function();

class Header extends StatelessWidget {
  const Header({ Key key, this.title, this.onPressAdd }) : super(key: key);

  final String title;
  final PressAddCallback onPressAdd;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold
            ),
          ),
          Spacer(),
          RaisedButton(
            child: Icon(Icons.add),
            onPressed: onPressAdd,
            color: Colors.grey[200],
          )
        ],
      ),
    );
  }
}