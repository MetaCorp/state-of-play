import 'package:flutter/material.dart';

import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:flutter_tests/models/StateOfPlay.dart' as sop;

import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/NewStateOfPlayContent.dart';


class EditStateOfPlay extends StatefulWidget {
  EditStateOfPlay({ Key key, this.stateOfPlayId }) : super(key: key);

  String stateOfPlayId;

  @override
  _EditStateOfPlayState createState() => new _EditStateOfPlayState();
}

class _EditStateOfPlayState extends State<EditStateOfPlay> {

  sop.StateOfPlay _stateOfPlay;
  
  void _showDialogLeave (context) async {
    await showDialog(
      context: context,
      child: AlertDialog(
        content: Text("Quitter la modification de l'état des lieux ?"),
        actions: [
          new FlatButton(
            child: Text('ANNULER'),
            onPressed: () {
              Navigator.pop(context);
            }
          ),
          new FlatButton(
            child: Text('QUITTER'),
            onPressed: () async {
              Navigator.pop(context);
              Navigator.pop(context);
            }
          )
        ],
      )
    );
  }

  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _showDialogLeave(context);
        return false;
      },
      child: Mutation(
        options: MutationOptions(
          documentNode: gql('''
            mutation updateStateOfPlay(\$data: UpdateStateOfPlayInput!) {
              updateStateOfPlay(data: \$data)
            }
          '''),
          update: (Cache cache, QueryResult result) {
            return cache;
          },
          onCompleted: (dynamic resultData) {
          },
        ),
        builder: (
          RunMutation runMutation,
          QueryResult mutationResult,
        ) {
          
          return Query(
            options: QueryOptions(
              documentNode: gql('''
                query stateOfPlay(\$data: StateOfPlayInput!) {
                  stateOfPlay(data: \$data) {
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
                    rooms
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

              if (_stateOfPlay == null && result.data != null)
                _stateOfPlay = sop.StateOfPlay.fromJSON(result.data["stateOfPlay"]);

              if (result.hasException) {
                return Scaffold(
                  appBar: AppBar(
                    title: Text("Modification d'un état des lieux"),
                  ),
                  body: Text(result.exception.toString())
                );
              }

              if (result.loading || result.data == null) {
                return Scaffold(
                  appBar: AppBar(
                    title: Text("Modification d'un état des lieux"),
                  ),
                  body: CircularProgressIndicator()
                );
              }
              
              return NewStateOfPlayContent(
                title: "Modification d'un état des lieux",
                onSave: () async {
                  print("onSave");
                  MultiSourceResult result = runMutation({
                    "data": {
                      "owner": {
                        "id": _stateOfPlay.owner.id,
                        "firstName": _stateOfPlay.owner.firstName,
                        "lastName": _stateOfPlay.owner.lastName,
                      },
                      "representative": {
                        "id": _stateOfPlay.representative.id,
                        "firstName": _stateOfPlay.representative.firstName,
                        "lastName": _stateOfPlay.representative.lastName,
                      },
                      "tenants": _stateOfPlay.tenants.map((tenant) => {
                        "id": tenant.id,
                        "firstName": tenant.firstName,
                        "lastName": tenant.lastName,
                      }).toList(),
                      "property": {
                        "id": _stateOfPlay.property.id,
                        "address": _stateOfPlay.property.address,
                        "postalCode": _stateOfPlay.property.postalCode,
                        "city": _stateOfPlay.property.city,
                      },
                      "rooms": _stateOfPlay.rooms.map((room) => {
                        "name": room.name,
                        "decorations": room.decorations.map((decoration) => {
                          "type": decoration.type,
                          "nature": decoration.nature,
                          "state": decoration.state,
                          "comment": decoration.comment
                        })
                      })
                    }
                  });

                  QueryResult networkResult = await result.networkResult;

                  print("networkResult hasException: " + networkResult.hasException.toString());
                  if (networkResult.hasException) {
                    if (networkResult.exception.graphqlErrors.length > 0)
                      print("networkResult exception: " + networkResult.exception.graphqlErrors[0].toString());
                    else
                      print("networkResult clientException: " + networkResult.exception.clientException.message);
                  }
                  print("");
                  print("");
                  
                  Navigator.pop(context);
                  Navigator.popAndPushNamed(context, "/state-of-play", arguments: { "stateOfPlayId": widget.stateOfPlayId });

                },
                stateOfPlay: _stateOfPlay
              );
            }
          );
        }
      )
    );
  }
}