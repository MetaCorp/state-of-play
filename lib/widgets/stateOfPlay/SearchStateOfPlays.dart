import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:flutter_tests/models/StateOfPlay.dart' as sop;
// import 'package:intl/intl.dart';// DateFormat

typedef SelectCallback = void Function(String);

class SearchStateOfPlays extends StatefulWidget {
  SearchStateOfPlays({ Key key, this.onSelect, this.out, this.sIn }) : super(key: key);

  final SelectCallback onSelect;
  final bool out;
  final bool sIn;

  @override
  _SearchStateOfPlaysState createState() => _SearchStateOfPlaysState();
}

// adb reverse tcp:9002 tcp:9002

class _SearchStateOfPlaysState extends State<SearchStateOfPlays> {

  TextEditingController _searchController = TextEditingController(text: "");

  @override
  void dispose() {
    _searchController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
        documentNode: gql('''
          query stateOfPlays(\$filter: StateOfPlaysFilterInput!) {
            stateOfPlays (filter: \$filter) {
              id
              property {
                id
                address
                postalCode
                city
              }
              owner {
                id
                firstName
                lastName
              }
              tenants {
                id
                firstName
                lastName
              }
            }
          }
        '''),
        variables: {
          "filter": {
            "search": _searchController.text,
            "out": widget.out == null || widget.out,
            "in": widget.out == null || widget.sIn,
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

          List<sop.StateOfPlay> stateOfPlays = (result.data["stateOfPlays"] as List).map((stateOfPlay) => sop.StateOfPlay.fromJSON(stateOfPlay)).toList();
          print('stateOfPlays length: ' + stateOfPlays.length.toString());

          if (stateOfPlays.length == 0) {
            body = Text("no stateOfplays");
          }
          else {
            body = Container(
              child: ListView.separated(
                padding: EdgeInsets.only(top: 8),
                itemCount: stateOfPlays.length,
                itemBuilder: (_, i) {
                  
                  String tenantsString = "";

                  for (var j = 0; j < stateOfPlays[i].tenants.length; j++) {
                    tenantsString += stateOfPlays[i].tenants[j].firstName + ' ' + stateOfPlays[i].tenants[j].lastName;
                    if (j < stateOfPlays[i].tenants.length - 1)
                      tenantsString += ', ';
                  }  

                  return ListTile(
                    title: Text("Propriétaire: " + stateOfPlays[i].owner.firstName + " " + stateOfPlays[i].owner.lastName),
                    subtitle: Text("Locataire" + (stateOfPlays[i].tenants.length > 1 ? "s" : "") + ": " + tenantsString),
                    onTap: () => widget.onSelect != null ? widget.onSelect(stateOfPlays[i].id) : Navigator.pushNamed(context, '/stateOfPlay', arguments: { "stateOfPlayId": stateOfPlays[i].id }),
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider();
                },
              ),
            );
          }

        }

        return Scaffold(
          appBar: AppBar(
            title: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Recherchez parmis les propriétaires, locataires et adresses...'
              ),
              onChanged: (value) {
                fetchMore(FetchMoreOptions(
                  variables: {
                    "filter": {
                      "search": value,
                      "out": widget.out || widget.out == null,
                      "in": !widget.out || widget.out == null,
                    }
                  },
                  updateQuery: (existing, newStateOfPlays) => ({
                    "stateOfPlays": newStateOfPlays["stateOfPlays"]
                  }),
                ));
              }
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () => null,
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