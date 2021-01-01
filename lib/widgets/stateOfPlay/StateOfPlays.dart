

import 'package:flutter/material.dart';
import 'package:flutter_tests/widgets/stateOfPlay/StateOfPlaysList.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:flutter_tests/models/StateOfPlay.dart' as sop;

import 'package:flutter_tests/widgets/utilities/MyScaffold.dart';

import 'package:feature_discovery/feature_discovery.dart';


class StateOfPlays extends StatefulWidget {
  StateOfPlays({Key key}) : super(key: key);

  @override
  _StateOfPlaysState createState() => _StateOfPlaysState();
}

// adb reverse tcp:9002 tcp:9002

class _StateOfPlaysState extends State<StateOfPlays> {

  bool _in = false;
  bool _out = true;

  @override
  void initState() {
    super.initState();
  }

  void _showDialogDelete(context, sop.StateOfPlay stateOfPlay, RunMutation runDeleteMutation) async {
    await showDialog(
      context: context,
      child: AlertDialog(
        content: Text("Supprimer '" + stateOfPlay.property.address + ', ' + stateOfPlay.property.postalCode + ' ' + stateOfPlay.property.city + "' ?"),
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
              print('runDeleteMutation');

              MultiSourceResult mutationResult = runDeleteMutation({
                "data": {
                  "stateOfPlayId": stateOfPlay.id,
                }
              });
              QueryResult networkResult = await mutationResult.networkResult;

              if (networkResult.hasException) {
                print('networkResult.hasException: ' + networkResult.hasException.toString());
                if (networkResult.exception.clientException != null)
                  print('networkResult.exception.clientException: ' + networkResult.exception.clientException.toString());
                else
                  print('networkResult.exception.graphqlErrors[0]: ' + networkResult.exception.graphqlErrors[0].toString());
              }
              else {
                print('queryResult data: ' + networkResult.data.toString());
                if (networkResult.data != null) {
                  if (networkResult.data["deleteStateOfPlay"] == null) {
                    // TODO: show error
                  }
                  else if (networkResult.data["deleteStateOfPlay"] != null) {
                    Navigator.pop(context);
                    setState(() { });
                    // Navigator.popAndPushNamed(context, '/tenants');// To refresh
                  }
                }
              }
            }
          )
        ],
      )
    );
  }

  void _showDialogFilter(context) async {
    await showDialog(
      context: context,
      child: StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            content: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Filtres"),
                  CheckboxListTile(
                    title: Text("Entrée"),
                    value: _in,
                    onChanged: (value) {// TODO: doesnt work -> https://stackoverflow.com/questions/51578824/flutter-checkbox-doesnt-work
                      print('onChanged: ' + value.toString());
                      setState(() {
                        _in = value; 
                      }); 
                    },
                  ),
                  CheckboxListTile(
                    title: Text("Sortie"),
                    value: _out,
                    onChanged: (value) { 
                      setState(() {
                        _out = value; 
                      }); 
                    },
                  )
                ],
              ),
            ),
            actions: [
              FlatButton(
                child: Text('ANNULER'),
                onPressed: () async {
                  Navigator.pop(context);
                }
              ),
              FlatButton(
                child: Text('APPLIQUER'),
                onPressed: () async {
                  Navigator.pop(context);
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
        title: Text('États des lieux'),
        actions: [
          DescribedFeatureOverlay(
            featureId: 'search_sop',
            tapTarget: Icon(Icons.search),
            title: Text('Recherche'),
            description: Text('Accédez à la recherche'),
            child: IconButton(
              icon: Icon(Icons.search),
              onPressed: () => Navigator.pushNamed(context, '/search-state-of-plays'),
            ),
          ),
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () => _showDialogFilter(context),
          ),
          // IconButton(
          //   icon: Icon(Icons.add),
          //   onPressed: () => Navigator.pushNamed(context, '/new-state-of-play'),
          // ),
        ],
      ),
      body: 
        Query(
          options: QueryOptions(
            documentNode: gql('''
            query stateOfPlays(\$filter: StateOfPlaysFilterInput!) {
              stateOfPlays(filter: \$filter) {
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
                pdf
              }
            }
            '''),
            variables: {
              "filter": {
                "search": "",
                "out": true,
                "in": true
              }
            } 
          ),
          builder: (
            QueryResult result, {
            Refetch refetch,
            FetchMore fetchMore,
          }) {
            print('loading: ' + result.loading.toString());
            print('exception: ' + result.exception.toString());
            print('data: ' + result.data.toString());
            print('');

            if (result.hasException) {
              return Text(result.exception.toString());
            }

            if (result.loading || result.data == null) {
              return Center(child: CircularProgressIndicator());
            }

            List<sop.StateOfPlay> stateOfPlays = (result.data["stateOfPlays"] as List).map((stateOfPlay) => sop.StateOfPlay.fromJSON(stateOfPlay)).toList();
            print('stateOfPlays length: ' + stateOfPlays.length.toString());

            if (stateOfPlays.length == 0) {
              return Container(
                alignment: Alignment.center,
                child: Text(
                  "Pas d'état des lieux pour le moment.",
                  style: TextStyle(
                    color: Colors.grey[600]
                  )
                )
              );
            }


            return Mutation(
              options: MutationOptions(
                documentNode: gql('''
                  mutation deleteStateOfPlay(\$data: DeleteStateOfPlayInput!) {
                    deleteStateOfPlay(data: \$data)
                  }
                '''), // this is the mutation string you just created
                // you can update the cache based on results
                update: (Cache cache, QueryResult result) {
                  return cache;
                },
                // or do something with the result.data on completion
                onCompleted: (dynamic resultData) {
                  // print('onCompleted: ' + resultData.hasException);
                },
              ),
              builder: (
                RunMutation runDeleteMutation,
                QueryResult mutationResult,
              ) {
                
                return StateOfPlaysList(
                  stateOfPlays: stateOfPlays,
                  onTap: (stateOfPlay) => Navigator.pushNamed(context, "/edit-state-of-play", arguments: { "stateOfPlayId": stateOfPlay.id }),
                  onDelete: (stateOfPlay) => _showDialogDelete(context, stateOfPlay, runDeleteMutation),
                );
              }
            );
          }
        )
    );
  }
}
