import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:flutter_tests/models/StateOfPlay.dart' as sop;
// import 'package:intl/intl.dart';// DateFormat

class Representative extends StatefulWidget {
  Representative({Key key}) : super(key: key);

  @override
  _RepresentativeState createState() => _RepresentativeState();
}

// adb reverse tcp:9002 tcp:9002

class _RepresentativeState extends State<Representative> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mandataire'),
      ),
      body: 
        Query(
          options: QueryOptions(
            documentNode: gql('''
            query representative(\$data: RepresentativeInput!) {
              representative(data: \$data) {
                id
                firstName
                lastName
              }
            }
            '''),
            variables: {
              "data": {
                "representativeId": "1"// TODO: bind to args
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

            sop.Representative representative = sop.Representative.fromJSON(result.data["representative"]);

            print('parsed data: ' + representative.toString());

            return Text(representative.id);
          }
        )
    );
  }
}