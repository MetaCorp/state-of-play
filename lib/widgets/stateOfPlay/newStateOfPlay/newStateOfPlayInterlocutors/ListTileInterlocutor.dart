

import 'package:flutter/material.dart';

typedef PressCallback = void Function();
typedef PressAddCallback = void Function();
typedef PressRemoveCallback = void Function();

class ListTileInterlocutor extends StatelessWidget {
  const ListTileInterlocutor({ Key key, this.text, this.labelText, this.onPress, this.onPressAdd, this.onPressRemove }) : super(key: key);

  final String text;
  final String labelText;
  final PressCallback onPress;
  final PressAddCallback onPressAdd;
  final PressRemoveCallback onPressRemove;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              text != null ? text : labelText,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Spacer(),
          IconButton(
            icon: text != null ? Icon(Icons.close) : Icon(Icons.add),
            onPressed: text != null ? onPressRemove : onPressAdd,
          )
        ]
      ),
      onTap: onPress,
      tileColor: text != null ? null : Colors.grey[200],
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