import 'package:flutter/material.dart';

import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:flutter_tests/models/StateOfPlay.dart' as sop;

import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/NewStateOfPlayContent.dart';

import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:uuid/uuid.dart';

class EditStateOfPlay extends StatefulWidget {
  EditStateOfPlay({ Key key, this.stateOfPlayId }) : super(key: key);

  String stateOfPlayId;

  @override
  _EditStateOfPlayState createState() => new _EditStateOfPlayState();
}

class _EditStateOfPlayState extends State<EditStateOfPlay> {
  
  var uuid = Uuid(); 

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
          QueryResult mutationUpdateResult,
        ) {
          
          return Query(
            options: QueryOptions(
              documentNode: gql('''
                query stateOfPlay(\$data: StateOfPlayInput!) {
                  stateOfPlay(data: \$data) {
                    id
                    out
                    property {
                      id
                      reference
                      address
                      postalCode
                      city
                      lot
                      floor
                      roomCount
                      area
                      heatingType
                      hotWater
                      type
                    }
                    owner {
                      id
                      firstName
                      lastName
                      company
                      address
                      postalCode
                      city
                    }
                    representative {
                      id
                      firstName
                      lastName
                      company
                      address
                      postalCode
                      city
                    }
                    tenants {
                      id
                      firstName
                      lastName
                      address
                      postalCode
                      city
                    }
                    rooms
                    meters
                    keys
                    insurance
                    comments
                    reserve
                    date
                    city
                    entryExitDate
                    documentHeader
                    documentEnd
                    pdf
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

              if (_stateOfPlay == null && result.data != null && result.data["stateOfPlay"] != null) {
                print('editStateOfPlay: ' + result.data["stateOfPlay"].toString());
                _stateOfPlay = sop.StateOfPlay.fromJSON(result.data["stateOfPlay"]);
              }

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
                  body: Center(child: CircularProgressIndicator())
                );
              }
              
              return Mutation(
                options: MutationOptions(
                  documentNode: gql('''
                    mutation deleteStateOfPlay(\$data: DeleteStateOfPlayInput!) {
                      deleteStateOfPlay(data: \$data)
                    }
                  '''), // this is the mutation string you just created
                  // you can update the cache based on results
                  update: (Cache cache, QueryResult result) {
                    return cache;
                  },
                  // or do something with the result.data on completion
                  onCompleted: (dynamic resultData) {
                    // print('onCompleted: ' + resultData.hasException);
                  },
                ),
                builder: (
                  RunMutation runDeleteMutation,
                  QueryResult mutationResult,
                ) {
                  
                  return NewStateOfPlayContent(
                    title: "Modification d'un état des lieux",
                    saveLoading: mutationUpdateResult.loading,
                    onSave: () async {
                      print("onSave");
                      MultiSourceResult result = runMutation({
                        "data": {
                          "id": _stateOfPlay.id,
                          "owner": {
                            "id": _stateOfPlay.owner.id,
                            "firstName": _stateOfPlay.owner.firstName,
                            "lastName": _stateOfPlay.owner.lastName,
                            "address": _stateOfPlay.owner.address,
                            "postalCode": _stateOfPlay.owner.postalCode,
                            "city": _stateOfPlay.owner.city,
                            "company": _stateOfPlay.owner.company
                          },
                          "representative": {
                            "id": _stateOfPlay.representative.id,
                            "firstName": _stateOfPlay.representative.firstName,
                            "lastName": _stateOfPlay.representative.lastName,
                            "address": _stateOfPlay.representative.address,
                            "postalCode": _stateOfPlay.representative.postalCode,
                            "city": _stateOfPlay.representative.city,
                            "company": _stateOfPlay.representative.company
                          },
                          "tenants": _stateOfPlay.tenants.map((tenant) => {
                            "id": tenant.id,
                            "firstName": tenant.firstName,
                            "lastName": tenant.lastName,
                            "address": tenant.address,
                            "postalCode": tenant.postalCode,
                            "city": tenant.city,
                          }).toList(),
                          "property": {
                            "id": _stateOfPlay.property.id,
                            "reference": _stateOfPlay.property.reference,
                            "address": _stateOfPlay.property.address,
                            "postalCode": _stateOfPlay.property.postalCode,
                            "city": _stateOfPlay.property.city,
                            "lot": _stateOfPlay.property.lot,
                            "floor": _stateOfPlay.property.floor,
                            "roomCount": _stateOfPlay.property.roomCount,
                            "area": _stateOfPlay.property.area,
                            "heatingType": _stateOfPlay.property.heatingType,
                            "hotWater": _stateOfPlay.property.hotWater,
                            "type": _stateOfPlay.property.type,
                          },
                          "rooms": _stateOfPlay.rooms.map((room) => {
                            "name": room.name,
                            "decorations": room.decorations.map((decoration) => {
                              "type": decoration.type,
                              "nature": decoration.nature,
                              "state": decoration.state,
                              "comments": decoration.comments,
                              "images": decoration.images,
                              "newImages": decoration.newImages.map((imageFile) {
                                var byteData = imageFile.readAsBytesSync();

                                return MultipartFile.fromBytes(
                                  'photo',
                                  byteData,
                                  filename: '${uuid.v1()}.jpg',
                                  contentType: MediaType("image", "jpg"),
                                );
                              }).toList()
                            }).toList(),
                            "electricities": room.electricities.map((electricity) => {
                              "type": electricity.type,
                              "quantity": electricity.quantity,
                              "state": electricity.state,
                              "comments": electricity.comments,
                              "images": electricity.images,
                              "newImages": electricity.newImages.map((imageFile) {
                                var byteData = imageFile.readAsBytesSync();

                                return MultipartFile.fromBytes(
                                  'photo',
                                  byteData,
                                  filename: '${uuid.v1()}.jpg',
                                  contentType: MediaType("image", "jpg"),
                                );
                              }).toList()
                            }).toList(),
                            "equipments": room.equipments.map((equipment) => {
                              "type": equipment.type,
                              "brandOrObject": equipment.brandOrObject,
                              "quantity": equipment.quantity,
                              "state": equipment.state,
                              "comments": equipment.comments,
                              "images": equipment.images,
                              "newImages": equipment.newImages.map((imageFile) {
                                var byteData = imageFile.readAsBytesSync();

                                return MultipartFile.fromBytes(
                                  'photo',
                                  byteData,
                                  filename: '${uuid.v1()}.jpg',
                                  contentType: MediaType("image", "jpg"),
                                );
                              }).toList()
                            }).toList()
                          }).toList(),
                          "keys": _stateOfPlay.keys.map((key) => {
                            "type": key.type,
                            "quantity": key.quantity,
                            "comments": key.comments,// TODO : complete data,
                            "images": key.images,
                            "newImages": key.newImages.map((imageFile) {
                              var byteData = imageFile.readAsBytesSync();

                              return MultipartFile.fromBytes(
                                'photo',
                                byteData,
                                filename: '${uuid.v1()}.jpg',
                                contentType: MediaType("image", "jpg"),
                              );
                            }).toList()
                          }).toList(),
                          "meters": _stateOfPlay.meters.map((meter) => {
                            "type": meter.type,
                            "location": meter.location,
                            "index": meter.index,
                            "dateOfSuccession": meter.dateOfSuccession.toString(),
                            "images": meter.images,
                            "newImages": meter.newImages.map((imageFile) {
                              var byteData = imageFile.readAsBytesSync();

                              return MultipartFile.fromBytes(
                                'photo',
                                byteData,
                                filename: '${uuid.v1()}.jpg',
                                contentType: MediaType("image", "jpg"),
                              );
                            }).toList()
                          }).toList(),
                          "comments": _stateOfPlay.comments,
                          "reserve": _stateOfPlay.reserve,
                          "insurance": {
                            "company": _stateOfPlay.insurance.company,
                            "number": _stateOfPlay.insurance.number,
                            "dateStart": _stateOfPlay.insurance.dateStart.toString(),
                            "dateEnd": _stateOfPlay.insurance.dateEnd.toString(),
                          },
                          "documentHeader": _stateOfPlay.documentHeader,
                          "documentEnd": _stateOfPlay.documentEnd,
                          "date": _stateOfPlay.date.toString(),
                          "city": _stateOfPlay.city.toString(),
                          "entryExitDate": _stateOfPlay.entryExitDate.toString(),
                        }
                      });

                      QueryResult networkResult = await result.networkResult;

                      print("networkResult hasException: " + networkResult.hasException.toString());
                      if (networkResult.hasException) {
                        if (networkResult.exception.graphqlErrors.length > 0)
                          print("networkResult exception: " + networkResult.exception.graphqlErrors[0].toString());
                        else
                          print("networkResult clientException: " + networkResult.exception.clientException.message);
                        return;//TODO: show error
                      }
                      print("");
                      print("");
                      
                      Navigator.pop(context);
                      Navigator.popAndPushNamed(context, "/state-of-plays");

                    },
                    onDelete: () async {
                      print('runDeleteMutation');

                      MultiSourceResult mutationResult = runDeleteMutation({
                        "data": {
                          "stateOfPlayId": widget.stateOfPlayId,
                        }
                      });
                      QueryResult networkResult = await mutationResult.networkResult;

                      if (networkResult.hasException) {
                        print('networkResult.hasException: ' + networkResult.hasException.toString());
                        if (networkResult.exception.clientException != null)
                          print('networkResult.exception.clientException: ' + networkResult.exception.clientException.toString());
                        else
                          print('networkResult.exception.graphqlErrors[0]: ' + networkResult.exception.graphqlErrors[0].toString());
                      }
                      else {
                        print('queryResult data: ' + networkResult.data.toString());
                        if (networkResult.data != null) {
                          if (networkResult.data["deleteStateOfPlay"] == null) {
                            // TODO: show error
                          }
                          else if (networkResult.data["deleteStateOfPlay"] != null) {
                            Navigator.pop(context);
                            Navigator.popAndPushNamed(context, '/state-of-plays');// To refresh
                          }
                        }
                      }
                    },
                    stateOfPlay: _stateOfPlay
                  );
                }
              );
            }
          );
        }
      )
    );
  }
}