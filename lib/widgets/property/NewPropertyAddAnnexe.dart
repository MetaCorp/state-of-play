import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

typedef SelectCallback = void Function(List<String>);

class NewPropertyAddAnnexe extends StatefulWidget {
  NewPropertyAddAnnexe({ Key key, this.onSelect }) : super(key: key);

  final SelectCallback onSelect;

  @override
  _NewPropertyAddAnnexeState createState() => _NewPropertyAddAnnexeState();
}

// adb reverse tcp:9002 tcp:9002

class _NewPropertyAddAnnexeState extends State<NewPropertyAddAnnexe> {

  TextEditingController _searchController = TextEditingController(text: "");
  TextEditingController _newPropertyTypeController = TextEditingController(text: "");

  List<String> _selectedPropertyTypes = []; 

  void _showDialogDelete(context, propertyType, RunMutation runDeleteMutation) async {
    await showDialog(
      context: context,
      child: AlertDialog(
        content: Text("Supprimer '" + propertyType["type"] + "' ?"),
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
                  "propertyTypeId": propertyType["id"],
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
                  if (networkResult.data["deletePropertyType"] == null) {
                    // TODO: show error
                  }
                  else if (networkResult.data["deletePropertyType"] != null) {
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

  void _showDialogNewPropertyType (context) async {
    await showDialog(
      context: context,
      child: Mutation(
        options: MutationOptions(
          documentNode: gql('''
            mutation createPropertyType(\$data: CreatePropertyTypeInput!) {
              createPropertyType(data: \$data) {
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
              controller: _newPropertyTypeController,
              autofocus: true,
              decoration: InputDecoration(
                labelText: "Entrez un type de bien"
              ),
            ),
            actions: [
              new FlatButton(
                child: Text('ANNULER'),
                onPressed: () {
                  _newPropertyTypeController.text = "";
                  Navigator.pop(context);
                }
              ),
              new FlatButton(
                child: Text('AJOUTER'),
                onPressed: () async {
                  MultiSourceResult result = runMutation({
                    "data": {
                      "type": _newPropertyTypeController.text
                    }
                  });

                  await result.networkResult;

                  setState(() { });
                  Navigator.pop(context);

                  _newPropertyTypeController.text = "";
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
          query propertyTypes(\$filter: PropertyTypesFilterInput!) {
            propertyTypes (filter: \$filter) {
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

        List<Map> propertyTypes;

        if (result.hasException) {
          body = Text(result.exception.toString());
        }
        else if (result.loading || result.data == null) {
          body = Center(child: CircularProgressIndicator());
        }
        else {

          propertyTypes = (result.data["propertyTypes"] as List).map((propertyType) => {
            "id": propertyType["id"],
            "type": propertyType["type"],
          }).toList();
          print('propertyTypes length: ' + propertyTypes.length.toString());

          if (propertyTypes.length == 0) {
            body = Text("no propertyType");
          }
          else {
            body = Mutation(
              options: MutationOptions(
                documentNode: gql('''
                  mutation deletePropertyType(\$data: DeletePropertyTypeInput!) {
                    deletePropertyType(data: \$data)
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
                  itemCount: propertyTypes.length,
                  itemBuilder: (_, i) => Slidable(
                    actionPane: SlidableDrawerActionPane(),
                    actionExtentRatio: 0.25,
                    child: ListTile(
                      title: Text(propertyTypes[i]["type"]),
                      selected: _selectedPropertyTypes.contains(propertyTypes[i]["id"]),
                      onTap: () {
                        setState(() {
                          if (!_selectedPropertyTypes.contains(propertyTypes[i]["id"]))
                            _selectedPropertyTypes.add(propertyTypes[i]["id"]);
                          else
                            _selectedPropertyTypes.remove(propertyTypes[i]["id"]);
                        });
                      },
                    ),
                    secondaryActions: [
                      IconSlideAction(
                        caption: 'Supprimer',
                        color: Colors.red,
                        icon: Icons.delete,
                        onTap: () => _showDialogDelete(context, propertyTypes[i], runDeleteMutation),
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
                  updateQuery: (existing, newPropertyTypes) => ({
                    "propertyTypes": newPropertyTypes["propertyTypes"]
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
                onPressed: () => _showDialogNewPropertyType(context)
              ),
              IconButton(
                icon: Icon(Icons.check),
                onPressed: () {
                  widget.onSelect(_selectedPropertyTypes.map((id) => propertyTypes.firstWhere((propertyType) => propertyType["id"] == id)["type"].toString()).toList());
                  Navigator.pop(context);
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