import 'package:flutter/material.dart';
import 'package:flutter_tests/widgets/stateOfPlay/StateOfPlaysList.dart';
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

  bool _out = true;
  bool _in = true;

  
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
                        "search": _searchController.text,
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
              pdf
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
                  onTap: (stateOfPlay) async {
                    if (widget.onSelect != null) {
                      widget.onSelect(stateOfPlay.id);
                    }
                    else {
                      bool ret = await _showDialogEdit(context); 
                      if (ret != null && ret)
                        Navigator.pushNamed(context, "/edit-state-of-play", arguments: { "stateOfPlayId": stateOfPlay.id });
                    }
                  },
                  onDelete: (stateOfPlay) => _showDialogDelete(context, stateOfPlay, runDeleteMutation),
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
                hintText: 'Recherchez parmis les propriétaires, locataires et adresses...'
              ),
              onChanged: (value) {
                fetchMore(FetchMoreOptions(
                  variables: {
                    "filter": {
                      "search": value,
                      "out":  widget.out == null || widget.out,
                      "in": widget.out == null || !widget.out,
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
              widget.out == null ? IconButton(
                icon: Icon(Icons.filter_list),
                onPressed: () => _showDialogFilter(context, fetchMore),
              ) : Container(),
            ],
            backgroundColor: Colors.grey,
          ),
          body: body
        );
      }
    );
  }
}