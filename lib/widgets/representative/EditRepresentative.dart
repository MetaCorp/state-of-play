import 'package:flutter/material.dart';

import 'package:graphql_flutter/graphql_flutter.dart';


class EditRepresentative extends StatefulWidget {
  EditRepresentative({ Key key, this.representativeId }) : super(key: key);

  final String representativeId;

  @override
  _EditRepresentativeState createState() => new _EditRepresentativeState();
}

class _EditRepresentativeState extends State<EditRepresentative> {

  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
        documentNode: gql('''
        query representative(\$data: RepresentativeInput!) {
          representative(data: \$data) {
            id
            firstName
            lastName
          }
        }
        '''),
        variables: {
          "data": {
            "representativeId": widget.representativeId
          }
        }
      ),
      builder: (
        QueryResult result, {
        Refetch refetch,
        FetchMore fetchMore,
      }) {

        if (_lastNameController.text == "") {
          _firstNameController.text = result.data["representative"]["firstName"];
          _lastNameController.text = result.data["representative"]["lastName"];
        }
        
        return Mutation(
          options: MutationOptions(
            documentNode: gql('''
              mutation updateRepresentative(\$data: UpdateRepresentativeInput!) {
                updateRepresentative(data: \$data)
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
                          "id": result.data["representative"]["id"],
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
                          if (networkResult.data["updateRepresentative"] == null) {
                            // TODO: show error
                          }
                          else if (networkResult.data["updateRepresentative"] != null) {
                            Navigator.pop(context);
                            Navigator.popAndPushNamed(context, '/representative', arguments: { "representativeId": widget.representativeId });// To refresh
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