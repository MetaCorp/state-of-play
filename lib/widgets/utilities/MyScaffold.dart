import 'package:flutter/material.dart';

import 'package:flutter_tests/widgets/utilities/MyDrawer.dart';

class MyScaffold extends StatelessWidget {

  final Widget body;
  final Widget appBar;

  MyScaffold({ this.body, this.appBar });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: body,
      drawer: MyDrawer(),
    );
  }
}