import 'package:flutter/material.dart';
import 'package:flutter_tests/widgets/representative/RepresentativesList.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:flutter_tests/models/StateOfPlay.dart' as sop;
// import 'package:intl/intl.dart';// DateFormat
typedef SelectCallback = Function(sop.Representative);

class SearchRepresentatives extends StatefulWidget {
  SearchRepresentatives({ Key key, this.onSelect }) : super(key: key);

  SelectCallback onSelect;

  @override
  _SearchRepresentativesState createState() => _SearchRepresentativesState();
}

// adb reverse tcp:9002 tcp:9002

class _SearchRepresentativesState extends State<SearchRepresentatives> {

  TextEditingController _searchController = TextEditingController(text: "");

  void _showDialogDelete(context, sop.Representative representative, RunMutation runDeleteMutation) async {
    await showDialog(
      context: context,
      child: AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Supprimer '" + representative.firstName + ' ' + representative.lastName + "' ?"),
            representative.stateOfPlays.length > 0 ? Text("Ceci entrainera la suppression de '" + representative.stateOfPlays.length.toString() + "' état" + (representative.stateOfPlays.length > 1 ? "s" : "") + " des lieux.") : Container(),
          ]
        ),
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
                  "representativeId": representative.id,
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
                  if (networkResult.data["deleteRepresentative"] == null) {
                    // TODO: show error
                  }
                  else if (networkResult.data["deleteRepresentative"] != null) {
                    Navigator.pop(context);
                    setState(() { });
                    // Navigator.popAndPushNamed(context, '/representatives');// To refresh
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

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
        documentNode: gql('''
          query representatives(\$filter: RepresentativesFilterInput!) {
            representatives (filter: \$filter) {
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

          List<sop.Representative> representatives = (result.data["representatives"] as List).map((representative) => sop.Representative.fromJSON(representative)).toList();
          debugPrint('stateOfPlays length: ' + representatives.length.toString());

          if (representatives.length == 0) {
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
                  mutation deleteRepresentative(\$data: DeleteRepresentativeInput!) {
                    deleteRepresentative(data: \$data)
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
                
                return RepresentativesList(
                  representatives: representatives,
                  onTap: (representative) => widget.onSelect != null ? widget.onSelect(representative) : Navigator.pushNamed(context, '/edit-representative', arguments: { "representativeId": representative.id }),
                  onDelete: (representative) => _showDialogDelete(context, representative, runDeleteMutation)
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
                  updateQuery: (existing, newRepresentatives) => ({
                    "representatives": newRepresentatives["representatives"]
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