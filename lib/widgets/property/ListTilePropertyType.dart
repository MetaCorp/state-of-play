

import 'package:flutter/material.dart';

typedef PressCallback = void Function();
typedef PressAddCallback = void Function();
typedef PressRemoveCallback = void Function();

class ListTilePropertyType extends StatelessWidget {
  const ListTilePropertyType({ Key key, this.text, this.labelText, this.onPress, this.onPressAdd, this.onPressRemove }) : super(key: key);

  final String text;
  final String labelText;
  final PressCallback onPress;
  final PressAddCallback onPressAdd;
  final PressRemoveCallback onPressRemove;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.all(0),
      title: Row(
        children: [
          Text(text != null ? text : labelText),
        ]
      ),
      onTap: onPress,
      tileColor: null,
    );
    
    // Row(
    //   children: [
    //     RaisedButton(
    //       child: Text(
    //         ,
    //         style: TextStyle(
    //           color: text != null ? Colors.black : Colors.black
    //         ),
    //       ),
    //       onPressed: text != null ? null : onPress,
    //     ),
    //     text != null ? RaisedButton(
    //       child: Icon(Icons.close),
    //       onPressed: onPressRemove,
    //     ) : Container(),
    //     onPressAdd != null && text == null ? RaisedButton(
    //       child: Icon(Icons.add),
    //       onPressed: onPressAdd,
    //     ) : Container()
    //   ],
    // );
  }
}