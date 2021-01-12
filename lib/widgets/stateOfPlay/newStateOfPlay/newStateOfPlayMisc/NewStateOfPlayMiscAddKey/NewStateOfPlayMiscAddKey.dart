import 'package:flutter/material.dart';
import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/newStateOfPlayMisc/NewStateOfPlayMiscAddKey/NewStateOfPlayMiscAddKeyContent.dart';
import 'package:flutter_tests/widgets/utilities/FlatButtonLoading.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

typedef SelectCallback = void Function(List<String>);

class NewStateOfPlayMiscAddKey extends StatefulWidget {
  NewStateOfPlayMiscAddKey({ Key key, this.onSelect }) : super(key: key);

  final SelectCallback onSelect;

  @override
  _NewStateOfPlayMiscAddKeyState createState() => _NewStateOfPlayMiscAddKeyState();
}

// adb reverse tcp:9002 tcp:9002

class _NewStateOfPlayMiscAddKeyState extends State<NewStateOfPlayMiscAddKey> {

  TextEditingController _searchController = TextEditingController(text: "");
  TextEditingController _newKeyController = TextEditingController(text: "");

  List<Map> _selectedKeys = [];

  bool _deleteLoading = false;

  void _showDialogDelete(context, key, RunMutation runDeleteMutation, Refetch refetch) async {
    await showDialog(
      context: context,
      child: StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            content: Text("Supprimer '" + key["type"] + "' ?"),
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
                      "keyId": key["id"],
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
                      if (networkResult.data["deleteKey"] == null) {
                        // TODO: show error
                      }
                      else if (networkResult.data["deleteKey"] != null) {
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
        "type": _newKeyController.text
      }
    });

    await result.networkResult;

    setState(() { });
    Navigator.pop(context);

    _newKeyController.text = "";
  }

  void _showDialogNewKey (context) async {
    await showDialog(
      context: context,
      child: Mutation(
        options: MutationOptions(
          documentNode: gql('''
            mutation createKey(\$data: CreateKeyInput!) {
              createKey(data: \$data) {
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
              controller: _newKeyController,
              autofocus: true,
              decoration: InputDecoration(
                labelText: "Entrez un nom de clé"
              ),
              textCapitalization: TextCapitalization.sentences,
              onSubmitted: (value) => _onAdd(runMutation),
            ),
            actions: [
              new FlatButton(
                child: Text('ANNULER'),
                onPressed: () {
                  _newKeyController.text = "";
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
          query keys(\$filter: KeysFilterInput!) {
            keys (filter: \$filter) {
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

        List<Map> keys;

        if (result.hasException) {
          body = Text(result.exception.toString());
        }
        else if (result.loading || result.data == null) {
          body = Center(child: CircularProgressIndicator());
        }
        else {

          keys = (result.data["keys"] as List).map((key) => {
            "id": key["id"],
            "type": key["type"],
          }).toList();
          debugPrint('keys length: ' + keys.length.toString());

          if (keys.length == 0) {
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
                  mutation deleteKey(\$data: DeleteKeyInput!) {
                    deleteKey(data: \$data)
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
                
                return NewStateOfPlayMiscAddKeyContent(
                  keys: keys,
                  selectedKeys: _selectedKeys,
                  onDelete: (key) => _showDialogDelete(context, key, runDeleteMutation, refetch),
                  onSelect: (key) => {
                    setState(() {
                       if (!_selectedKeys.any((key2) => key["id"] == key2["id"]))
                        _selectedKeys.add(key);
                      else
                        _selectedKeys.remove(key);
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
              autofocus: true,
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Entrez votre recherche'
              ),
              onChanged: (value) {
                fetchMore(FetchMoreOptions(
                  variables: { "filter": { "search": value } },
                  updateQuery: (existing, newKeys) => ({
                    "keys": newKeys["keys"]
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
                onPressed: () => _showDialogNewKey(context)
              ),
              IconButton(
                icon: Icon(Icons.check),
                onPressed: () {
                  Navigator.pop(context);
                  widget.onSelect(_selectedKeys.map((key) => key["type"].toString()).toList());
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