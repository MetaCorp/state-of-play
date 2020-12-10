import 'package:flutter/material.dart';

import 'package:graphql_flutter/graphql_flutter.dart';


class NewOwner extends StatefulWidget {
  NewOwner({Key key}) : super(key: key);

  @override
  _NewOwnerState createState() => new _NewOwnerState();
}

class _NewOwnerState extends State<NewOwner> {

  TextEditingController _firstNameController = TextEditingController(text: "Jean");
  TextEditingController _lastNameController = TextEditingController(text: "Propriétaire");

  @override
  Widget build(BuildContext context) {
    return Mutation(
      options: MutationOptions(
        documentNode: gql('''
          mutation createOwner(\$data: CreateOwnerInput!) {
            createOwner(data: \$data) {
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
            title: Text('Nouveau propriétaire'),
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
                  MultiSourceResult result = runMutation({
                    "data": {
                      "firstName": _firstNameController.text,
                      "lastName": _lastNameController.text,
                    }
                  });
                  QueryResult networkResult = await result.networkResult;

                  if (networkResult.hasException) {
                  
                  }
                  else {
                    print('queryResult data: ' + networkResult.data.toString());
                    if (networkResult.data != null) {
                      if (networkResult.data["createOwner"] == null) {
                        // TODO: show error
                      }
                      else if (networkResult.data["createOwner"] != null) {
                        Navigator.popAndPushNamed(context, '/owners');
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