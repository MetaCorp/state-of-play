import 'package:flutter/material.dart';

import 'package:graphql_flutter/graphql_flutter.dart';


class NewTenant extends StatefulWidget {
  NewTenant({Key key}) : super(key: key);

  @override
  _NewTenantState createState() => new _NewTenantState();
}

class _NewTenantState extends State<NewTenant> {

  TextEditingController _firstNameController = TextEditingController(text: "Jean");
  TextEditingController _lastNameController = TextEditingController(text: "Locataire");
  TextEditingController _addressController = TextEditingController(text: "42 rue du Test");
  TextEditingController _postalCodeController = TextEditingController(text: "75001");
  TextEditingController _cityController = TextEditingController(text: "Paris");

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
          // print('onCompleted: ' + resultData.hasException);
        },
      ),
      builder: (
        RunMutation runMutation,
        QueryResult result,
      ) {
        
        return Scaffold(
          appBar: AppBar(
            title: Text('Nouveau locataire'),
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
                  MultiSourceResult result = runMutation({
                    "data": {
                      "firstName": _firstNameController.text,
                      "lastName": _lastNameController.text,
                      "address": _addressController.text,
                      "postalCode": _postalCodeController.text,
                      "city": _cityController.text,
                    }
                  });
                  QueryResult networkResult = await result.networkResult;

                  if (networkResult.hasException) {
                  
                  }
                  else {
                    print('queryResult data: ' + networkResult.data.toString());
                    if (networkResult.data != null) {
                      if (networkResult.data["createTenant"] == null) {
                        // TODO: show error
                      }
                      else if (networkResult.data["createTenant"] != null) {
                        Navigator.pop(context);
                        Navigator.popAndPushNamed(context, '/tenants');
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
}