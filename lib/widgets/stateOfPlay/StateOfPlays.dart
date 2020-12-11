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
            query stateOfPlays {
              stateOfPlays {
                id
                property {
                  id
                  address
                  postalCode
                  city
                }
                owner {
                  id
                  firstName
                  lastName
                }
                tenants {
                  id
                  firstName
                  lastName
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

            List<sop.StateOfPlay> stateOfPlays = (result.data["stateOfPlays"] as List).map((stateOfPlay) => sop.StateOfPlay.fromJSON(stateOfPlay)).toList();
            print('stateOfPlays length: ' + stateOfPlays.length.toString());

            if (stateOfPlays.length == 0) {
              return Text("no stateOfplays");
            }


            return ListView.separated(
              itemCount: stateOfPlays.length,
              itemBuilder: (_, i)  {
                String tenantsString = "";

                for (var j = 0; j < stateOfPlays[i].tenants.length; j++) {
                  tenantsString += stateOfPlays[i].tenants[j].firstName + ' ' + stateOfPlays[i].tenants[j].lastName;
                  if (j < stateOfPlays[i].tenants.length - 1)
                    tenantsString += ', ';
                }

                return ListTile(
                  title: Text("Propriétaire: " + stateOfPlays[i].owner.firstName + " " + stateOfPlays[i].owner.lastName),
                  subtitle: Text("Locataire" + (stateOfPlays[i].tenants.length > 1 ? "s" : "") + ": " + tenantsString),
                  onTap: () => Navigator.pushNamed(context, "/state-of-play", arguments: { "stateOfPlayId": stateOfPlays[i].id }),
                );
              },
              separatorBuilder: (context, index) {
                return Divider();
              },
            );
          }
        )
    );
  }
}