import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:flutter_tests/models/StateOfPlay.dart' as sop;
// import 'package:intl/intl.dart';// DateFormat

import 'package:flutter_tests/widgets/utilities/MyScaffold.dart';

class Representatives extends StatefulWidget {
  Representatives({Key key}) : super(key: key);

  @override
  _OwnersState createState() => _OwnersState();
}

// adb reverse tcp:9002 tcp:9002

class _OwnersState extends State<Representatives> {
  
  void _showDialogDelete(context, sop.Representative representative, RunMutation runDeleteMutation) async {
    await showDialog(
      context: context,
      child: AlertDialog(
        content: Text("Supprimer '" + representative.firstName + ' ' + representative.lastName + "' ?"),
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
                  "representativeId": representative.id,
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
  Widget build(BuildContext context) {
    return MyScaffold(
      appBar: AppBar(
        title: Text('Mandataires'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => Navigator.pushNamed(context, '/search-representatives'),
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => Navigator.pushNamed(context, '/new-representative'),
          ),
        ],
      ),
      body: 
        Query(
          options: QueryOptions(
            documentNode: gql('''
            query representatives {
              representatives {
                id
                firstName
                lastName
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

            List<sop.Representative> representatives = (result.data["representatives"] as List).map((representative) => sop.Representative.fromJSON(representative)).toList();

            print('parsed data: ' + representatives.toString());

            if (representatives.length == 0) {
              return Text("no representatives");
            }

            return Mutation(
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
                    itemCount: representatives.length,
                    itemBuilder: (_, i) => Slidable(
                      actionPane: SlidableDrawerActionPane(),
                      actionExtentRatio: 0.125,
                      child: ListTile(
                        title: Text(representatives[i].firstName + ' ' + representatives[i].lastName),
                        onTap: () => Navigator.pushNamed(context, '/edit-representative', arguments: { "representativeId": representatives[i].id }),
                        contentPadding: EdgeInsets.fromLTRB(16, 4, 16, 4),
                      ),
                      secondaryActions: [
                        IconSlideAction(
                          caption: 'Supprimer',
                          color: Colors.red,
                          icon: Icons.delete,
                          onTap: () => _showDialogDelete(context, representatives[i], runDeleteMutation),
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