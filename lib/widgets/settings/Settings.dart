import 'package:flutter/material.dart';
import 'package:flutter_tests/main.dart';
import 'package:flutter_tests/widgets/settings/Account.dart';
import 'package:flutter_tests/widgets/utilities/MyScaffold.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  Settings({ Key key }) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {

    return MyScaffold(
      appBar: AppBar(
        title: Text('Paramètres'),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 8),
          child: Column(
            children: [
              ListTile(
                title: Row(
                  children: [
                    Text('Mon Compte'),
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.chevron_right),
                    )
                  ]
                ),
                onTap: () {
                  Navigator.push(context, PageRouteBuilder(pageBuilder: (_, __, ___) => Account()));
                },
              ),
              Divider(),
              SizedBox(
                height: 16,
              ),
              RaisedButton(
                color: Colors.red[700],
                child: Text(
                  'Déconnexion',
                  style: TextStyle(
                    color: Colors.white
                  ),
                ),
                onPressed: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.setString("token", null);
                  client.value.cache.reset();
                  Navigator.popAndPushNamed(context, '/login');
                },
              ),
            ]
          )
        )
      )
    );
  }
}