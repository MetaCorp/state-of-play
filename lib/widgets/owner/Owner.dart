import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:flutter_tests/models/StateOfPlay.dart' as sop;
// import 'package:intl/intl.dart';// DateFormat

import 'package:flutter_tests/widgets/utilities/MyScaffold.dart';

class Owner extends StatefulWidget {
  Owner({Key key}) : super(key: key);

  @override
  _OwnerState createState() => _OwnerState();
}

// adb reverse tcp:9002 tcp:9002

class _OwnerState extends State<Owner> {
  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      appBar: AppBar(
        title: Text('Propriétaire'),
      ),
      body: 
        Query(
          options: QueryOptions(
            documentNode: gql('''
            query owner(\$data: OwnerInput!) {
              owner(data: \$data) {
                id
                firstName
                lastName
              }
            }
            '''),
            variables: {
              "data": {
                "ownerId": "1"// TODO: bind to args
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

            sop.Owner owner = sop.Owner.fromJSON(result.data["owner"]);

            print('parsed data: ' + owner.toString());

            return Text(owner.id);
          }
        )
    );
  }
}