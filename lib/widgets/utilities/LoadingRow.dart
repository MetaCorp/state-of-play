
import 'package:flutter/material.dart';

typedef PressCallback = Function();

class LoadingRow extends StatelessWidget {
  const LoadingRow({
    Key key,
    @required this.text,
    @required this.loading,
    this.color = Colors.black,
  }) : super(key: key);

  final String text;
  final bool loading;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(text),
        loading ? Container(
          margin: EdgeInsets.only(left: 8),
          child: SizedBox(
            height: 16,
            width: 16,
            child: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(color),
              strokeWidth: 2,
            )
          ),
        ) : Container() 
      ]
    );
  }
}