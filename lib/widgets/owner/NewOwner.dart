import 'package:flutter/material.dart';
import 'package:flutter_tests/models/StateOfPlay.dart' as sop;
import 'package:flutter_tests/widgets/utilities/NewInterlocutorContent.dart';

import 'package:graphql_flutter/graphql_flutter.dart';

class NewOwner extends StatefulWidget {
  NewOwner({Key key}) : super(key: key);

  @override
  _NewOwnerState createState() => new _NewOwnerState();
}

class _NewOwnerState extends State<NewOwner> {


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
        
        return NewInterlocutorContent(
          title: 'Nouveau propriétaire',
          interlocutor: sop.Owner(),
          onSave: (owner) async {
            print('runMutation');

            MultiSourceResult mutationResult = runMutation({
              "data": {
                "id": owner.id,
                "firstName": owner.firstName,
                "lastName": owner.lastName,
                "address": owner.address,
                "postalCode": owner.postalCode,
                "city": owner.city,
                "company": owner.company
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
                if (networkResult.data["createOwner"] == null) {
                  // TODO: show error
                }
                else if (networkResult.data["createOwner"] != null) {
                  Navigator.pop(context);
                  Navigator.popAndPushNamed(context, '/owners');// To refresh
                }
              }
            }
          },
        );
      }
    );
  }
}