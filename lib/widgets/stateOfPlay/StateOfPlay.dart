import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:flutter_tests/models/StateOfPlay.dart' as sop;
// import 'package:intl/intl.dart';// DateFormat

class StateOfPlay extends StatefulWidget {
  StateOfPlay({ Key key, this.stateOfPlayId }) : super(key: key);

  final String stateOfPlayId;
  
  @override
  _PropertyState createState() => _PropertyState();
}

// adb reverse tcp:9002 tcp:9002

class _PropertyState extends State<StateOfPlay> {

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        Navigator.popAndPushNamed(context, '/state-of-plays');
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('État des lieux'),
          actions: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => Navigator.pushNamed(context, '/edit-state-of-play', arguments: { "stateOfPlayId": widget.stateOfPlayId }),
            )
          ],
        ),
        body: 
          Query(
            options: QueryOptions(
              documentNode: gql('''
              query stateOfPlay(\$data: StateOfPlayInput!) {
                stateOfPlay(data: \$data) {
                  id
                  property {
                    address
                    postalCode
                    city
                  }
                  owner {
                    id
                    firstName
                    lastName
                  }
                  representative {
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
              '''),
              variables: {
                "data": {
                  "stateOfPlayId": widget.stateOfPlayId
                }
              }
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

              sop.StateOfPlay stateOfPlay = sop.StateOfPlay.fromJSON(result.data["stateOfPlay"]);

              debugPrint('parsed data: ' + stateOfPlay.toString());

              return Text(stateOfPlay.id);
            }
          )
      ),
    );
  }
}