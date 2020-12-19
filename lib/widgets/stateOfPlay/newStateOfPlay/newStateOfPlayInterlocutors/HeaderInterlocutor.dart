import 'package:flutter/material.dart';

class HeaderInterlocutor extends StatelessWidget {
  const HeaderInterlocutor({ Key key, this.text }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomLeft,
      padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        text + " :",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold
        ),
        textAlign: TextAlign.left,
      ),
    );
  }
}