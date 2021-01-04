import 'package:flutter/material.dart';
import 'package:flutter_tests/models/StateOfPlay.dart' as sop;
import 'package:flutter_tests/widgets/utilities/NewInterlocutorContent.dart';

import 'package:graphql_flutter/graphql_flutter.dart';

class NewTenant extends StatefulWidget {
  NewTenant({Key key}) : super(key: key);

  @override
  _NewTenantState createState() => new _NewTenantState();
}

class _NewTenantState extends State<NewTenant> {


  @override
  Widget build(BuildContext context) {
    return Mutation(
      options: MutationOptions(
        documentNode: gql('''
          mutation createTenant(\$data: CreateTenantInput!) {
            createTenant(data: \$data) {
              id
              firstName
              lastName
            }
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
        RunMutation runMutation,
        QueryResult result,
      ) {
        
        return NewInterlocutorContent(
          title: 'Nouveau locataire',
          saveLoading: result.loading,
          interlocutor: sop.Tenant(),
          onSave: (tenant) async {
            debugPrint('runMutation');

            MultiSourceResult mutationResult = runMutation({
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
                if (networkResult.data["createTenant"] == null) {
                  // TODO: show error
                }
                else if (networkResult.data["createTenant"] != null) {
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
}