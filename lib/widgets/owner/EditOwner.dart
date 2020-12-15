import 'package:flutter/material.dart';

import 'package:graphql_flutter/graphql_flutter.dart';


class EditOwner extends StatefulWidget {
  EditOwner({ Key key, this.ownerId }) : super(key: key);

  final String ownerId;

  @override
  _EditOwnerState createState() => new _EditOwnerState();
}

class _EditOwnerState extends State<EditOwner> {

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
        query owner(\$data: OwnerInput!) {
          owner(data: \$data) {
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
            "ownerId": widget.ownerId
          }
        }
      ),
      builder: (
        QueryResult result, {
        Refetch refetch,
        FetchMore fetchMore,
      }) {

        if (result.data != null && _lastNameController.text == "") {
          _firstNameController.text = result.data["owner"]["firstName"];
          _lastNameController.text = result.data["owner"]["lastName"];
          _addressController.text = result.data["owner"]["address"];
          _postalCodeController.text = result.data["owner"]["postalCode"];
          _cityController.text = result.data["owner"]["city"];
        }
        
        return Mutation(
          options: MutationOptions(
            documentNode: gql('''
              mutation updateOwner(\$data: UpdateOwnerInput!) {
                updateOwner(data: \$data)
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
                          "id": result.data["owner"]["id"],
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
                          if (networkResult.data["updateOwner"] == null) {
                            // TODO: show error
                          }
                          else if (networkResult.data["updateOwner"] != null) {
                            Navigator.pop(context);
                            Navigator.popAndPushNamed(context, '/owner', arguments: { "ownerId": widget.ownerId });// To refresh
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