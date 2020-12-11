import 'package:flutter/material.dart';

import 'package:graphql_flutter/graphql_flutter.dart';


class NewProperty extends StatefulWidget {
  NewProperty({Key key}) : super(key: key);

  @override
  _NewPropertyState createState() => new _NewPropertyState();
}

class _NewPropertyState extends State<NewProperty> {

  TextEditingController _addressController = TextEditingController(text: "14 rue du test");
  TextEditingController _postalCodeController = TextEditingController(text: "75001");
  TextEditingController _cityController = TextEditingController(text: "Paris");

  @override
  Widget build(BuildContext context) {
    return Mutation(
      options: MutationOptions(
        documentNode: gql('''
          mutation createProperty(\$data: CreatePropertyInput!) {
            createProperty(data: \$data) {
              id
              address
              postalCode
              city
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
            title: Text('Nouvelle propriété'),
          ),
          body: Column(
            children: [
              TextField(
                controller: _addressController,
                decoration: InputDecoration(hintText: 'Adresse'),
              ),
              TextField(
                controller: _postalCodeController,
                decoration: InputDecoration(hintText: 'Code postal'),
              ),
              TextField(
                controller: _cityController,
                decoration: InputDecoration(hintText: 'Ville'),
              ),
              RaisedButton(
                child: Text('Sauvegarder'),
                onPressed: () async {
                  MultiSourceResult result = runMutation({
                    "data": {
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
                      if (networkResult.data["createProperty"] == null) {
                        // TODO: show error
                      }
                      else if (networkResult.data["createProperty"] != null) {
                        Navigator.pop(context);
                        Navigator.popAndPushNamed(context, '/properties');
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