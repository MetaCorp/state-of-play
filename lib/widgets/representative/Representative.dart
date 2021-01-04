import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:flutter_tests/models/StateOfPlay.dart' as sop;
// import 'package:intl/intl.dart';// DateFormat

class Representative extends StatefulWidget {
  Representative({ Key key, this.representativeId }) : super(key: key);

  final String representativeId;

  @override
  _RepresentativeState createState() => _RepresentativeState();
}

// adb reverse tcp:9002 tcp:9002

class _RepresentativeState extends State<Representative> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        Navigator.popAndPushNamed(context, '/representatives');
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Mandataire'),
          actions: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => Navigator.pushNamed(context, '/edit-representative', arguments: { "representativeId": widget.representativeId }),
            )
          ],
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
                  "representativeId": widget.representativeId
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

              sop.Representative representative = sop.Representative.fromJSON(result.data["representative"]);

              debugPrint('parsed data: ' + representative.toString());

              return Text(representative.id);
            }
          )
      ),
    );
  }
}