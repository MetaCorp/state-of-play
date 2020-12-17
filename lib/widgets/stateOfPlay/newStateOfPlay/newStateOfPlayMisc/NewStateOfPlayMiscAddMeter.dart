import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:flutter_tests/models/StateOfPlay.dart' as sop;
// import 'package:intl/intl.dart';// DateFormat

typedef SelectCallback = void Function(List<String>);

class NewStateOfPlayMiscAddMeter extends StatefulWidget {
  NewStateOfPlayMiscAddMeter({ Key key, this.onSelect }) : super(key: key);

  final SelectCallback onSelect;

  @override
  _NewStateOfPlayMiscAddMeterState createState() => _NewStateOfPlayMiscAddMeterState();
}

// adb reverse tcp:9002 tcp:9002

class _NewStateOfPlayMiscAddMeterState extends State<NewStateOfPlayMiscAddMeter> {

  TextEditingController _searchController = TextEditingController(text: "");
  TextEditingController _newMeterController = TextEditingController(text: "");

  List<String> _selectedMeters = []; 

  @override
  void dispose() {
    _searchController.dispose();

    super.dispose();
  }

  void _showDialogNewMeter (context) async {
    await showDialog(
      context: context,
      child: Mutation(
        options: MutationOptions(
          documentNode: gql('''
            mutation createMeter(\$data: CreateMeterInput!) {
              createMeter(data: \$data) {
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
              controller: _newMeterController,
              autofocus: true,
              decoration: InputDecoration(
                labelText: "Entrez un nom de compteur"
              ),
            ),
            actions: [
              new FlatButton(
                child: Text('ANNULER'),
                onPressed: () {
                  _newMeterController.text = "";
                  Navigator.pop(context);
                }
              ),
              new FlatButton(
                child: Text('AJOUTER'),
                onPressed: () async {
                  MultiSourceResult result = runMutation({
                    "data": {
                      "type": _newMeterController.text
                    }
                  });

                  await result.networkResult;

                  setState(() { });
                  Navigator.pop(context);

                  _newMeterController.text = "";
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
          query meters(\$filter: MetersFilterInput!) {
            meters (filter: \$filter) {
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

        List<Map> meters;

        if (result.hasException) {
          body = Text(result.exception.toString());
        }
        else if (result.loading || result.data == null) {
          body = Center(child: CircularProgressIndicator());
        }
        else {

          meters = (result.data["meters"] as List).map((meter) => {
            "id": meter["id"],
            "type": meter["type"],
          }).toList();
          print('meters length: ' + meters.length.toString());

          if (meters.length == 0) {
            body = Text("no meter");
          }
          else {
            body = ListView.separated(
              padding: EdgeInsets.only(top: 8),
              itemCount: meters.length,
              itemBuilder: (_, i) => ListTile(
                title: Text(meters[i]["type"]),
                selected: _selectedMeters.contains(meters[i]["id"]),
                onTap: () {
                  setState(() {
                    if (!_selectedMeters.contains(meters[i]["id"]))
                      _selectedMeters.add(meters[i]["id"]);
                    else
                      _selectedMeters.remove(meters[i]["id"]);
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
                  updateQuery: (existing, newMeters) => ({
                    "meters": newMeters["meters"]
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
                onPressed: () => _showDialogNewMeter(context)
              ),
              IconButton(
                icon: Icon(Icons.check),
                onPressed: () {
                  widget.onSelect(_selectedMeters.map((id) => meters.firstWhere((meter) => meter["id"] == id)["type"].toString()).toList());
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