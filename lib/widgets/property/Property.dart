import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:flutter_tests/models/StateOfPlay.dart' as sop;
// import 'package:intl/intl.dart';// DateFormat

import 'package:flutter_tests/widgets/utilities/MyScaffold.dart';

class Property extends StatefulWidget {
  Property({Key key}) : super(key: key);

  @override
  _PropertyState createState() => _PropertyState();
}

// adb reverse tcp:9002 tcp:9002

class _PropertyState extends State<Property> {
  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      appBar: AppBar(
        title: Text('Propriété'),
      ),
      body: 
        Query(
          options: QueryOptions(
            documentNode: gql('''
            query property(\$data: PropertyInput!) {
              property(data: \$data) {
                id
                address
                postalCode
                city
              }
            }
            '''),
            variables: {
              "data": {
                "propertyId": "1"// TODO: bind to args
              }
            }
          ),
          builder: (
            QueryResult result, {
            Refetch refetch,
            FetchMore fetchMore,
          }) {
            print('loading: ' + result.loading.toString());
            print('exception: ' + result.exception.toString());
            print('data: ' + result.data.toString());
            print('');

            if (result.hasException) {
              return Text(result.exception.toString());
            }

            if (result.loading || result.data == null) {
              return CircularProgressIndicator();
            }

            sop.Property property = sop.Property.fromJSON(result.data["property"]);

            print('parsed data: ' + property.toString());

            return Text(property.id);
          }
        )
    );
  }
}