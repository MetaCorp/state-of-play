import 'package:flutter/material.dart';
import 'package:flutter_tests/models/StateOfPlay.dart' as sop;
import 'package:flutter_tests/widgets/property/NewPropertyContent.dart';

import 'package:graphql_flutter/graphql_flutter.dart';

class EditProperty extends StatefulWidget {
  EditProperty({ Key key, this.propertyId }) : super(key: key);

  final String propertyId;

  @override
  _EditPropertyState createState() => new _EditPropertyState();
}

class _EditPropertyState extends State<EditProperty> {

  @override
  Widget build(BuildContext context) {

    return Query(
      options: QueryOptions(
        documentNode: gql('''
        query property(\$data: PropertyInput!) {
          property(data: \$data) {
            id
            reference
            address
            postalCode
            city
            lot
            floor
            roomCount
            area
            heatingType
            hotWater
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

        sop.Property property;
        if (result.data != null) {
          property = sop.Property.fromJSON(result.data["property"]);
        }

        if (result.data == null || result.loading)
          return Center(child: CircularProgressIndicator());
        
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
            
            return NewPropertyContent(
              title: 'Éditer une propriété',
              property: property,
              onSave: (property) async {
                print('runMutation');

                MultiSourceResult mutationResult = runMutation({
                  "data": {
                    "id": property.id,
                    "reference": property.reference,
                    "address": property.address,
                    "postalCode": property.postalCode,
                    "city": property.city,
                    "lot": property.lot,
                    "floor": property.floor,
                    "roomCount": property.roomCount,
                    "area": property.area,
                    "heatingType": property.heatingType,
                    "hotWater": property.hotWater,
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
            );
          }
        );
      }
    );
  }
}