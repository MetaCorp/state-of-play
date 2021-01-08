import 'package:flutter/material.dart';
import 'package:flutter_tests/widgets/utilities/FlatButtonLoading.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:feature_discovery/feature_discovery.dart';

typedef SelectCallback = void Function(List<String>);

class NewStateOfPlayDetailsAddRoom extends StatefulWidget {
  NewStateOfPlayDetailsAddRoom({ Key key, this.onSelect }) : super(key: key);

  final SelectCallback onSelect;

  @override
  _NewStateOfPlayDetailsAddRoomState createState() => _NewStateOfPlayDetailsAddRoomState();
}

// adb reverse tcp:9002 tcp:9002

class _NewStateOfPlayDetailsAddRoomState extends State<NewStateOfPlayDetailsAddRoom> {

  TextEditingController _searchController = TextEditingController(text: "");
  TextEditingController _newRoomController = TextEditingController(text: "");

  List<String> _selectedRooms = [];

  bool _deleteLoading = false;

  @override
  void initState() { 
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((Duration duration) {
      Future.delayed(const Duration(seconds: 1), () => FeatureDiscovery.discoverFeatures(
        context,
        const <String>{ // Feature ids for every feature that you want to showcase in order.
          'search_room',
          'add_newroom',
          'validate_rooms'
        },
      ));
    });
  }

  void _showDialogDelete(context, room, RunMutation runDeleteMutation, Refetch refetch) async {
    await showDialog(
      context: context,
      child: AlertDialog(
        content: Text("Supprimer '" + room["name"] + "' ?"),
        actions: [
          FlatButton(
            child: Text('ANNULER'),
            onPressed: () {
              Navigator.pop(context);
            }
          ),
          FlatButtonLoading(
            loading: _deleteLoading,
            child: Text('SUPPRIMER'),
            onPressed: () async {
              debugPrint('runDeleteMutation');

              setState(() { _deleteLoading = true; });
              MultiSourceResult mutationResult = runDeleteMutation({
                "data": {
                  "roomId": room["id"],
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
                  if (networkResult.data["deleteRoom"] == null) {
                    // TODO: show error
                  }
                  else if (networkResult.data["deleteRoom"] != null) {
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

  void _showDialogNewRoom (context) async {
    await showDialog(
      context: context,
      child: Mutation(
        options: MutationOptions(
          documentNode: gql('''
            mutation createRoom(\$data: CreateRoomInput!) {
              createRoom(data: \$data) {
                id
                name
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
              controller: _newRoomController,
              autofocus: true,
              decoration: InputDecoration(
                labelText: "Entrez un nom de pièce"
              ),
            ),
            actions: [
              new FlatButton(
                child: Text('ANNULER'),
                onPressed: () {
                  _newRoomController.text = "";
                  Navigator.pop(context);
                }
              ),
              new FlatButton(
                child: Text('AJOUTER'),
                onPressed: () async {
                  MultiSourceResult result = runMutation({
                    "data": {
                      "name": _newRoomController.text
                    }
                  });

                  await result.networkResult;

                  setState(() { });
                  Navigator.pop(context);

                  _newRoomController.text = "";
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
          query rooms(\$filter: RoomsFilterInput!) {
            rooms (filter: \$filter) {
              id
              name
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

        List<Map> rooms;

        if (result.hasException) {
          body = Text(result.exception.toString());
        }
        else if (result.loading || result.data == null) {
          body = Center(child: CircularProgressIndicator());// TODO center
        }
        else {

          rooms = (result.data["rooms"] as List).map((room) => {
            "id": room["id"],
            "name": room["name"],
          }).toList();
          debugPrint('rooms length: ' + rooms.length.toString());

          if (rooms.length == 0) {
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
                  mutation deleteRoom(\$data: DeleteRoomInput!) {
                    deleteRoom(data: \$data)
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
                  itemCount: rooms.length,
                  itemBuilder: (_, i) => Slidable(
                    actionPane: SlidableDrawerActionPane(),
                    actionExtentRatio: 0.25,
                    child: ListTile(
                      title: Text(rooms[i]["name"]),
                      selected: _selectedRooms.contains(rooms[i]["id"]),
                      onTap: () {
                        setState(() {
                          if (!_selectedRooms.contains(rooms[i]["id"]))
                            _selectedRooms.add(rooms[i]["id"]);
                          else
                            _selectedRooms.remove(rooms[i]["id"]);
                        });
                      },
                    ),
                    secondaryActions: [
                      IconSlideAction(
                        caption: 'Supprimer',
                        color: Colors.red,
                        icon: Icons.delete,
                        onTap: () => _showDialogDelete(context, rooms[i], runDeleteMutation, refetch),
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
            title: DescribedFeatureOverlay(
              featureId: 'search_room',
              tapTarget: Icon(Icons.touch_app),
              title: Text('Rechercher une pièce'),
              description: Text("Pour rechercher une pièce, cliquez sur le champ texte en haut de l'app."),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Entrez votre recherche'
                ),
                onChanged: (value) {
                  fetchMore(FetchMoreOptions(
                    variables: { "filter": { "search": value } },
                    updateQuery: (existing, newRooms) => ({
                      "rooms": newRooms["rooms"]
                    }),
                  ));
                }
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () => null,
              ),
              DescribedFeatureOverlay(
                featureId: 'add_newroom',
                tapTarget: Icon(Icons.add),
                title: Text('Ajouter une nouvelle pièce à la liste de référence'),
                description: Text("Si la pièce que vous chercher n'est pas dans la liste de référence pré-remplie. Vous pouvez l'ajouter en cliquant sur le +."),
                child: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () => _showDialogNewRoom(context)
                ),
              ),
              DescribedFeatureOverlay(
                featureId: 'validate_rooms',
                tapTarget: Icon(Icons.check),
                title: Text('Valider les pièces sélectionnées'),
                description: Text("Pour valider les pièces sélectionnées, cliquez sur le bouton check."),
                child: IconButton(
                  icon: Icon(Icons.check),
                  onPressed: () {
                    Navigator.pop(context);
                    widget.onSelect(_selectedRooms.map((id) => rooms.firstWhere((room) => room["id"] == id)["name"].toString()).toList());
                  }
                ),
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