import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:flutter_tests/models/StateOfPlay.dart' as sop;
// import 'package:intl/intl.dart';// DateFormat

typedef SelectCallback = void Function(List<String>);

class NewStateOfPlayDetailsRoomAddEquipment extends StatefulWidget {
  NewStateOfPlayDetailsRoomAddEquipment({ Key key, this.onSelect }) : super(key: key);

  final SelectCallback onSelect;

  @override
  _NewStateOfPlayDetailsRoomAddEquipmentState createState() => _NewStateOfPlayDetailsRoomAddEquipmentState();
}

// adb reverse tcp:9002 tcp:9002

class _NewStateOfPlayDetailsRoomAddEquipmentState extends State<NewStateOfPlayDetailsRoomAddEquipment> {

  TextEditingController _searchController = TextEditingController(text: "");
  TextEditingController _newEquipmentController = TextEditingController(text: "");

  List<String> _selectedEquipments = []; 

  @override
  void dispose() {
    _searchController.dispose();

    super.dispose();
  }

  void _showDialogNewEquipment (context) async {
    await showDialog(
      context: context,
      child: Mutation(
        options: MutationOptions(
          documentNode: gql('''
            mutation createEquipment(\$data: CreateEquipmentInput!) {
              createEquipment(data: \$data) {
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
              controller: _newEquipmentController,
              autofocus: true,
              decoration: InputDecoration(
                labelText: "Entrez un nom d'équipement"
              ),
            ),
            actions: [
              new FlatButton(
                child: Text('ANNULER'),
                onPressed: () {
                  _newEquipmentController.text = "";
                  Navigator.pop(context);
                }
              ),
              new FlatButton(
                child: Text('AJOUTER'),
                onPressed: () async {
                  MultiSourceResult result = runMutation({
                    "data": {
                      "type": _newEquipmentController.text
                    }
                  });

                  await result.networkResult;

                  setState(() { });
                  Navigator.pop(context);

                  _newEquipmentController.text = "";
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
          query equipments(\$filter: EquipmentsFilterInput!) {
            equipments (filter: \$filter) {
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

          List<String> equipments = (result.data["equipments"] as List).map((electricity) => electricity["type"].toString()).toList();
          print('equipments length: ' + equipments.length.toString());

          if (equipments.length == 0) {
            body = Text("no electricity");
          }
          else {
            body = ListView.separated(
              itemCount: equipments.length,
              itemBuilder: (_, i) => ListTile(
                title: Text(equipments[i]),
                selected: _selectedEquipments.contains(equipments[i]),
                onTap: () {
                  setState(() {
                    if (!_selectedEquipments.contains(equipments[i]))
                      _selectedEquipments.add(equipments[i]);
                    else
                      _selectedEquipments.remove(equipments[i]);
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
                  updateQuery: (existing, newEquipments) => ({
                    "equipments": newEquipments["equipments"]
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
                onPressed: () => _showDialogNewEquipment(context)
              ),
              IconButton(
                icon: Icon(Icons.check),
                onPressed: () {
                  widget.onSelect(_selectedEquipments);
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