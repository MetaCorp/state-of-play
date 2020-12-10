import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:flutter_tests/models/StateOfPlay.dart' as sop;
// import 'package:intl/intl.dart';// DateFormat

import 'package:flutter_tests/widgets/utilities/MyScaffold.dart';

class Tenants extends StatefulWidget {
  Tenants({Key key}) : super(key: key);

  @override
  _OwnersState createState() => _OwnersState();
}

// adb reverse tcp:9002 tcp:9002

class _OwnersState extends State<Tenants> {
  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      appBar: AppBar(
        title: Text('Mandataires'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => Navigator.pushNamed(context, '/search-tenants'),
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => Navigator.pushNamed(context, '/new-tenant'),
          ),
        ],
      ),
      body: 
        Query(
          options: QueryOptions(
            documentNode: gql('''
            query tenants {
              tenants {
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

            List<sop.Owner> tenants = (result.data["tenants"] as List).map((tenant) => sop.Owner.fromJSON(tenant)).toList();

            print('parsed data: ' + tenants.toString());

            if (tenants.length == 0) {
              return Text("no tenants");
            }

            return ListView.separated(
              itemCount: tenants.length,
              itemBuilder: (_, i) => ListTile(
                title: Text(tenants[i].firstName + ' ' + tenants[i].lastName),
                onTap: () => Navigator.pushNamed(context, '/tenant', arguments: { "tenantId": tenants[i].id }),
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