import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:flutter_tests/models/StateOfPlay.dart' as sop;
// import 'package:intl/intl.dart';// DateFormat

import 'package:flutter_tests/widgets/utilities/MyScaffold.dart';

class StateOfPlays extends StatefulWidget {
  StateOfPlays({Key key}) : super(key: key);

  @override
  _StateOfPlaysState createState() => _StateOfPlaysState();
}

// adb reverse tcp:9002 tcp:9002

class _StateOfPlaysState extends State<StateOfPlays> {
  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      appBar: AppBar(
        title: Text('États des lieux'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => Navigator.pushNamed(context, '/search-state-of-plays'),
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => Navigator.pushNamed(context, '/new-state-of-play'),
          ),
        ],
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
                onTap: () => Navigator.pushNamed(context, '/state-of-play', arguments: { "stateOfPlayId": user.stateOfPlays[i].id }),
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