import 'package:flutter/material.dart';
import 'package:flutter_tests/models/StateOfPlay.dart' as sop;
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_tests/widgets/accounts/NewAccount.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Accounts extends StatefulWidget {
  Accounts({Key key}) : super(key: key);

  @override
  _AccountsState createState() => _AccountsState();
}

class _AccountsState extends State<Accounts> {

  sop.User _user;

  SharedPreferences _prefs;

  Future<Null> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _prefs = prefs;
    });
  }

  @override
  void initState() {
    getSharedPrefs();
    
    super.initState();
  }

  void _showDialogLimitAccount(context) async {
    await showDialog(
      context: context,
      child: AlertDialog(
        content: Text("Votre compte est limité à 5 profils."),
        actions: [
          FlatButton(
            child: Text('COMPRIS'),
            onPressed: () async {
              Navigator.pop(context);
            }
          )
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
        documentNode: gql('''
          query user {
            user {
              accounts
            }
          }
        ''')
      ),
      builder: (
        QueryResult result, {
        Refetch refetch,
        FetchMore fetchMore,
      }) {

        debugPrint('userResult: ' + result.loading.toString());
        debugPrint('userResult hasException: ' + result.hasException.toString());
        debugPrint('userResult data: ' + result.data.toString());
        if (result.hasException) {
          if (result.exception.graphqlErrors.length > 0) { 
            debugPrint("userResult exception: " + result.exception.graphqlErrors[0].toString());
            debugPrint("userResult exception: " + result.exception.graphqlErrors[0].extensions.toString());
          }
          else
            debugPrint("userResult clientException: " + result.exception.clientException.message);
        }
        debugPrint('');

        if (result.data != null && result.data["user"] != null && !result.loading) {
          _user = sop.User.fromJSON(result.data["user"]);
          debugPrint('user: ' + _user.firstName.toString());
        }

        if (_user == null) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Profils')
            ),
            body: Center(child: CircularProgressIndicator())
          );
        }
        
        // return
        return Scaffold(
          appBar: AppBar(
            title: Text('Profils'),
            actions: [
              _user != null ? IconButton(
                icon: Icon(Icons.add),
                onPressed: () async {
                  if (_user.accounts.length < 5) {
                    await Navigator.push(context, PageRouteBuilder(pageBuilder: (_, __, ___) => NewAccount(accounts: _user.accounts)));
                    setState(() { });
                  }
                  else
                    _showDialogLimitAccount(context);
                },
              ) : Container()
            ],
          ),
          body: Container(
            margin: EdgeInsets.only(top: 8),
            child: Column(
              children: [
                Flexible(
                  child: ListView.separated(
                    itemCount: _user.accounts.length,
                    itemBuilder: (_, i) => ListTile(
                      title: Row(
                        children: [
                          Text(_user.accounts[i]["firstName"] + ' ' + _user.accounts[i]["lastName"]),
                          Spacer(),
                          IconButton(
                            icon: Icon(Icons.chevron_right),
                          )
                        ]
                      ),
                      onTap: () {
                        _prefs.setString("account", jsonEncode(_user.accounts[i]));
                        Navigator.popAndPushNamed(context, '/state-of-plays');
                      }
                    ),
                    separatorBuilder: (context, index) {
                      return Divider();
                    },
                  ),
                ),
              ],
            )
          )
        );
      }
    );
  }
}