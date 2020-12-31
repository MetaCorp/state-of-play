import 'package:flutter/material.dart';

typedef PressedCallback = Function();

class RaisedButtonLoading extends StatelessWidget {
  const RaisedButtonLoading({ Key key, this.child, this.loading = false, this.color, this.onPressed }) : super(key: key);

  final Widget child;
  final bool loading;
  final Color color;
  final PressedCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          child,
          !loading ? Container() : SizedBox( width: 8),
          !loading ? Container() : SizedBox(
            height: 16,
            width: 16,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.grey[600]),
              strokeWidth: 2,
            )
          ),
        ]
      ),
      color: color,
      onPressed: loading ? null : onPressed
    );
  }
}