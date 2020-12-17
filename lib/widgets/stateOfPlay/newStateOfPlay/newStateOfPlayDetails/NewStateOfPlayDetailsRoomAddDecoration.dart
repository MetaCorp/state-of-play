import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:flutter_tests/models/StateOfPlay.dart' as sop;
// import 'package:intl/intl.dart';// DateFormat

typedef SelectCallback = void Function(List<String>);

class NewStateOfPlayDetailsRoomAddDecoration extends StatefulWidget {
  NewStateOfPlayDetailsRoomAddDecoration({ Key key, this.onSelect }) : super(key: key);

  final SelectCallback onSelect;

  @override
  _NewStateOfPlayDetailsRoomAddDecorationState createState() => _NewStateOfPlayDetailsRoomAddDecorationState();
}

// adb reverse tcp:9002 tcp:9002

class _NewStateOfPlayDetailsRoomAddDecorationState extends State<NewStateOfPlayDetailsRoomAddDecoration> {

  TextEditingController _searchController = TextEditingController(text: "");
  TextEditingController _newDecorationController = TextEditingController(text: "");

  List<String> _selectedDecorations = []; 

  @override
  void dispose() {
    _searchController.dispose();

    super.dispose();
  }

  void _showDialogNewDecoration (context) async {
    await showDialog(
      context: context,
      child: Mutation(
        options: MutationOptions(
          documentNode: gql('''
            mutation createDecoration(\$data: CreateDecorationInput!) {
              createDecoration(data: \$data) {
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
              controller: _newDecorationController,
              autofocus: true,
              decoration: InputDecoration(
                labelText: "Entrez un nom de décoration"
              ),
            ),
            actions: [
              new FlatButton(
                child: Text('ANNULER'),
                onPressed: () {
                  _newDecorationController.text = "";
                  Navigator.pop(context);
                }
              ),
              new FlatButton(
                child: Text('AJOUTER'),
                onPressed: () async {
                  MultiSourceResult result = runMutation({
                    "data": {
                      "type": _newDecorationController.text
                    }
                  });

                  await result.networkResult;

                  setState(() { });
                  Navigator.pop(context);

                  _newDecorationController.text = "";
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
          query decorations(\$filter: DecorationsFilterInput!) {
            decorations (filter: \$filter) {
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
          body = Center(child: CircularProgressIndicator());
        }
        else {

          List<String> decorations = (result.data["decorations"] as List).map((decoration) => decoration["type"].toString()).toList();
          print('decorations length: ' + decorations.length.toString());

          if (decorations.length == 0) {
            body = Text("no decoration");
          }
          else {
            body = ListView.separated(
              padding: EdgeInsets.only(top: 8),
              itemCount: decorations.length,
              itemBuilder: (_, i) => ListTile(
                title: Text(decorations[i]),
                selected: _selectedDecorations.contains(decorations[i]),
                onTap: () {
                  setState(() {
                    if (!_selectedDecorations.contains(decorations[i]))
                      _selectedDecorations.add(decorations[i]);
                    else
                      _selectedDecorations.remove(decorations[i]);
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
                  updateQuery: (existing, newDecorations) => ({
                    "decorations": newDecorations["decorations"]
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
                onPressed: () => _showDialogNewDecoration(context)
              ),
              IconButton(
                icon: Icon(Icons.check),
                onPressed: () {
                  widget.onSelect(_selectedDecorations);
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