import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatelessWidget {
  const Settings({ Key key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: RaisedButton(
        child: Text('Déconnection'),
        onPressed: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setStringList("token", null);
          Navigator.popAndPushNamed(context, '/login');
        },
      )
    );
  }
}