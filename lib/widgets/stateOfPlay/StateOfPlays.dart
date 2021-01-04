

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

  bool _in = true;
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
              debugPrint('runDeleteMutation');

              MultiSourceResult mutationResult = runDeleteMutation({
                "data": {
                  "stateOfPlayId": stateOfPlay.id,
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

  void _showDialogFilter(context, fetchMore) async {
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
                    onChanged: (value) {
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
                onPressed: !_in && !_out ? null : () async {
                  fetchMore(FetchMoreOptions(
                    variables: {
                      "filter": {
                        "search": "",
                        "out":  _out == null || _out,
                        "in": _out == null || !_out,
                      }
                    },
                    updateQuery: (existing, newStateOfPlays) => ({
                      "stateOfPlays": newStateOfPlays["stateOfPlays"]
                    }),
                  ));
                  Navigator.pop(context);
                }
              )
            ],
          );
        }
      )
    );
  }

  Future<bool> _showDialogEdit(context) async {
    return await showDialog(
      context: context,
      child: AlertDialog(
        content: Text("En éditant cet état des lieux, vous perdrez les signatures des interlocuteurs."),
        actions: [
          new FlatButton(
            child: Text('ANNULER'),
            onPressed: () {
              Navigator.pop(context, false);
            }
          ),
          new FlatButton(
            child: Text('EDITER'),
            onPressed: () {
              Navigator.pop(context, true);
            }
          )
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {

    return Query(
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
            "out": _out == null || _out,
            "in": _out == null || !_out,
          }
        } 
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

        
        Widget appBar = AppBar(
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
              onPressed: () => _showDialogFilter(context, fetchMore),
            ),
            // IconButton(
            //   icon: Icon(Icons.add),
            //   onPressed: () => Navigator.pushNamed(context, '/new-state-of-play'),
            // ),
          ],
        );

        if (result.hasException) {
          return MyScaffold(
            appBar: appBar,
            body: Text(result.exception.toString())
          );
        }

        if (result.loading || result.data == null) {
          return MyScaffold(
            appBar: appBar,
            body: Center(child: CircularProgressIndicator())
          );
        }

        List<sop.StateOfPlay> stateOfPlays = (result.data["stateOfPlays"] as List).map((stateOfPlay) => sop.StateOfPlay.fromJSON(stateOfPlay)).toList();
        debugPrint('stateOfPlays length: ' + stateOfPlays.length.toString());

        if (stateOfPlays.length == 0) {
          return MyScaffold(
            appBar: appBar,
            body: Container(
              alignment: Alignment.center,
              child: Text(
                "Pas d'état des lieux pour le moment.",
                style: TextStyle(
                  color: Colors.grey[600]
                )
              )
            ),
          );
        }


        return MyScaffold(
          appBar: appBar,
          body: Mutation(
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
                // debugPrint('onCompleted: ' + resultData.hasException);
              },
            ),
            builder: (
              RunMutation runDeleteMutation,
              QueryResult mutationResult,
            ) {
              
              return StateOfPlaysList(
                stateOfPlays: stateOfPlays,
                onTap: (stateOfPlay) async {
                  bool ret = await _showDialogEdit(context); 
                  if (ret != null && ret)
                    Navigator.pushNamed(context, "/edit-state-of-play", arguments: { "stateOfPlayId": stateOfPlay.id });
                },
                onDelete: (stateOfPlay) => _showDialogDelete(context, stateOfPlay, runDeleteMutation),
              );
            }
          )
        );
      }
    );
  }
}
