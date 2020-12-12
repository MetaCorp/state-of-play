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

  List<String> _selectedElectricitys = []; 

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

        if (result.hasException) {
          body = Text(result.exception.toString());
        }
        else if (result.loading || result.data == null) {
          body = CircularProgressIndicator();// TODO center
        }
        else {

          List<String> electricities = (result.data["electricities"] as List).map((electricity) => electricity["type"].toString()).toList();
          print('electricities length: ' + electricities.length.toString());

          if (electricities.length == 0) {
            body = Text("no electricity");
          }
          else {
            body = ListView.separated(
              itemCount: electricities.length,
              itemBuilder: (_, i) => ListTile(
                title: Text(electricities[i]),
                selected: _selectedElectricitys.contains(electricities[i]),
                onTap: () {
                  setState(() {
                    if (!_selectedElectricitys.contains(electricities[i]))
                      _selectedElectricitys.add(electricities[i]);
                    else
                      _selectedElectricitys.remove(electricities[i]);
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
                  widget.onSelect(_selectedElectricitys);
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