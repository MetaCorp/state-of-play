import 'package:flutter/material.dart';
import 'package:flutter_tests/models/StateOfPlay.dart' as sop;
import 'package:flutter_tests/widgets/property/NewPropertyContent.dart';

import 'package:graphql_flutter/graphql_flutter.dart';

class NewProperty extends StatefulWidget {
  NewProperty({Key key}) : super(key: key);

  @override
  _NewPropertyState createState() => new _NewPropertyState();
}

class _NewPropertyState extends State<NewProperty> {


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
          // debugPrint('onCompleted: ' + resultData.hasException);
        },
      ),
      builder: (
        RunMutation runMutation,
        QueryResult result,
      ) {
        
        return NewPropertyContent(
          title: 'Nouvelle propriété',
          saveLoading: result.loading,
          property: sop.Property(
            reference: "000",
            address: "42 rue du Test",
            postalCode: "75001",
            city: "Paris",
            lot: "000",
            floor: 4,
            roomCount: 4,
            area: 60,
            heatingType: "test",
            hotWater: "test",
            type: "Maison"
          ),
          onSave: (property) async {
            debugPrint('runMutation');

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
                "type": property.type,
              }
            });
            QueryResult networkResult = await mutationResult.networkResult;

            if (networkResult.hasException) {
              debugPrint('networkResult.hasException: ' + networkResult.hasException.toString());
              if (networkResult.exception.clientException != null)
                debugPrint('networkResult.exception.clientException: ' + networkResult.exception.clientException.toString());
              else
                debugPrint('networkResult.exception.graphqlErrors[0]: ' + networkResult.exception.graphqlErrors[0].toString());
            }
            else {
              debugPrint('queryResult data: ' + networkResult.data.toString());
              if (networkResult.data != null) {
                if (networkResult.data["createProperty"] == null) {
                  // TODO: show error
                }
                else if (networkResult.data["createProperty"] != null) {
                  Navigator.pop(context);
                  Navigator.popAndPushNamed(context, '/properties');// To refresh
                }
              }
            }
          },
        );
      }
    );
  }
}