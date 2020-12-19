import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:flutter_tests/models/StateOfPlay.dart' as sop;
// import 'package:intl/intl.dart';// DateFormat

typedef SelectCallback = void Function(sop.Representative);

class NewStateOfPlayInterlocutorsSearchRepresentatives extends StatefulWidget {
  NewStateOfPlayInterlocutorsSearchRepresentatives({ Key key, this.onSelect }) : super(key: key);

  final SelectCallback onSelect;

  @override
  _NewStateOfPlayInterlocutorsSearchRepresentativesState createState() => _NewStateOfPlayInterlocutorsSearchRepresentativesState();
}

// adb reverse tcp:9002 tcp:9002

class _NewStateOfPlayInterlocutorsSearchRepresentativesState extends State<NewStateOfPlayInterlocutorsSearchRepresentatives> {

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
          query representatives(\$filter: RepresentativesFilterInput!) {
            representatives (filter: \$filter) {
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

          List<sop.Representative> representatives = (result.data["representatives"] as List).map((representative) => sop.Representative.fromJSON(representative)).toList();
          print('representatives length: ' + representatives.length.toString());

          if (representatives.length == 0) {
            body = Text("no representatives");
          }
          else {
            body = ListView.separated(
              itemCount: representatives.length,
              itemBuilder: (_, i) => ListTile(
                title: Text(representatives[i].firstName + ' ' + representatives[i].lastName),
                // subtitle: Text(DateFormat('dd/MM/yyyy').format(representatives[i].date)) ,
                onTap: () {
                  Navigator.pop(context);
                  widget.onSelect(representatives[i]);
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
                  updateQuery: (existing, newRepresentatives) => ({
                    "representatives": newRepresentatives["representatives"]
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