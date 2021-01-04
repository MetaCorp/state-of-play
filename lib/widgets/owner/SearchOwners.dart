import 'package:flutter/material.dart';
import 'package:flutter_tests/widgets/owner/OwnersList.dart';
import 'package:flutter_tests/widgets/utilities/FlatButtonLoading.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:flutter_tests/models/StateOfPlay.dart' as sop;
// import 'package:intl/intl.dart';// DateFormat

typedef SelectCallback = Function(sop.Owner);

class SearchOwners extends StatefulWidget {
  SearchOwners({ Key key, this.onSelect }) : super(key: key);

  SelectCallback onSelect;

  @override
  _SearchOwnersState createState() => _SearchOwnersState();
}

// adb reverse tcp:9002 tcp:9002

class _SearchOwnersState extends State<SearchOwners> {

  TextEditingController _searchController = TextEditingController(text: "");

  bool _deleteLoading = false;

  void _showDialogDelete(context, sop.Owner owner, RunMutation runDeleteMutation) async {
    await showDialog(
      context: context,
      child: StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Supprimer '" + owner.firstName + ' ' + owner.lastName + "' ?"),
                owner.stateOfPlays.length > 0 ? Text("Ceci entrainera la suppression de '" + owner.stateOfPlays.length.toString() + "' état" + (owner.stateOfPlays.length > 1 ? "s" : "") + " des lieux.") : Container(),
              ]
            ),
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
                      "ownerId": owner.id,
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
                      if (networkResult.data["deleteOwner"] == null) {
                        // TODO: show error
                      }
                      else if (networkResult.data["deleteOwner"] != null) {
                        Navigator.pop(context);
                        setState(() { });
                        // Navigator.popAndPushNamed(context, '/owners');// To refresh
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

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
        documentNode: gql('''
          query owners(\$filter: OwnersFilterInput!) {
            owners (filter: \$filter) {
              id
              firstName
              lastName
              stateOfPlays {
                id
              }
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

        if (result.hasException) {
          body = Text(result.exception.toString());
        }
        else if (result.loading || result.data == null) {
          body = Center(child: CircularProgressIndicator());
        }
        else {

          List<sop.Owner> owners = (result.data["owners"] as List).map((owner) => sop.Owner.fromJSON(owner)).toList();
          debugPrint('stateOfPlays length: ' + owners.length.toString());

          if (owners.length == 0) {
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
                  mutation deleteOwner(\$data: DeleteOwnerInput!) {
                    deleteOwner(data: \$data)
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
                
                return OwnersList(
                  owners: owners,
                  onTap: (owner) => widget.onSelect != null ? widget.onSelect(owner) : Navigator.pushNamed(context, '/edit-owner', arguments: { "ownerId": owner.id }),
                  onDelete: (owner) => _showDialogDelete(context, owner, runDeleteMutation)
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
                labelText: 'Entrez votre recherche'
              ),
              onChanged: (value) {
                fetchMore(FetchMoreOptions(
                  variables: { "filter": { "search": value } },
                  updateQuery: (existing, newOwners) => ({
                    "owners": newOwners["owners"]
                  }),
                ));
              }
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () => null,
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