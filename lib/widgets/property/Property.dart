import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:flutter_tests/models/StateOfPlay.dart' as sop;
// import 'package:intl/intl.dart';// DateFormat

class Property extends StatefulWidget {
  Property({ Key key, this.propertyId }) : super(key: key);

  final String propertyId;

  @override
  _PropertyState createState() => _PropertyState();
}

// adb reverse tcp:9002 tcp:9002

class _PropertyState extends State<Property> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        Navigator.popAndPushNamed(context, '/properties');
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Propriété'),
          actions: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => Navigator.pushNamed(context, '/edit-property', arguments: { "propertyId": widget.propertyId }),
            )
          ],
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
                  "propertyId": widget.propertyId
                }
              }
            ),
            builder: (
              QueryResult result, {
              Refetch refetch,
              FetchMore fetchMore,
            }) {
              debugPrint('loading: ' + result.loading.toString());
              debugPrint('exception: ' + result.exception.toString());
              debugPrint('data: ' + result.data.toString());
              debugPrint('');

              if (result.hasException) {
                return Text(result.exception.toString());
              }

              if (result.loading || result.data == null) {
                return CircularProgressIndicator();
              }

              sop.Property property = sop.Property.fromJSON(result.data["property"]);

              debugPrint('parsed data: ' + property.toString());

              return Text(property.id);
            }
          )
      ),
    );
  }
}