import 'package:flutter/material.dart';

import 'package:graphql_flutter/graphql_flutter.dart';


class EditProperty extends StatefulWidget {
  EditProperty({ Key key, this.propertyId }) : super(key: key);

  final String propertyId;

  @override
  _EditPropertyState createState() => new _EditPropertyState();
}

class _EditPropertyState extends State<EditProperty> {

  TextEditingController _addressController = TextEditingController();
  TextEditingController _postalCodeController = TextEditingController();
  TextEditingController _cityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
        documentNode: gql('''
        query property(\$data: PropertyInput!) {
          property(data: \$data) {
            id
            firstName
            lastName
          }
        }
        '''),
        variables: {
          "data": {
            "propertyId": widget.propertyId
          }
        }
      ),
      builder: (
        QueryResult result, {
        Refetch refetch,
        FetchMore fetchMore,
      }) {

        if (result.data != null && _addressController.text == "") {
          _addressController.text = result.data["property"]["address"];
          _postalCodeController.text = result.data["property"]["postalCode"];
          _cityController.text = result.data["property"]["city"];
        }
        
        return Mutation(
          options: MutationOptions(
            documentNode: gql('''
              mutation updateProperty(\$data: UpdatePropertyInput!) {
                updateProperty(data: \$data)
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
                          "id": result.data["property"]["id"],
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
                          if (networkResult.data["updateProperty"] == null) {
                            // TODO: show error
                          }
                          else if (networkResult.data["updateProperty"] != null) {
                            Navigator.pop(context);
                            Navigator.popAndPushNamed(context, '/property', arguments: { "propertyId": widget.propertyId });// To refresh
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