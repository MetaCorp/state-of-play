import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({ Key key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('Bienvenue'),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            title: Text('États des lieux'),
            onTap: () => Navigator.popAndPushNamed(context, '/state-of-plays'),
          ),
          ListTile(
            title: Text('Propriétés'),
            onTap: () => Navigator.popAndPushNamed(context, '/properties'),
          ),
        ],
      ),
    );
  }
}