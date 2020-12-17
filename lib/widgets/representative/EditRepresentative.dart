import 'package:flutter/material.dart';
import 'package:flutter_tests/models/StateOfPlay.dart' as sop;
import 'package:flutter_tests/widgets/utilities/NewInterlocutorContent.dart';

import 'package:graphql_flutter/graphql_flutter.dart';

class EditRepresentative extends StatefulWidget {
  EditRepresentative({ Key key, this.representativeId }) : super(key: key);

  final String representativeId;

  @override
  _EditRepresentativeState createState() => new _EditRepresentativeState();
}

class _EditRepresentativeState extends State<EditRepresentative> {

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
            company
            address
            postalCode
            city
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

        sop.Representative representative;
        if (result.data != null) {
          representative = sop.Representative.fromJSON(result.data["representative"]);
        }

        if (result.data == null || result.loading)
          return Center(child: CircularProgressIndicator());
        
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
            RunMutation runUpdateMutation,
            QueryResult mutationResult,
          ) {
            
            return Mutation(
              options: MutationOptions(
                documentNode: gql('''
                  mutation deleteRepresentative(\$data: DeleteRepresentativeInput!) {
                    deleteRepresentative(data: \$data)
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
                RunMutation runDeleteMutation,
                QueryResult mutationResult,
              ) {
                
                return NewInterlocutorContent(
                  title: 'Éditer un mandataire',
                  interlocutor: representative,
                  onSave: (representative) async {
                    print('runUpdateMutation');

                    MultiSourceResult mutationResult = runUpdateMutation({
                      "data": {
                        "id": representative.id,
                        "firstName": representative.firstName,
                        "lastName": representative.lastName,
                        "address": representative.address,
                        "postalCode": representative.postalCode,
                        "city": representative.city,
                        "company": representative.company
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
                  onDelete: () async {
                    print('runDeleteMutation');

                    MultiSourceResult mutationResult = runDeleteMutation({
                      "data": {
                        "representativeId": representative.id,
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
                        if (networkResult.data["deleteRepresentative"] == null) {
                          // TODO: show error
                        }
                        else if (networkResult.data["deleteRepresentative"] != null) {
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
        );
      }
    );
  }
}