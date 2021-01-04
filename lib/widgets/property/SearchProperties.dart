import 'package:flutter/material.dart';
import 'package:flutter_tests/widgets/property/PropertiesList.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:flutter_tests/models/StateOfPlay.dart' as sop;
// import 'package:intl/intl.dart';// DateFormat

typedef SelectCallback = Function(sop.Property);

class SearchProperties extends StatefulWidget {
  SearchProperties({ Key key, this.onSelect }) : super(key: key);

  SelectCallback onSelect;

  @override
  _SearchPropertiesState createState() => _SearchPropertiesState();
}

// adb reverse tcp:9002 tcp:9002

class _SearchPropertiesState extends State<SearchProperties> {

  TextEditingController _searchController = TextEditingController(text: "");

  void _showDialogDelete(context, sop.Property property, RunMutation runDeleteMutation) async {
    await showDialog(
      context: context,
      child: AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Supprimer '" +property.address + ', ' + property.postalCode + ' ' + property.city + "' ?"),
            property.stateOfPlays.length > 0 ? Text("Ceci entrainera la suppression de '" + property.stateOfPlays.length.toString() + "' état" + (property.stateOfPlays.length > 1 ? "s" : "") + " des lieux.") : Container(),
          ]
        ),
        actions: [
          new FlatButton(
            child: Text('ANNULER'),
            onPressed: () {
              Navigator.pop(context);
            }
          ),
          new FlatButton(
            child: Text('SUPPRIMER'),
            onPressed: () async {
              debugPrint('runDeleteMutation');

              MultiSourceResult mutationResult = runDeleteMutation({
                "data": {
                  "propertyId": property.id,
                }
              });
              QueryResult networkResult = await mutationResult.networkResult;

              if (networkResult.hasException) {
                debugPrint('networkResult.hasException: ' + networkResult.hasException.toString());
                if (networkResult.exception.clientException != null)
                  debugPrint('networkResult.exception.clientException: ' + networkResult.exception.clientException.toString());
                else
                  debugPrint('networkResult.exception.graphqlErrors[0]: ' + networkResult.exception.graphqlErrors[0].toString());
              }
              else {
                debugPrint('queryResult data: ' + networkResult.data.toString());
                if (networkResult.data != null) {
                  if (networkResult.data["deleteProperty"] == null) {
                    // TODO: show error
                  }
                  else if (networkResult.data["deleteProperty"] != null) {
                    Navigator.pop(context);
                    setState(() { });
                    // Navigator.popAndPushNamed(context, '/propertys');// To refresh
                  }
                }
              }
            }
          )
        ],
      )
    );
  }

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
              stateOfPlays {
                id
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
        
        debugPrint('loading: ' + result.loading.toString());
        debugPrint('exception: ' + result.exception.toString());
        debugPrint('data: ' + result.data.toString());
        debugPrint('');

        if (result.hasException) {
          body = Text(result.exception.toString());
        }
        else if (result.loading || result.data == null) {
          body = Center(child: CircularProgressIndicator());
        }
        else {

          List<sop.Property> properties = (result.data["properties"] as List).map((property) => sop.Property.fromJSON(property)).toList();
          debugPrint('stateOfPlays length: ' + properties.length.toString());

          if (properties.length == 0) {
            body = Container(
              alignment: Alignment.center,
              child: Text(
                "Aucun résultat.",
                style: TextStyle(
                  color: Colors.grey[600]
                )
              )
            );
          }
          else {
            body = Mutation(
              options: MutationOptions(
                documentNode: gql('''
                  mutation deleteProperty(\$data: DeletePropertyInput!) {
                    deleteProperty(data: \$data)
                  }
                '''), // this is the mutation string you just created
                // you can update the cache based on results
                update: (Cache cache, QueryResult result) {
                  return cache;
                },
                // or do something with the result.data on completion
                onCompleted: (dynamic resultData) {
                  // debugPrint('onCompleted: ' + resultData.hasException);
                },
              ),
              builder: (
                RunMutation runDeleteMutation,
                QueryResult mutationResult,
              ) {
                
                return PropertiesList(
                  properties: properties,
                  onTap: (property) => widget.onSelect != null ? widget.onSelect(property) : Navigator.pushNamed(context, '/edit-property', arguments: { "propertyId": property.id }),
                  onDelete: (property) => _showDialogDelete(context, property, runDeleteMutation)
                );
              }
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