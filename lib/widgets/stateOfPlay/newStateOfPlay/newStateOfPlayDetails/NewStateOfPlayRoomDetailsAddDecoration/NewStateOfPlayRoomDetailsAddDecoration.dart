import 'package:flutter/material.dart';
import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/newStateOfPlayDetails/NewStateOfPlayRoomDetailsAddDecoration/NewStateOfPlayRoomDetailsAddDecorationContent.dart';
import 'package:flutter_tests/widgets/utilities/FlatButtonLoading.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

typedef SelectCallback = void Function(List<String>);

class NewStateOfPlayDetailsRoomAddDecoration extends StatefulWidget {
  NewStateOfPlayDetailsRoomAddDecoration({ Key key, this.onSelect }) : super(key: key);

  final SelectCallback onSelect;

  @override
  _NewStateOfPlayDetailsRoomAddDecorationState createState() => _NewStateOfPlayDetailsRoomAddDecorationState();
}

// adb reverse tcp:9002 tcp:9002

class _NewStateOfPlayDetailsRoomAddDecorationState extends State<NewStateOfPlayDetailsRoomAddDecoration> {

  TextEditingController _searchController = TextEditingController(text: "");
  TextEditingController _newDecorationController = TextEditingController(text: "");

  List<String> _selectedDecorations = []; 

  bool _deleteLoading = false;

  void _showDialogDelete(context, decoration, RunMutation runDeleteMutation, Refetch refetch) async {
    await showDialog(
      context: context,
      child: StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            content: Text("Supprimer '" + decoration["type"] + "' ?"),
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
                      "decorationId": decoration["id"],
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
                      if (networkResult.data["deleteDecoration"] == null) {
                        // TODO: show error
                      }
                      else if (networkResult.data["deleteDecoration"] != null) {
                        Navigator.pop(context);
                        setState(() { });
                        // Navigator.popAndPushNamed(context, '/tenants');// To refresh
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
  void dispose() {
    _searchController.dispose();

    super.dispose();
  }

  _onAdd(runMutation) async {
    MultiSourceResult result = runMutation({
      "data": {
        "type": _newDecorationController.text
      }
    });

    await result.networkResult;

    setState(() { });
    Navigator.pop(context);

    _newDecorationController.text = "";
  }

  void _showDialogNewDecoration (context) async {
    await showDialog(
      context: context,
      child: Mutation(
        options: MutationOptions(
          documentNode: gql('''
            mutation createDecoration(\$data: CreateDecorationInput!) {
              createDecoration(data: \$data) {
                id
                type
              }
            }
          '''),
          update: (Cache cache, QueryResult result) {
            return cache;
          },
          onCompleted: (dynamic resultData) {
          },
        ),
        builder: (
          RunMutation runMutation,
          QueryResult result,
        ) {
            
          return AlertDialog(
            content: TextField(
              controller: _newDecorationController,
              autofocus: true,
              decoration: InputDecoration(
                labelText: "Entrez un nom de décoration"
              ),
              onSubmitted: (value) => _onAdd(runMutation),
            ),
            actions: [
              new FlatButton(
                child: Text('ANNULER'),
                onPressed: () {
                  _newDecorationController.text = "";
                  Navigator.pop(context);
                }
              ),
              new FlatButton(
                child: Text('AJOUTER'),
                onPressed: () => _onAdd(runMutation)
              )
            ],
          );
        }
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
        documentNode: gql('''
          query decorations(\$filter: DecorationsFilterInput!) {
            decorations (filter: \$filter) {
              id
              type
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

        List<Map> decorations;

        if (result.hasException) {
          body = Text(result.exception.toString());
        }
        else if (result.loading || result.data == null) {
          body = Center(child: CircularProgressIndicator());
        }
        else {
          decorations = (result.data["decorations"] as List).map((decoration) => {
            "id": decoration["id"],
            "type": decoration["type"],
          }).toList();
          debugPrint('decorations length: ' + decorations.length.toString());

          if (decorations.length == 0) {
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
                  mutation deleteDecoration(\$data: DeleteDecorationInput!) {
                    deleteDecoration(data: \$data)
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
                
                return NewStateOfPlayDetailsRoomAddDecorationContent(
                  decorations: decorations,
                  selectedDecorations: _selectedDecorations,
                  onDelete: (decoration) => _showDialogDelete(context, decoration, runDeleteMutation, refetch),
                  onSelect: (decorationId) => {
                    setState(() {
                      if (!_selectedDecorations.contains(decorationId))
                        _selectedDecorations.add(decorationId);
                      else
                        _selectedDecorations.remove(decorationId);
                    })
                  },
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
                  updateQuery: (existing, newDecorations) => ({
                    "decorations": newDecorations["decorations"]
                  }),
                ));
              }
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () => null,
              ),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () => _showDialogNewDecoration(context)
              ),
              IconButton(
                icon: Icon(Icons.check),
                onPressed: () {
                  Navigator.pop(context);
                  widget.onSelect(_selectedDecorations.map((id) => decorations.firstWhere((decoration) => decoration["id"] == id)["type"].toString()).toList());
                }
              ),
            ],
            backgroundColor: Colors.grey,
          ),
          body: body,
        );
      }
    );
  }
}