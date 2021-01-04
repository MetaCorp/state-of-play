import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

typedef SelectCallback = void Function(List<String>);

class NewStateOfPlayMiscAddMeter extends StatefulWidget {
  NewStateOfPlayMiscAddMeter({ Key key, this.onSelect }) : super(key: key);

  final SelectCallback onSelect;

  @override
  _NewStateOfPlayMiscAddMeterState createState() => _NewStateOfPlayMiscAddMeterState();
}

// adb reverse tcp:9002 tcp:9002

class _NewStateOfPlayMiscAddMeterState extends State<NewStateOfPlayMiscAddMeter> {

  TextEditingController _searchController = TextEditingController(text: "");
  TextEditingController _newMeterController = TextEditingController(text: "");

  List<String> _selectedMeters = []; 

  void _showDialogDelete(context, meter, RunMutation runDeleteMutation) async {
    await showDialog(
      context: context,
      child: AlertDialog(
        content: Text("Supprimer '" + meter["type"] + "' ?"),
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
                  "meterId": meter["id"],
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
                  if (networkResult.data["deleteMeter"] == null) {
                    // TODO: show error
                  }
                  else if (networkResult.data["deleteMeter"] != null) {
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

  _onAdd(runMutation) async {
    MultiSourceResult result = runMutation({
      "data": {
        "type": _newMeterController.text
      }
    });

    await result.networkResult;

    setState(() { });
    Navigator.pop(context);

    _newMeterController.text = "";
  }

  void _showDialogNewMeter (context) async {
    await showDialog(
      context: context,
      child: Mutation(
        options: MutationOptions(
          documentNode: gql('''
            mutation createMeter(\$data: CreateMeterInput!) {
              createMeter(data: \$data) {
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
              controller: _newMeterController,
              autofocus: true,
              decoration: InputDecoration(
                labelText: "Entrez un nom de compteur"
              ),
              onSubmitted: (value) => _onAdd(runMutation),
            ),
            actions: [
              new FlatButton(
                child: Text('ANNULER'),
                onPressed: () {
                  _newMeterController.text = "";
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
          query meters(\$filter: MetersFilterInput!) {
            meters (filter: \$filter) {
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

        List<Map> meters;

        if (result.hasException) {
          body = Text(result.exception.toString());
        }
        else if (result.loading || result.data == null) {
          body = Center(child: CircularProgressIndicator());
        }
        else {

          meters = (result.data["meters"] as List).map((meter) => {
            "id": meter["id"],
            "type": meter["type"],
          }).toList();
          debugPrint('meters length: ' + meters.length.toString());

          if (meters.length == 0) {
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
                  mutation deleteMeter(\$data: DeleteMeterInput!) {
                    deleteMeter(data: \$data)
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
                  itemCount: meters.length,
                  itemBuilder: (_, i) => Slidable(
                    actionPane: SlidableDrawerActionPane(),
                    actionExtentRatio: 0.25,
                    child: ListTile(
                      title: Text(meters[i]["type"]),
                      selected: _selectedMeters.contains(meters[i]["id"]),
                      onTap: () {
                        setState(() {
                          if (!_selectedMeters.contains(meters[i]["id"]))
                            _selectedMeters.add(meters[i]["id"]);
                          else
                            _selectedMeters.remove(meters[i]["id"]);
                        });
                      },
                    ),
                    secondaryActions: [
                      IconSlideAction(
                        caption: 'Supprimer',
                        color: Colors.red,
                        icon: Icons.delete,
                        onTap: () => _showDialogDelete(context, meters[i], runDeleteMutation),
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
                  updateQuery: (existing, newMeters) => ({
                    "meters": newMeters["meters"]
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
                onPressed: () => _showDialogNewMeter(context)
              ),
              IconButton(
                icon: Icon(Icons.check),
                onPressed: () {
                  Navigator.pop(context);
                  widget.onSelect(_selectedMeters.map((id) => meters.firstWhere((meter) => meter["id"] == id)["type"].toString()).toList());
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