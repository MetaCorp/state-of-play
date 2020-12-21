
import 'package:flutter/material.dart';

typedef PressCallback = Function();

class ListTileShop extends StatelessWidget {
  const ListTileShop({
    Key key,
    @required this.loading,
    @required this.onPress,
    @required this.price,
    @required this.title
  }) : super(key: key);

  final bool loading;
  final PressCallback onPress;
  final double price;
  final String title;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        children: [
          Text(title),
          Spacer(),
          RaisedButton(
            child: Row(
              children: [
                Text(price.toString() + ' €'),
                loading ? Container(
                  margin: EdgeInsets.only(left: 8),
                  child: SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(
                      valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
                      strokeWidth: 2,
                    )
                  ),
                ) : Container() 
              ]
            ),
            onPressed: onPress
          )
        ]
      )
    );
  }
}