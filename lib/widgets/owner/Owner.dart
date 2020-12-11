import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:flutter_tests/models/StateOfPlay.dart' as sop;
// import 'package:intl/intl.dart';// DateFormat

class Owner extends StatefulWidget {
  Owner({ Key key, this.ownerId }) : super(key: key);

  final String ownerId;

  @override
  _OwnerState createState() => _OwnerState();
}

// adb reverse tcp:9002 tcp:9002

class _OwnerState extends State<Owner> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        Navigator.popAndPushNamed(context, '/owners');
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Propriétaire'),
          actions: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => Navigator.pushNamed(context, '/edit-owner', arguments: { "ownerId": widget.ownerId }),
            )
          ],
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
                  "ownerId": widget.ownerId
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
      ),
    );
  }
}