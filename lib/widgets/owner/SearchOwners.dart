import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:flutter_tests/models/StateOfPlay.dart' as sop;
// import 'package:intl/intl.dart';// DateFormat

class SearchOwners extends StatefulWidget {
  SearchOwners({Key key}) : super(key: key);

  @override
  _SearchOwnersState createState() => _SearchOwnersState();
}

// adb reverse tcp:9002 tcp:9002

class _SearchOwnersState extends State<SearchOwners> {

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
          query owners(\$filter: OwnersFilterInput!) {
            owners (filter: \$filter) {
              id
              firstName
              lastName
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

          List<sop.Owner> owners = (result.data["owners"] as List).map((owner) => sop.Owner.fromJSON(owner)).toList();
          print('stateOfPlays length: ' + owners.length.toString());

          if (owners.length == 0) {
            body = Text("no owners");
          }
          else {
            body = ListView.separated(
              itemCount: owners.length,
              itemBuilder: (_, i) => ListTile(
                title: Text(owners[i].firstName + ' ' + owners[i].lastName),
                // subtitle: Text(DateFormat('dd/MM/yyyy').format(owners[i].date)) ,
                onTap: () => Navigator.pushNamed(context, '/owner', arguments: { "ownerId": owners[i].id }),
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
                  updateQuery: (existing, newOwners) => ({
                    "owners": newOwners["owners"]
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