import 'package:flutter/material.dart';

typedef PressedCallback = Function();

class IconButtonLoading extends StatelessWidget {
  const IconButtonLoading(
    {Key key,
    this.loading = false,
    @required this.icon,
    @required this.onPressed,
    this.color,
  }) : super(key: key);

  final bool loading;
  final Widget icon;
  final PressedCallback onPressed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return loading ? IconButton(// TODO: _isPdfLoading doesnt work
      color: color,
      icon: SizedBox(
        width: 16,
        height: 16,
        child: CircularProgressIndicator()
      ),
      onPressed: null,
    ) : IconButton(
      color: color,
      icon: icon,
      onPressed: onPressed,
    );
  }
}