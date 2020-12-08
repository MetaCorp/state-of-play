import 'package:flutter/material.dart';
import 'package:flutter_tests/main2.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:flutter_tests/models/StateOfPlay.dart' as sop;
// import 'package:intl/intl.dart';// DateFormat

import 'package:flutter_tests/widgets/utilities/MyScaffold.dart';

class StateOfPlay extends StatefulWidget {
  StateOfPlay({ Key key, @required this.stateOfPlayId }) : super(key: key);

  final String stateOfPlayId;

  @override
  _StateOfPlayState createState() => _StateOfPlayState();
}

// adb reverse tcp:9002 tcp:9002

class _StateOfPlayState extends State<StateOfPlay> {
  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      appBar: AppBar(
        title: Text('État des lieux : ' + widget.stateOfPlayId),
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
                stateOfPlays {
                  id
                  property {
                    id
                    address
                    postalCode
                    city
                  }
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
            print('stateOfPlays length: ' + user.stateOfPlays.length.toString());

            if (user.stateOfPlays.length == 0) {
              return Text("no stateOfplays");
            }

            return ListView.separated(
              itemCount: user.stateOfPlays.length,
              itemBuilder: (_, i) => ListTile(
                title: Text(user.stateOfPlays[i].property.address + ', ' + user.stateOfPlays[i].property.postalCode + ' ' + user.stateOfPlays[i].property.city),
                // subtitle: Text(DateFormat('dd/MM/yyyy').format(user.stateOfPlays[i].date)) ,
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