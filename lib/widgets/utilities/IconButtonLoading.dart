import 'package:flutter/material.dart';

typedef PressedCallback = Function();

class IconButtonLoading extends StatelessWidget {
  const IconButtonLoading(
    {Key key,
    this.loading = false,
    @required this.icon,
    @required this.onPressed
  }) : super(key: key);

  final bool loading;
  final Widget icon;
  final PressedCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return loading ? IconButton(// TODO: _isPdfLoading doesnt work
      icon: SizedBox(
        width: 16,
        height: 16,
        child: CircularProgressIndicator()
      ),
      onPressed: null,
    ) : IconButton(
      icon: icon,
      onPressed: onPressed,
    );
  }
}