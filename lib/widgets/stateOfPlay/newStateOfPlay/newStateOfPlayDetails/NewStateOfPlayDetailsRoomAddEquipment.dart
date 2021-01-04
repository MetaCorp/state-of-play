import 'package:flutter/material.dart';
import 'package:flutter_tests/widgets/utilities/FlatButtonLoading.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

typedef SelectCallback = void Function(List<String>);

class NewStateOfPlayDetailsRoomAddEquipment extends StatefulWidget {
  NewStateOfPlayDetailsRoomAddEquipment({ Key key, this.onSelect }) : super(key: key);

  final SelectCallback onSelect;

  @override
  _NewStateOfPlayDetailsRoomAddEquipmentState createState() => _NewStateOfPlayDetailsRoomAddEquipmentState();
}

// adb reverse tcp:9002 tcp:9002

class _NewStateOfPlayDetailsRoomAddEquipmentState extends State<NewStateOfPlayDetailsRoomAddEquipment> {

  TextEditingController _searchController = TextEditingController(text: "");
  TextEditingController _newEquipmentController = TextEditingController(text: "");

  List<String> _selectedEquipments = [];

  bool _deleteLoading = false;

  void _showDialogDelete(context, equipment, RunMutation runDeleteMutation) async {
    await showDialog(
      context: context,
      child: StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            content: Text("Supprimer '" + equipment["type"] + "' ?"),
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
                      "equipmentId": equipment["id"],
                    }
                  });
                  QueryResult networkResult = await mutationResult.networkResult;
                  setState(() { _deleteLoading = false; });

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
                      if (networkResult.data["deleteEquipment"] == null) {
                        // TODO: show error
                      }
                      else if (networkResult.data["deleteEquipment"] != null) {
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
        "type": _newEquipmentController.text
      }
    });

    await result.networkResult;

    setState(() { });
    Navigator.pop(context);

    _newEquipmentController.text = "";
  }

  void _showDialogNewEquipment (context) async {
    await showDialog(
      context: context,
      child: Mutation(
        options: MutationOptions(
          documentNode: gql('''
            mutation createEquipment(\$data: CreateEquipmentInput!) {
              createEquipment(data: \$data) {
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
              controller: _newEquipmentController,
              autofocus: true,
              decoration: InputDecoration(
                labelText: "Entrez un nom d'équipement"
              ),
              onSubmitted: (value) => _onAdd(runMutation),
            ),
            actions: [
              new FlatButton(
                child: Text('ANNULER'),
                onPressed: () {
                  _newEquipmentController.text = "";
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
          query equipments(\$filter: EquipmentsFilterInput!) {
            equipments (filter: \$filter) {
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

        List<Map> equipments;

        if (result.hasException) {
          body = Text(result.exception.toString());
        }
        else if (result.loading || result.data == null) {
          body = Center(child: CircularProgressIndicator());
        }
        else {

          equipments = (result.data["equipments"] as List).map((equipment) => {
            "id": equipment["id"],
            "type": equipment["type"],
          }).toList();
          debugPrint('equipments length: ' + equipments.length.toString());

          if (equipments.length == 0) {
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
                  mutation deleteEquipment(\$data: DeleteEquipmentInput!) {
                    deleteEquipment(data: \$data)
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
                
                return ListView.separated(
                  padding: EdgeInsets.only(top: 8),
                  itemCount: equipments.length,
                  itemBuilder: (_, i) => Slidable(
                    actionPane: SlidableDrawerActionPane(),
                    actionExtentRatio: 0.25,
                    child: ListTile(
                      title: Text(equipments[i]["type"]),
                      selected: _selectedEquipments.contains(equipments[i]["id"]),
                      onTap: () {
                        setState(() {
                          if (!_selectedEquipments.contains(equipments[i]["id"]))
                            _selectedEquipments.add(equipments[i]["id"]);
                          else
                            _selectedEquipments.remove(equipments[i]["id"]);
                        });
                      },
                    ),
                    secondaryActions: [
                      IconSlideAction(
                        caption: 'Supprimer',
                        color: Colors.red,
                        icon: Icons.delete,
                        onTap: () => _showDialogDelete(context, equipments[i], runDeleteMutation),
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
                  updateQuery: (existing, newEquipments) => ({
                    "equipments": newEquipments["equipments"]
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
                onPressed: () => _showDialogNewEquipment(context)
              ),
              IconButton(
                icon: Icon(Icons.check),
                onPressed: () {
                  Navigator.pop(context);
                  widget.onSelect(_selectedEquipments.map((id) => equipments.firstWhere((equipment) => equipment["id"] == id)["type"].toString()).toList());
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