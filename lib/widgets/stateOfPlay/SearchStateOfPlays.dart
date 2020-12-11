import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:flutter_tests/models/StateOfPlay.dart' as sop;
// import 'package:intl/intl.dart';// DateFormat

class SearchStateOfPlays extends StatefulWidget {
  SearchStateOfPlays({Key key}) : super(key: key);

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

          List<sop.StateOfPlay> stateOfPlays = (result.data["stateOfPlays"] as List).map((stateOfPlay) => sop.StateOfPlay.fromJSON(stateOfPlay)).toList();
          print('stateOfPlays length: ' + stateOfPlays.length.toString());

          if (stateOfPlays.length == 0) {
            body = Text("no stateOfplays");
          }
          else {
            body = ListView.separated(
              itemCount: stateOfPlays.length,
              itemBuilder: (_, i) => ListTile(
                title: Text(stateOfPlays[i].property.address + ', ' + stateOfPlays[i].property.postalCode + ' ' + stateOfPlays[i].property.city),
                // subtitle: Text(DateFormat('dd/MM/yyyy').format(stateOfPlays[i].date)) ,
                onTap: () => Navigator.pushNamed(context, '/stateOfPlay', arguments: { "stateOfPlayId": stateOfPlays[i].id }),
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