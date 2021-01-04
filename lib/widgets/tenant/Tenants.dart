import 'package:flutter/material.dart';
import 'package:flutter_tests/widgets/tenant/TenantsList.dart';
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
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Supprimer '" + tenant.firstName + ' ' + tenant.lastName + "' ?"),
            tenant.stateOfPlays.length > 0 ? Text("Ceci entrainera la suppression de '" + tenant.stateOfPlays.length.toString() + "' état" + (tenant.stateOfPlays.length > 1 ? "s" : "") + " des lieux.") : Container(),
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
                  "tenantId": tenant.id,
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
            debugPrint('loading: ' + result.loading.toString());
            debugPrint('exception: ' + result.exception.toString());
            debugPrint('data: ' + result.data.toString());
            debugPrint('');

            if (result.hasException) {
              return Text(result.exception.toString());
            }

            if (result.loading || result.data == null) {
              return Center(
                child: CircularProgressIndicator()
              );
            }

            List<sop.Tenant> tenants = (result.data["tenants"] as List).map((tenant) => sop.Tenant.fromJSON(tenant)).toList();

            debugPrint('parsed data: ' + tenants.toString());

            if (tenants.length == 0) {
              return Container(
                alignment: Alignment.center,
                child: Text(
                  "Pas de locataire pour le moment.",
                  style: TextStyle(
                    color: Colors.grey[600]
                  )
                )
              );;
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
                  // debugPrint('onCompleted: ' + resultData.hasException);
                },
              ),
              builder: (
                RunMutation runDeleteMutation,
                QueryResult mutationResult,
              ) {
                
                return TenantsList(
                  tenants: tenants,
                  onTap: (tenant) => Navigator.pushNamed(context, '/edit-tenant', arguments: { "tenantId": tenant.id }),
                  onDelete: (tenant) => _showDialogDelete(context, tenant, runDeleteMutation)
                );
              }
            );
          }
        )
    );
  }
}