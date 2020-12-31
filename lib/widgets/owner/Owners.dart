import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:flutter_tests/models/StateOfPlay.dart' as sop;
// import 'package:intl/intl.dart';// DateFormat

import 'package:flutter_tests/widgets/utilities/MyScaffold.dart';

class Owners extends StatefulWidget {
  Owners({Key key}) : super(key: key);

  @override
  _OwnersState createState() => _OwnersState();
}

// adb reverse tcp:9002 tcp:9002

class _OwnersState extends State<Owners> {

  
  void _showDialogDelete(context, sop.Owner owner, RunMutation runDeleteMutation) async {
    await showDialog(
      context: context,
      child: AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Supprimer '" + owner.firstName + ' ' + owner.lastName + "' ?"),
            owner.stateOfPlays.length > 0 ? Text("Ceci entrainera la suppression de '" + owner.stateOfPlays.length.toString() + "' état" + (owner.stateOfPlays.length > 1 ? "s" : "") + " des lieux.") : Container(),
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
              print('runDeleteMutation');

              MultiSourceResult mutationResult = runDeleteMutation({
                "data": {
                  "ownerId": owner.id,
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
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      appBar: AppBar(
        title: Text('Propriétaires'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => Navigator.pushNamed(context, '/search-owners'),
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => Navigator.pushNamed(context, '/new-owner'),
          ),
        ],
      ),
      body: 
        Query(
          options: QueryOptions(
            documentNode: gql('''
            query owners {
              owners {
                id
                firstName
                lastName
                stateOfPlays {
                  id
                }
              }
            }
            ''')
          ),
          builder: (
            QueryResult result, {
            Refetch refetch,
            FetchMore fetchMore,
          }) {
            print('loading: ' + result.loading.toString());
            print('exception: ' + result.exception.toString());
            print('data: ' + result.data.toString());
            print('');

            if (result.hasException) {
              return Text(result.exception.toString());
            }

            if (result.loading || result.data == null) {
              return Center(child: CircularProgressIndicator());
            }

            List<sop.Owner> owners = (result.data["owners"] as List).map((owner) => sop.Owner.fromJSON(owner)).toList();

            print('parsed data: ' + owners.toString());

            if (owners.length == 0) {
              return Container(
                alignment: Alignment.center,
                child: Text(
                  "Pas de propriétaire pour le moment.",
                  style: TextStyle(
                    color: Colors.grey[600]
                  )
                )
              );
            }

            return Mutation(
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
                  // print('onCompleted: ' + resultData.hasException);
                },
              ),
              builder: (
                RunMutation runDeleteMutation,
                QueryResult mutationResult,
              ) {
                
                return Container(
                  child: ListView.separated(
                    padding: EdgeInsets.only(top: 8),
                    itemCount: owners.length,
                    itemBuilder: (_, i) => Slidable(
                      actionPane: SlidableDrawerActionPane(),
                      actionExtentRatio: 0.25,
                      child: ListTile(
                        title: Text(owners[i].firstName + ' ' + owners[i].lastName),
                        onTap: () => Navigator.pushNamed(context, '/edit-owner', arguments: { "ownerId": owners[i].id }),
                        contentPadding: EdgeInsets.fromLTRB(16, 4, 16, 4),
                      ),
                      secondaryActions: [
                        IconSlideAction(
                          caption: 'Supprimer',
                          color: Colors.red,
                          icon: Icons.delete,
                          onTap: () => _showDialogDelete(context, owners[i], runDeleteMutation),
                        ),
                      ],
                    ),
                    separatorBuilder: (context, index) {
                      return Divider();
                    },
                  ),
                );
              }
            );
          }
        )
    );
  }
}