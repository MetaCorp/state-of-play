import 'package:flutter/material.dart';
import 'package:flutter_tests/widgets/property/PropertiesList.dart';
import 'package:flutter_tests/widgets/utilities/FlatButtonLoading.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:flutter_tests/models/StateOfPlay.dart' as sop;
// import 'package:intl/intl.dart';// DateFormat

import 'package:flutter_tests/widgets/utilities/MyScaffold.dart';

class Properties extends StatefulWidget {
  Properties({Key key}) : super(key: key);

  @override
  _PropertiesState createState() => _PropertiesState();
}

// adb reverse tcp:9002 tcp:9002

class _PropertiesState extends State<Properties> {

  bool _deleteLoading = false;

  void _showDialogDelete(context, sop.Property property, RunMutation runDeleteMutation, Refetch refetch) async {
    await showDialog(
      context: context,
      child: StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Supprimer '" +property.address + ', ' + property.postalCode + ' ' + property.city + "' ?"),
                property.stateOfPlays.length > 0 ? Text("Ceci entrainera la suppression de '" + property.stateOfPlays.length.toString() + "' état" + (property.stateOfPlays.length > 1 ? "s" : "") + " des lieux.") : Container(),
              ]
            ),
            actions: [
              FlatButton(
                child: Text('ANNULER'),
                onPressed: () {
                  Navigator.pop(context);
                }
              ),
              FlatButtonLoading(
                child: Text('SUPPRIMER'),
                loading: _deleteLoading,
                onPressed: () async {
                  debugPrint('runDeleteMutation');

                  setState(() { _deleteLoading = true; });
                  MultiSourceResult mutationResult = runDeleteMutation({
                    "data": {
                      "propertyId": property.id,
                    }
                  });
                  QueryResult networkResult = await mutationResult.networkResult;
                  setState(() { _deleteLoading = false; });
                  refetch();

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
          );
        }
      )
    );
  }


  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      appBar: AppBar(
        title: Text('Propriétés'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => Navigator.pushNamed(context, '/search-properties'),
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => Navigator.pushNamed(context, '/new-property'),
          ),
        ],
      ),
      body: 
        Query(
          options: QueryOptions(
            documentNode: gql('''
            query properties {
              properties {
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
            fetchPolicy: FetchPolicy.networkOnly,
          ),
          builder: (
            QueryResult result, {
            Refetch refetch,
            FetchMore fetchMore,
          }) {
            debugPrint('loading: ' + result.loading.toString());
            debugPrint('exception: ' + result.exception.toString());
            debugPrint('data: ' + result.data.toString());
            debugPrint('');

            if (result.hasException) {
              return Text(result.exception.toString());
            }

            if (result.loading || result.data == null) {
              return Center(child: CircularProgressIndicator());
            }

            List<sop.Property> properties = (result.data["properties"] as List).map((property) => sop.Property.fromJSON(property)).toList();

            debugPrint('parsed data: ' + properties.toString());

            if (properties.length == 0) {
              return Container(
                alignment: Alignment.center,
                child: Text(
                  "Pas de propriété pour le moment.",
                  style: TextStyle(
                    color: Colors.grey[600]
                  )
                )
              );
            }

            return Mutation(
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
                  onTap: (property) => Navigator.pushNamed(context, '/edit-property', arguments: { "propertyId": property.id }),
                  onDelete: (property) => _showDialogDelete(context, property, runDeleteMutation, refetch)
                );
              }
            );
          }
        )
    );
  }
}