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
        children: [
          UserAccountsDrawerHeader(
            accountEmail: new Text(""),//to keep since needed
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.cyan,
              child: new Text("txt"),
            ),
            accountName:  Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(shape: BoxShape.circle),
                  child: CircleAvatar(
                    backgroundColor: Colors.cyan,
                    child: new Text("txt"),
                  ),
                ),
                SizedBox(width: 12),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('user'),
                    SizedBox(height: 4),
                    Text('@User'),
                  ],
                ),
              ],
            ),
          ),
          ListTile(
            title: Text('États des lieux'),
            leading: Icon(Icons.text_snippet),
            onTap: () => Navigator.popAndPushNamed(context, '/state-of-plays'),
          ),
          Divider(thickness: .8, indent: 18, endIndent: 18),
          ListTile(
            title: Text('Propriétés'),
            leading: Icon(Icons.home),
            onTap: () => Navigator.popAndPushNamed(context, '/properties'),
          ),
          Divider(thickness: 2.0),
          ListTile(
            title: Text('Propriétaires'),
            leading: Icon(Icons.people_alt),
            onTap: () => Navigator.popAndPushNamed(context, '/owners'),
          ),
          Divider(thickness: .8, indent: 18, endIndent: 18),
          ListTile(
            title: Text('Mandataires'),
            leading: Icon(Icons.people_alt),
            onTap: () => Navigator.popAndPushNamed(context, '/representatives'),
          ),
          Divider(thickness: .8, indent: 18, endIndent: 18),
          ListTile(
            title: Text('Locataires'),
            leading: Icon(Icons.people_alt),
            onTap: () => Navigator.popAndPushNamed(context, '/tenants'),
          ),
          Divider(thickness: 2.0),
          // TODO align not working
          ListTile(
            title: Text('Paramêtres'),
            leading: Icon(Icons.settings),
            onTap: () => Navigator.popAndPushNamed(context, '/settings'),
          ),  
        ],
      ),
    );
  }
}