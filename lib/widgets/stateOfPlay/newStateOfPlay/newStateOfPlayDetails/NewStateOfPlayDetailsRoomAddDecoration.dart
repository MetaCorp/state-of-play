import 'package:flutter/material.dart';
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

  void _showDialogDelete(context, decoration, RunMutation runDeleteMutation) async {
    await showDialog(
      context: context,
      child: AlertDialog(
        content: Text("Supprimer '" + decoration["type"] + "' ?"),
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
                  "decorationId": decoration["id"],
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
      )
    );
  }

  @override
  void dispose() {
    _searchController.dispose();

    super.dispose();
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
                onPressed: () async {
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
        
        print('loading: ' + result.loading.toString());
        print('exception: ' + result.exception.toString());
        print('data: ' + result.data.toString());
        print('');

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
          print('decorations length: ' + decorations.length.toString());

          if (decorations.length == 0) {
            body = Text("no decoration");
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
                  // print('onCompleted: ' + resultData.hasException);
                },
              ),
              builder: (
                RunMutation runDeleteMutation,
                QueryResult mutationResult,
              ) {
                
                return ListView.separated(
                  padding: EdgeInsets.only(top: 8),
                  itemCount: decorations.length,
                  itemBuilder: (_, i) => Slidable(
                    actionPane: SlidableDrawerActionPane(),
                    actionExtentRatio: 0.25,
                    child: ListTile(
                      title: Text(decorations[i]["type"]),
                      selected: _selectedDecorations.contains(decorations[i]["id"]),
                      onTap: () {
                        setState(() {
                          if (!_selectedDecorations.contains(decorations[i]["id"]))
                            _selectedDecorations.add(decorations[i]["id"]);
                          else
                            _selectedDecorations.remove(decorations[i]["id"]);
                        });
                      },
                    ),
                    secondaryActions: [
                      IconSlideAction(
                        caption: 'Supprimer',
                        color: Colors.red,
                        icon: Icons.delete,
                        onTap: () => _showDialogDelete(context, decorations[i], runDeleteMutation),
                      )
                    ]
                  ),
                  separatorBuilder: (context, index) {
                    return Divider();
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
          body: body
        );
      }
    );
  }
}