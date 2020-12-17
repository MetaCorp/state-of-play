import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:flutter_tests/models/StateOfPlay.dart' as sop;

import 'package:flutter_tests/widgets/utilities/MyScaffold.dart';

class Tenants extends StatefulWidget {
  Tenants({Key key}) : super(key: key);

  @override
  _TenantsState createState() => _TenantsState();
}

// adb reverse tcp:9002 tcp:9002

class _TenantsState extends State<Tenants> {

  
  void _showDialogDelete(context, sop.Tenant tenant, RunMutation runDeleteMutation) async {
    await showDialog(
      context: context,
      child: AlertDialog(
        content: Text("Supprimer '" + tenant.firstName + ' ' + tenant.lastName + "' ?"),
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
                  "tenantId": tenant.id,
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
                  if (networkResult.data["deleteTenant"] == null) {
                    // TODO: show error
                  }
                  else if (networkResult.data["deleteTenant"] != null) {
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
  Widget build(BuildContext context) {
    return MyScaffold(
      appBar: AppBar(
        title: Text('Locataires'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => Navigator.pushNamed(context, '/search-tenants'),
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => Navigator.pushNamed(context, '/new-tenant'),
          ),
        ],
      ),
      body: 
        Query(
          options: QueryOptions(
            documentNode: gql('''
            query tenants {
              tenants {
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
              return Center(
                child: CircularProgressIndicator()
              );
            }

            List<sop.Tenant> tenants = (result.data["tenants"] as List).map((tenant) => sop.Tenant.fromJSON(tenant)).toList();

            print('parsed data: ' + tenants.toString());

            if (tenants.length == 0) {
              return Text("no tenants");
            }

            return Mutation(
              options: MutationOptions(
                documentNode: gql('''
                  mutation deleteTenant(\$data: DeleteTenantInput!) {
                    deleteTenant(data: \$data)
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
                    itemCount: tenants.length,
                    itemBuilder: (_, i) => Slidable(
                      actionPane: SlidableDrawerActionPane(),
                      actionExtentRatio: 0.25,
                      child: ListTile(
                        title: Text(tenants[i].firstName + ' ' + tenants[i].lastName),
                        onTap: () => Navigator.pushNamed(context, '/edit-tenant', arguments: { "tenantId": tenants[i].id }),
                        contentPadding: EdgeInsets.fromLTRB(16, 4, 16, 4),
                      ),
                      secondaryActions: [
                        IconSlideAction(
                          caption: 'Supprimer',
                          color: Colors.red,
                          icon: Icons.delete,
                          onTap: () => _showDialogDelete(context, tenants[i], runDeleteMutation),
                        ),
                      ],
                    ),
                    separatorBuilder: (context, index) {
                      return Divider(
                        height: 0.0,
                      );
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