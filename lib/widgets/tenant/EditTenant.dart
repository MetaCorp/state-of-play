import 'package:flutter/material.dart';
import 'package:flutter_tests/models/StateOfPlay.dart' as sop;
import 'package:flutter_tests/widgets/utilities/NewInterlocutor/NewInterlocutor.dart';

import 'package:graphql_flutter/graphql_flutter.dart';

class EditTenant extends StatefulWidget {
  EditTenant({ Key key, this.tenantId }) : super(key: key);

  final String tenantId;

  @override
  _EditTenantState createState() => new _EditTenantState();
}

class _EditTenantState extends State<EditTenant> {

  @override
  Widget build(BuildContext context) {

    return Query(
      options: QueryOptions(
        documentNode: gql('''
        query tenant(\$data: TenantInput!) {
          tenant(data: \$data) {
            id
            firstName
            lastName
            address
            postalCode
            city
          }
        }
        '''),
        variables: {
          "data": {
            "tenantId": widget.tenantId
          }
        }
      ),
      builder: (
        QueryResult result, {
        Refetch refetch,
        FetchMore fetchMore,
      }) {

        sop.Tenant tenant;
        if (result.data != null) {
          tenant = sop.Tenant.fromJSON(result.data["tenant"]);
        }

        if (result.data == null || result.loading)
          return Scaffold(
            appBar: AppBar(
              title: Text('Éditer un locataire'),
            ),
            body: Center(
              child: CircularProgressIndicator()
            )
          );
        
        return Mutation(
          options: MutationOptions(
            documentNode: gql('''
              mutation updateTenant(\$data: UpdateTenantInput!) {
                updateTenant(data: \$data)
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
            RunMutation runUpdateMutation,
            QueryResult mutationUpdateResult,
          ) {
            
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
                
                return NewInterlocutor(
                  title: 'Éditer un propriétaire',
                  saveLoading: mutationUpdateResult.loading,
                  interlocutor: tenant,
                  onSave: (tenant) async {
                    debugPrint('runUpdateMutation');

                    MultiSourceResult mutationResult = runUpdateMutation({
                      "data": {
                        "id": tenant.id,
                        "firstName": tenant.firstName,
                        "lastName": tenant.lastName,
                        "address": tenant.address,
                        "postalCode": tenant.postalCode,
                        "city": tenant.city,
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
                        if (networkResult.data["updateTenant"] == null) {
                          // TODO: show error
                        }
                        else if (networkResult.data["updateTenant"] != null) {
                          Navigator.pop(context);
                          Navigator.popAndPushNamed(context, '/tenants');// To refresh
                        }
                      }
                    }
                  },
                  onDelete: () async {
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
                          Navigator.popAndPushNamed(context, '/tenants');// To refresh
                        }
                      }
                    }
                  },
                );
              }
            );
          }
        );
      }
    );
  }
}