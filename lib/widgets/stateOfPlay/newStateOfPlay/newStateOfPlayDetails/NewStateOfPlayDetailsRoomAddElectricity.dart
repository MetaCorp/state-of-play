import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:flutter_tests/models/StateOfPlay.dart' as sop;
// import 'package:intl/intl.dart';// DateFormat

typedef SelectCallback = void Function(List<String>);

class NewStateOfPlayDetailsRoomAddElectricity extends StatefulWidget {
  NewStateOfPlayDetailsRoomAddElectricity({ Key key, this.onSelect }) : super(key: key);

  final SelectCallback onSelect;

  @override
  _NewStateOfPlayDetailsRoomAddElectricityState createState() => _NewStateOfPlayDetailsRoomAddElectricityState();
}

// adb reverse tcp:9002 tcp:9002

class _NewStateOfPlayDetailsRoomAddElectricityState extends State<NewStateOfPlayDetailsRoomAddElectricity> {

  TextEditingController _searchController = TextEditingController(text: "");
  TextEditingController _newElectricityController = TextEditingController(text: "");

  List<String> _selectedElectricities = []; 

  @override
  void dispose() {
    _searchController.dispose();

    super.dispose();
  }

  void _showDialogNewElectricity (context) async {
    await showDialog(
      context: context,
      child: Mutation(
        options: MutationOptions(
          documentNode: gql('''
            mutation createElectricity(\$data: CreateElectricityInput!) {
              createElectricity(data: \$data) {
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
              controller: _newElectricityController,
              autofocus: true,
              decoration: InputDecoration(
                labelText: "Entrez un nom d'électricité/chauffage"
              ),
            ),
            actions: [
              new FlatButton(
                child: Text('ANNULER'),
                onPressed: () {
                  _newElectricityController.text = "";
                  Navigator.pop(context);
                }
              ),
              new FlatButton(
                child: Text('AJOUTER'),
                onPressed: () async {
                  MultiSourceResult result = runMutation({
                    "data": {
                      "type": _newElectricityController.text
                    }
                  });

                  await result.networkResult;

                  setState(() { });
                  Navigator.pop(context);

                  _newElectricityController.text = "";
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
          query electricities(\$filter: ElectricitiesFilterInput!) {
            electricities (filter: \$filter) {
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

        List<Map> electricities;

        if (result.hasException) {
          body = Text(result.exception.toString());
        }
        else if (result.loading || result.data == null) {
          body = Center(child: CircularProgressIndicator());
        }
        else {

          electricities = (result.data["electricities"] as List).map((electricity) => {
            "id": electricity["id"],
            "type": electricity["type"],
          }).toList();
          print('electricities length: ' + electricities.length.toString());

          if (electricities.length == 0) {
            body = Text("no electricity");
          }
          else {
            body = ListView.separated(
              padding: EdgeInsets.only(top: 8),
              itemCount: electricities.length,
              itemBuilder: (_, i) => ListTile(
                title: Text(electricities[i]["type"]),
                selected: _selectedElectricities.contains(electricities[i]["id"]),
                onTap: () {
                  setState(() {
                    if (!_selectedElectricities.contains(electricities[i]["id"]))
                      _selectedElectricities.add(electricities[i]["id"]);
                    else
                      _selectedElectricities.remove(electricities[i]["id"]);
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
                  updateQuery: (existing, newElectricitys) => ({
                    "electricities": newElectricitys["electricities"]
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
                onPressed: () => _showDialogNewElectricity(context)
              ),
              IconButton(
                icon: Icon(Icons.check),
                onPressed: () {
                  widget.onSelect(_selectedElectricities.map((id) => electricities.firstWhere((electrity) => electrity["id"] == id)["type"].toString()).toList());
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