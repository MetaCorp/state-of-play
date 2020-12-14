import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:flutter_tests/models/StateOfPlay.dart' as sop;
// import 'package:intl/intl.dart';// DateFormat

typedef SelectCallback = void Function(List<String>);

class NewStateOfPlayMiscAddKey extends StatefulWidget {
  NewStateOfPlayMiscAddKey({ Key key, this.onSelect }) : super(key: key);

  final SelectCallback onSelect;

  @override
  _NewStateOfPlayMiscAddKeyState createState() => _NewStateOfPlayMiscAddKeyState();
}

// adb reverse tcp:9002 tcp:9002

class _NewStateOfPlayMiscAddKeyState extends State<NewStateOfPlayMiscAddKey> {

  TextEditingController _searchController = TextEditingController(text: "");
  TextEditingController _newKeyController = TextEditingController(text: "");

  List<String> _selectedKeys = []; 

  @override
  void dispose() {
    _searchController.dispose();

    super.dispose();
  }

  void _showDialogNewKey (context) async {
    await showDialog(
      context: context,
      child: Mutation(
        options: MutationOptions(
          documentNode: gql('''
            mutation createKey(\$data: CreateKeyInput!) {
              createKey(data: \$data) {
                id
                type
              }
            }
          '''),
          update: (Cache cache, QueryResult result) {
            return cache;
          },
          onCompleted: (dynamic resultData) {
          },
        ),
        builder: (
          RunMutation runMutation,
          QueryResult result,
        ) {
            
          return AlertDialog(
            content: TextField(
              controller: _newKeyController,
              autofocus: true,
              decoration: InputDecoration(
                labelText: "Entrez un nom de clé"
              ),
            ),
            actions: [
              new FlatButton(
                child: Text('ANNULER'),
                onPressed: () {
                  _newKeyController.text = "";
                  Navigator.pop(context);
                }
              ),
              new FlatButton(
                child: Text('AJOUTER'),
                onPressed: () async {
                  MultiSourceResult result = runMutation({
                    "data": {
                      "type": _newKeyController.text
                    }
                  });

                  await result.networkResult;

                  setState(() { });
                  Navigator.pop(context);

                  _newKeyController.text = "";
                }
              )
            ],
          );
        }
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
        documentNode: gql('''
          query keys(\$filter: KeysFilterInput!) {
            keys (filter: \$filter) {
              id
              type
            }
          }
        '''),
        variables: {
          "filter": {
            "search": _searchController.text
          }
        } 
      ),
      builder: (
        QueryResult result, {
        Refetch refetch,
        FetchMore fetchMore,
      }) {

        Widget body;
        
        print('loading: ' + result.loading.toString());
        print('exception: ' + result.exception.toString());
        print('data: ' + result.data.toString());
        print('');

        if (result.hasException) {
          body = Text(result.exception.toString());
        }
        else if (result.loading || result.data == null) {
          body = CircularProgressIndicator();// TODO center
        }
        else {

          List<String> keys = (result.data["keys"] as List).map((key) => key["type"].toString()).toList();
          print('keys length: ' + keys.length.toString());

          if (keys.length == 0) {
            body = Text("no key");
          }
          else {
            body = ListView.separated(
              itemCount: keys.length,
              itemBuilder: (_, i) => ListTile(
                title: Text(keys[i]),
                selected: _selectedKeys.contains(keys[i]),
                onTap: () {
                  setState(() {
                    if (!_selectedKeys.contains(keys[i]))
                      _selectedKeys.add(keys[i]);
                    else
                      _selectedKeys.remove(keys[i]);
                  });
                },
              ),
              separatorBuilder: (context, index) {
                return Divider();
              },
            );
          }

        }

        return Scaffold(
          appBar: AppBar(
            title: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Entrez votre recherche'
              ),
              onChanged: (value) {
                fetchMore(FetchMoreOptions(
                  variables: { "filter": { "search": value } },
                  updateQuery: (existing, newKeys) => ({
                    "keys": newKeys["keys"]
                  }),
                ));
              }
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () => null,
              ),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () => _showDialogNewKey(context)
              ),
              IconButton(
                icon: Icon(Icons.check),
                onPressed: () {
                  widget.onSelect(_selectedKeys);
                  Navigator.pop(context);
                }
              ),
            ],
            backgroundColor: Colors.grey,
          ),
          body: body
        );
      }
    );
  }
}