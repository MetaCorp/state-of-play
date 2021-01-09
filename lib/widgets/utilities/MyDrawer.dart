import 'package:flutter/material.dart';
import 'package:flutter_tests/models/StateOfPlay.dart' as sop;
import 'package:flutter_email_sender/flutter_email_sender.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({ Key key, this.user, this.account }) : super(key: key);

  final sop.User user;
  final dynamic account;

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
          UserAccountsDrawerHeader(// TODO : change Account
            accountEmail: Text(user.email), //to keep since needed
            accountName: account != null ? Text(account["firstName"] + ' ' + account["lastName"]) : Text(user.firstName + ' ' + user.lastName),
            otherAccountsPictures: [
              account != null ? IconButton(
                icon: Icon(Icons.supervised_user_circle),
                onPressed: () => Navigator.popAndPushNamed(context, '/accounts'),
              ) : Container()
            ],
            currentAccountPicture: user != null ? CircleAvatar(
              radius: 30.0,
              backgroundImage: user.logo != null ? NetworkImage(user.logo) : null,
              backgroundColor: Colors.grey,
              child: user.logo == null ?  Text(user.firstName[0].toUpperCase() + user.lastName[0].toUpperCase()) : null,
            ) : CircularProgressIndicator(), 
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
          Divider(thickness: .8, indent: 18, endIndent: 18),
          ListTile(
            title: Text('Nous contacter'),
            leading: Icon(Icons.account_circle),
            onTap: () async {
              final Email email = Email(
                // body: 'Email body',
                // subject: 'Email subject',
                recipients: ['housely.contact@gmail.com'],
                // cc: ['cc@example.com'],
                // bcc: ['bcc@example.com'],
                // attachmentPaths: ['/path/to/attachment.zip'],
                isHTML: false,
              );

              await FlutterEmailSender.send(email);
              Navigator.pop(context);
            },
          ),
          // Divider(thickness: 2.0), // TODO
          // ListTile(
          //   title: Text('Boutique'),
          //   leading: Icon(Icons.shop),
          //   onTap: () => Navigator.popAndPushNamed(context, '/shop'),
          // ),
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