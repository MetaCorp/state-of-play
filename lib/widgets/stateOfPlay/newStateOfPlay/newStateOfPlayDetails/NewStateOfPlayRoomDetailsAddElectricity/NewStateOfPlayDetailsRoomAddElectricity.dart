import 'package:flutter/material.dart';
import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/newStateOfPlayDetails/NewStateOfPlayRoomDetailsAddElectricity/NewStateOfPlayDetailsRoomAddElectricityContent.dart';
import 'package:flutter_tests/widgets/utilities/FlatButtonLoading.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

typedef SelectCallback = void Function(List<String>);

class NewStateOfPlayDetailsRoomAddElectricity extends StatefulWidget {
  NewStateOfPlayDetailsRoomAddElectricity({ Key key, this.onSelect }) : super(key: key);

  final SelectCallback onSelect;

  @override
  _NewStateOfPlayDetailsRoomAddElectricityState createState() => _NewStateOfPlayDetailsRoomAddElectricityState();
}

// adb reverse tcp:9002 tcp:9002

class _NewStateOfPlayDetailsRoomAddElectricityState extends State<NewStateOfPlayDetailsRoomAddElectricity> {

  TextEditingController _searchController = TextEditingController(text: "");
  TextEditingController _newElectricityController = TextEditingController(text: "");

  List<String> _selectedElectricities = [];

  bool _deleteLoading = false;

  void _showDialogDelete(context, electricity, RunMutation runDeleteMutation, Refetch refetch) async {
    await showDialog(
      context: context,
      child: StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            content: Text("Supprimer '" + electricity["type"] + "' ?"),
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
                      "electricityId": electricity["id"],
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
                      if (networkResult.data["deleteElectricity"] == null) {
                        // TODO: show error
                      }
                      else if (networkResult.data["deleteElectricity"] != null) {
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
        "type": _newElectricityController.text
      }
    });

    await result.networkResult;

    setState(() { });
    Navigator.pop(context);

    _newElectricityController.text = "";
  }

  void _showDialogNewElectricity (context) async {
    await showDialog(
      context: context,
      child: Mutation(
        options: MutationOptions(
          documentNode: gql('''
            mutation createElectricity(\$data: CreateElectricityInput!) {
              createElectricity(data: \$data) {
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
              controller: _newElectricityController,
              autofocus: true,
              decoration: InputDecoration(
                labelText: "Entrez un nom d'électricité/chauffage"
              ),
              textCapitalization: TextCapitalization.sentences,
              onSubmitted: (value) => _onAdd(runMutation),
            ),
            actions: [
              new FlatButton(
                child: Text('ANNULER'),
                onPressed: () {
                  _newElectricityController.text = "";
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
          query electricities(\$filter: ElectricitiesFilterInput!) {
            electricities (filter: \$filter) {
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

        List<Map> electricities;

        if (result.hasException) {
          body = Text(result.exception.toString());
        }
        else if (result.loading || result.data == null) {
          body = Center(child: CircularProgressIndicator());
        }
        else {

          electricities = (result.data["electricities"] as List).map((electricity) => {
            "id": electricity["id"],
            "type": electricity["type"],
          }).toList();
          debugPrint('electricities length: ' + electricities.length.toString());

          if (electricities.length == 0) {
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
                  mutation deleteElectricity(\$data: DeleteElectricityInput!) {
                    deleteElectricity(data: \$data)
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
                
                return NewStateOfPlayDetailsRoomAddElectricityContent(
                  electricities: electricities,
                  selectedElectricities: _selectedElectricities,
                  onDelete: (electricity) => _showDialogDelete(context, electricity, runDeleteMutation, refetch),
                  onSelect: (electricityId) => {
                    setState(() {
                      if (!_selectedElectricities.contains(electricityId))
                        _selectedElectricities.add(electricityId);
                      else
                        _selectedElectricities.remove(electricityId);
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
                  updateQuery: (existing, newElectricitys) => ({
                    "electricities": newElectricitys["electricities"]
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
                onPressed: () => _showDialogNewElectricity(context)
              ),
              IconButton(
                icon: Icon(Icons.check),
                onPressed: () {
                  Navigator.pop(context);
                  widget.onSelect(_selectedElectricities.map((id) => electricities.firstWhere((electrity) => electrity["id"] == id)["type"].toString()).toList());
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