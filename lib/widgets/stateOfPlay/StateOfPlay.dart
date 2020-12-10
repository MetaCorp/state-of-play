import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:flutter_tests/models/StateOfPlay.dart' as sop;
// import 'package:intl/intl.dart';// DateFormat

import 'package:flutter_tests/widgets/utilities/MyScaffold.dart';

class StateOfPlay extends StatefulWidget {
  StateOfPlay({Key key, this.stateOfPlayId}) : super(key: key);

  final String stateOfPlayId;
  
  @override
  _PropertyState createState() => _PropertyState();
}

// adb reverse tcp:9002 tcp:9002

class _PropertyState extends State<StateOfPlay> {

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      appBar: AppBar(
        title: Text('Propriété'),
      ),
      body: 
        Query(
          options: QueryOptions(
            documentNode: gql('''
            query stateOfPlay(\$data: PropertyInput!) {
              stateOfPlay(data: \$data) {
                id
                address
                postalCode
                city
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

            sop.StateOfPlay stateOfPlay = sop.StateOfPlay.fromJSON(result.data["stateOfPlay"]);

            print('parsed data: ' + stateOfPlay.toString());

            return Text(stateOfPlay.id);
          }
        )
    );
  }
}