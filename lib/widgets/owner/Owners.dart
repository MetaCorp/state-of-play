import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:flutter_tests/models/StateOfPlay.dart' as sop;
// import 'package:intl/intl.dart';// DateFormat

import 'package:flutter_tests/widgets/utilities/MyScaffold.dart';

class Owners extends StatefulWidget {
  Owners({Key key}) : super(key: key);

  @override
  _OwnersState createState() => _OwnersState();
}

// adb reverse tcp:9002 tcp:9002

class _OwnersState extends State<Owners> {
  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      appBar: AppBar(
        title: Text('Propriétaires'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => Navigator.pushNamed(context, '/search-owners'),
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => Navigator.pushNamed(context, '/new-owner'),
          ),
        ],
      ),
      body: 
        Query(
          options: QueryOptions(
            documentNode: gql('''
            query owners {
              owners {
                id
                firstName
                lastName
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

            List<sop.Owner> owners = (result.data["owners"] as List).map((owner) => sop.Owner.fromJSON(owner)).toList();

            print('parsed data: ' + owners.toString());

            if (owners.length == 0) {
              return Text("no owners");
            }

            return ListView.separated(
              itemCount: owners.length,
              itemBuilder: (_, i) => ListTile(
                title: Text(owners[i].firstName + ' ' + owners[i].lastName),
                onTap: () => Navigator.pushNamed(context, '/owner', arguments: { "ownerId": owners[i].id }),
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