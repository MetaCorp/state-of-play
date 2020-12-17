import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:flutter_tests/models/StateOfPlay.dart' as sop;
// import 'package:intl/intl.dart';// DateFormat

typedef SelectCallback = void Function(List<String>);

class NewStateOfPlayDetailsAddRoom extends StatefulWidget {
  NewStateOfPlayDetailsAddRoom({ Key key, this.onSelect }) : super(key: key);

  final SelectCallback onSelect;

  @override
  _NewStateOfPlayDetailsAddRoomState createState() => _NewStateOfPlayDetailsAddRoomState();
}

// adb reverse tcp:9002 tcp:9002

class _NewStateOfPlayDetailsAddRoomState extends State<NewStateOfPlayDetailsAddRoom> {

  TextEditingController _searchController = TextEditingController(text: "");
  TextEditingController _newRoomController = TextEditingController(text: "");

  List<String> _selectedRooms = []; 

  @override
  void dispose() {
    _searchController.dispose();

    super.dispose();
  }

  void _showDialogNewRoom (context) async {
    await showDialog(
      context: context,
      child: Mutation(
        options: MutationOptions(
          documentNode: gql('''
            mutation createRoom(\$data: CreateRoomInput!) {
              createRoom(data: \$data) {
                id
                name
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
              controller: _newRoomController,
              autofocus: true,
              decoration: InputDecoration(
                labelText: "Entrez un nom de pièce"
              ),
            ),
            actions: [
              new FlatButton(
                child: Text('ANNULER'),
                onPressed: () {
                  _newRoomController.text = "";
                  Navigator.pop(context);
                }
              ),
              new FlatButton(
                child: Text('AJOUTER'),
                onPressed: () async {
                  MultiSourceResult result = runMutation({
                    "data": {
                      "name": _newRoomController.text
                    }
                  });

                  await result.networkResult;

                  setState(() { });
                  Navigator.pop(context);

                  _newRoomController.text = "";
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
          query rooms(\$filter: RoomsFilterInput!) {
            rooms (filter: \$filter) {
              id
              name
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

        List<Map> rooms;

        if (result.hasException) {
          body = Text(result.exception.toString());
        }
        else if (result.loading || result.data == null) {
          body = Center(child: CircularProgressIndicator());// TODO center
        }
        else {

          rooms = (result.data["rooms"] as List).map((room) => {
            "id": room["id"],
            "name": room["name"],
          }).toList();
          print('rooms length: ' + rooms.length.toString());

          if (rooms.length == 0) {
            body = Text("no room");
          }
          else {
            body = ListView.separated(
              itemCount: rooms.length,
              itemBuilder: (_, i) => ListTile(
                title: Text(rooms[i]["name"]),
                selected: _selectedRooms.contains(rooms[i]["id"]),
                onTap: () {
                  setState(() {
                    if (!_selectedRooms.contains(rooms[i]["id"]))
                      _selectedRooms.add(rooms[i]["id"]);
                    else
                      _selectedRooms.remove(rooms[i]["id"]);
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
                  updateQuery: (existing, newRooms) => ({
                    "rooms": newRooms["rooms"]
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
                onPressed: () => _showDialogNewRoom(context)
              ),
              IconButton(
                icon: Icon(Icons.check),
                onPressed: () {
                  widget.onSelect(_selectedRooms.map((id) => rooms.firstWhere((room) => room["id"] == id)["name"].toString()).toList());
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