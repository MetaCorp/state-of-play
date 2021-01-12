import 'package:flutter/material.dart';
import 'package:flutter_tests/widgets/tenant/TenantsList.dart';
import 'package:flutter_tests/widgets/utilities/FlatButtonLoading.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:flutter_tests/models/StateOfPlay.dart' as sop;
// import 'package:intl/intl.dart';// DateFormat
typedef SelectCallback = Function(sop.Tenant);

class SearchTenants extends StatefulWidget {
  SearchTenants({ Key key, this.onSelect }) : super(key: key);

  SelectCallback onSelect;

  @override
  _SearchTenantsState createState() => _SearchTenantsState();
}

// adb reverse tcp:9002 tcp:9002

class _SearchTenantsState extends State<SearchTenants> {

  TextEditingController _searchController = TextEditingController(text: "");

  bool _deleteLoading = false;

  void _showDialogDelete(context, sop.Tenant tenant, RunMutation runDeleteMutation, Refetch refetch) async {
    await showDialog(
      context: context,
      child: StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Supprimer '" + tenant.firstName + ' ' + tenant.lastName + "' ?"),
                tenant.stateOfPlays.length > 0 ? Text("Ceci entrainera la suppression de '" + tenant.stateOfPlays.length.toString() + "' état" + (tenant.stateOfPlays.length > 1 ? "s" : "") + " des lieux.") : Container(),
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
                      "tenantId": tenant.id,
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
          query tenants(\$filter: TenantsFilterInput!) {
            tenants (filter: \$filter) {
              id
              firstName
              lastName
              address
              postalCode
              city
              stateOfPlays {
                id
              }
            }
          }
        '''),
        fetchPolicy: FetchPolicy.networkOnly,
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

          List<sop.Tenant> tenants = (result.data["tenants"] as List).map((tenant) => sop.Tenant.fromJSON(tenant)).toList();
          debugPrint('stateOfPlays length: ' + tenants.length.toString());

          if (tenants.length == 0) {
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
                  onTap: (tenant) => widget.onSelect != null ? widget.onSelect(tenant) : Navigator.pushNamed(context, '/edit-tenant', arguments: { "tenantId": tenant.id }),
                  onDelete: (tenant) => _showDialogDelete(context, tenant, runDeleteMutation, refetch)
                );
              }
            );
          }

        }

        return Scaffold(
          appBar: AppBar(
            title: TextField(
              autofocus: true,
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Entrez votre recherche'
              ),
              onChanged: (value) {
                fetchMore(FetchMoreOptions(
                  variables: { "filter": { "search": value } },
                  updateQuery: (existing, newTenants) => ({
                    "tenants": newTenants["tenants"]
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