import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:flutter_tests/models/StateOfPlay.dart' as sop;
// import 'package:intl/intl.dart';// DateFormat

typedef SelectCallback = void Function(sop.Property);

class NewStateOfPlayInterlocutorsSearchProperties extends StatefulWidget {
  NewStateOfPlayInterlocutorsSearchProperties({ Key key, this.onSelect }) : super(key: key);

  final SelectCallback onSelect;

  @override
  _NewStateOfPlayInterlocutorsSearchPropertiesState createState() => _NewStateOfPlayInterlocutorsSearchPropertiesState();
}

// adb reverse tcp:9002 tcp:9002

class _NewStateOfPlayInterlocutorsSearchPropertiesState extends State<NewStateOfPlayInterlocutorsSearchProperties> {

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
          query properties(\$filter: PropertiesFilterInput!) {
            properties (filter: \$filter) {
              id
              address
              postalCode
              city
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

          List<sop.Property> properties = (result.data["properties"] as List).map((property) => sop.Property.fromJSON(property)).toList();
          print('properties length: ' + properties.length.toString());

          if (properties.length == 0) {
            body = Text("no properties");
          }
          else {
            body = ListView.separated(
              itemCount: properties.length,
              itemBuilder: (_, i) => ListTile(
                title: Text(properties[i].address + ', ' + properties[i].postalCode + ' ' + properties[i].city),
                // subtitle: Text(DateFormat('dd/MM/yyyy').format(properties[i].date)) ,
                onTap: () {
                  Navigator.pop(context);
                  widget.onSelect(properties[i]);
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
                  updateQuery: (existing, newProperties) => ({
                    "properties": newProperties["properties"]
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