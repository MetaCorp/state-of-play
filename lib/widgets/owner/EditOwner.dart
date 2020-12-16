import 'package:flutter/material.dart';
import 'package:flutter_tests/models/StateOfPlay.dart' as sop;
import 'package:flutter_tests/widgets/utilities/NewInterlocutorContent.dart';

import 'package:graphql_flutter/graphql_flutter.dart';

class EditOwner extends StatefulWidget {
  EditOwner({ Key key, this.ownerId }) : super(key: key);

  final String ownerId;

  @override
  _EditOwnerState createState() => new _EditOwnerState();
}

class _EditOwnerState extends State<EditOwner> {

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

        sop.Owner owner;
        if (result.data != null) {
          owner = sop.Owner.fromJSON(result.data["owner"]);
        }

        if (result.data == null || result.loading)
          return Center(child: CircularProgressIndicator());
        
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
            
            return NewInterlocutorContent(
              title: 'Éditer un mandataire',
              interlocutor: owner,
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
            );
          }
        );
      }
    );
  }
}