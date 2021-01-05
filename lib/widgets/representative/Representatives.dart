import 'package:flutter/material.dart';
import 'package:flutter_tests/widgets/representative/RepresentativesList.dart';
import 'package:flutter_tests/widgets/utilities/FlatButtonLoading.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:flutter_tests/models/StateOfPlay.dart' as sop;
// import 'package:intl/intl.dart';// DateFormat

import 'package:flutter_tests/widgets/utilities/MyScaffold.dart';

class Representatives extends StatefulWidget {
  Representatives({Key key}) : super(key: key);

  @override
  _OwnersState createState() => _OwnersState();
}

// adb reverse tcp:9002 tcp:9002

class _OwnersState extends State<Representatives> {

  bool _deleteLoading = false;
  
  void _showDialogDelete(context, sop.Representative representative, RunMutation runDeleteMutation, Refetch refetch) async {
    await showDialog(
      context: context,
      child: StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Supprimer '" + representative.firstName + ' ' + representative.lastName + "' ?"),
                representative.stateOfPlays.length > 0 ? Text("Ceci entrainera la suppression de '" + representative.stateOfPlays.length.toString() + "' état" + (representative.stateOfPlays.length > 1 ? "s" : "") + " des lieux.") : Container(),
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
                      "representativeId": representative.id,
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
                      if (networkResult.data["deleteRepresentative"] == null) {
                        // TODO: show error
                      }
                      else if (networkResult.data["deleteRepresentative"] != null) {
                        Navigator.pop(context);
                        setState(() { });
                        // Navigator.popAndPushNamed(context, '/representatives');// To refresh
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
        title: Text('Mandataires'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => Navigator.pushNamed(context, '/search-representatives'),
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => Navigator.pushNamed(context, '/new-representative'),
          ),
        ],
      ),
      body: 
        Query(
          options: QueryOptions(
            documentNode: gql('''
            query representatives {
              representatives {
                id
                firstName
                lastName
                stateOfPlays {
                  id
                }
              }
            }
            ''')
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

            List<sop.Representative> representatives = (result.data["representatives"] as List).map((representative) => sop.Representative.fromJSON(representative)).toList();

            debugPrint('parsed data: ' + representatives.toString());

            if (representatives.length == 0) {
              return Container(
                alignment: Alignment.center,
                child: Text(
                  "Pas de mandataire pour le moment.",
                  style: TextStyle(
                    color: Colors.grey[600]
                  )
                )
              );
            }

            return Mutation(
              options: MutationOptions(
                documentNode: gql('''
                  mutation deleteRepresentative(\$data: DeleteRepresentativeInput!) {
                    deleteRepresentative(data: \$data)
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
                
                return RepresentativesList(
                  representatives: representatives,
                  onTap: (representative) => Navigator.pushNamed(context, '/edit-representative', arguments: { "representativeId": representative.id }),
                  onDelete: (representative) => _showDialogDelete(context, representative, runDeleteMutation, refetch)
                );
              }
            );
          }
        )
    );
  }
}