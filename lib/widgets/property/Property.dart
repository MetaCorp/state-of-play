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
        title: Text('Property'),
      ),
      body: 
        Query(
          options: QueryOptions(
            documentNode: gql('''
            query User {
              user(data: { userId: "1" }) {
                id
                firstName
                lastName
                properties {
                  id
                  address
                  postalCode
                  city
                }
              }
            }
            ''')
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

            sop.User user = sop.User.fromJSON(result.data["user"]);

            print('parsed data: ' + user.toString());

            if (user.properties.length == 0) {
              return Text("no properties");
            }

            return ListView.separated(
              itemCount: user.properties.length,
              itemBuilder: (_, i) => ListTile(
                title: Text(user.properties[i].address + ', ' + user.properties[i].postalCode + ' ' + user.properties[i].city),
              ),
              separatorBuilder: (context, index) {
                return Divider();
              },
            );
          }
        )
    );
  }
}