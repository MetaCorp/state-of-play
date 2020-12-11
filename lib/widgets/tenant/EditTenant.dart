import 'package:flutter/material.dart';

import 'package:graphql_flutter/graphql_flutter.dart';


class EditTenant extends StatefulWidget {
  EditTenant({ Key key, this.tenantId }) : super(key: key);

  final String tenantId;

  @override
  _EditTenantState createState() => new _EditTenantState();
}

class _EditTenantState extends State<EditTenant> {

  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();

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

        if (_lastNameController.text == "") {
          _firstNameController.text = result.data["tenant"]["firstName"];
          _lastNameController.text = result.data["tenant"]["lastName"];
        }
        
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
              // print('onCompleted: ' + resultData.hasException);
            },
          ),
          builder: (
            RunMutation runMutation,
            QueryResult mutationResult,
          ) {
            
            return Scaffold(
              appBar: AppBar(
                title: Text('Éditer un propriétaire'),
              ),
              body: Column(
                children: [
                  TextField(
                    controller: _firstNameController,
                    decoration: InputDecoration(hintText: 'Prénom'),
                  ),
                  TextField(
                    controller: _lastNameController,
                    decoration: InputDecoration(hintText: 'Nom'),
                  ),
                  RaisedButton(
                    child: Text('Sauvegarder'),
                    onPressed: () async {
                      MultiSourceResult mutationResult = runMutation({
                        "data": {
                          "id": result.data["tenant"]["id"],
                          "firstName": _firstNameController.text,
                          "lastName": _lastNameController.text,
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
                          if (networkResult.data["updateTenant"] == null) {
                            // TODO: show error
                          }
                          else if (networkResult.data["updateTenant"] != null) {
                            Navigator.pop(context);
                            Navigator.popAndPushNamed(context, '/tenant', arguments: { "tenantId": widget.tenantId });// To refresh
                          }
                        }
                      }
                    },
                  )
                ],
              )
            );
          }
        );
      }
    );
  }
}