import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:flutter_tests/models/StateOfPlay.dart' as sop;
import 'package:intl/intl.dart';// DateFormat

class Properties extends StatefulWidget {
  Properties({Key key}) : super(key: key);

  @override
  _PropertiesState createState() => _PropertiesState();
}

// adb reverse tcp:9002 tcp:9002

class _PropertiesState extends State<Properties> {
  @override
  Widget build(BuildContext context) {
    return
    Scaffold(
      appBar: AppBar(
        title: Text('Properties'),
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

            sop.User user = sop.User.fromJSON(result.data["user"]);

            debugPrint('parsed data: ' + user.toString());

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