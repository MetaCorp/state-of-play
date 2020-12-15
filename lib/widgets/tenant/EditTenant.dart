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
  TextEditingController _addressController = TextEditingController();
  TextEditingController _postalCodeController = TextEditingController();
  TextEditingController _cityController = TextEditingController();

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

        if (result.data != null && _lastNameController.text == "") {
          _firstNameController.text = result.data["tenant"]["firstName"];
          _lastNameController.text = result.data["tenant"]["lastName"];
          _addressController.text = result.data["tenant"]["address"];
          _postalCodeController.text = result.data["tenant"]["postalCode"];
          _cityController.text = result.data["tenant"]["city"];
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
                    decoration: InputDecoration(labelText: 'Prénom'),
                  ),
                  TextField(
                    controller: _lastNameController,
                    decoration: InputDecoration(labelText: 'Nom'),
                  ),
                  TextField(
                    controller: _addressController,
                    decoration: InputDecoration(labelText: 'Adresse'),
                  ),
                  TextField(
                    controller: _postalCodeController,
                    decoration: InputDecoration(labelText: 'Code postal'),
                  ),
                  TextField(
                    controller: _cityController,
                    decoration: InputDecoration(labelText: 'Ville'),
                  ),
                  RaisedButton(
                    child: Text('Sauvegarder'),
                    onPressed: () async {
                      MultiSourceResult mutationResult = runMutation({
                        "data": {
                          "id": result.data["tenant"]["id"],
                          "firstName": _firstNameController.text,
                          "lastName": _lastNameController.text,
                          "address": _addressController.text,
                          "postalCode": _postalCodeController.text,
                          "city": _cityController.text,
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