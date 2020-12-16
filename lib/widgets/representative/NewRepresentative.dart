import 'package:flutter/material.dart';
import 'package:flutter_tests/models/StateOfPlay.dart' as sop;
import 'package:flutter_tests/widgets/utilities/NewInterlocutorContent.dart';

import 'package:graphql_flutter/graphql_flutter.dart';

class NewRepresentative extends StatefulWidget {
  NewRepresentative({Key key}) : super(key: key);

  @override
  _NewRepresentativeState createState() => new _NewRepresentativeState();
}

class _NewRepresentativeState extends State<NewRepresentative> {


  @override
  Widget build(BuildContext context) {
    return Mutation(
      options: MutationOptions(
        documentNode: gql('''
          mutation createRepresentative(\$data: CreateRepresentativeInput!) {
            createRepresentative(data: \$data) {
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
          title: 'Nouveau mandataire',
          interlocutor: sop.Representative(),
          onSave: (representative) async {
            print('runMutation');

            MultiSourceResult mutationResult = runMutation({
              "data": {
                "id": representative.id,
                "firstName": representative.firstName,
                "lastName": representative.lastName,
                "address": representative.address,
                "postalCode": representative.postalCode,
                "city": representative.city,
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
                if (networkResult.data["createRepresentative"] == null) {
                  // TODO: show error
                }
                else if (networkResult.data["createRepresentative"] != null) {
                  Navigator.pop(context);
                  Navigator.popAndPushNamed(context, '/representatives');// To refresh
                }
              }
            }
          },
        );
      }
    );
  }
}