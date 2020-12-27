import 'package:flutter/material.dart';

import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:uuid/uuid.dart';

import 'package:flutter_tests/models/StateOfPlay.dart' as sop;

import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/NewStateOfPlayContent.dart';


class NewStateOfPlay extends StatefulWidget {
  NewStateOfPlay({ Key key, this.stateOfPlayId, this.out }) : super(key: key);

  String stateOfPlayId;
  bool out;

  @override
  _NewStateOfPlayState createState() => new _NewStateOfPlayState();
}

class _NewStateOfPlayState extends State<NewStateOfPlay> {

  var uuid = Uuid(); 
  
  sop.StateOfPlay _stateOfPlay;
  
  sop.StateOfPlay _stateOfPlay2 = sop.StateOfPlay(
    date: DateTime.now(),
    owner: sop.Owner(
      firstName: 'Robert',
      lastName: 'Dupont',
      company: "SCI d'Investisseurs",
      address: '3 rue des Mésanges',
      postalCode: '75001',
      city: 'Paris'
    ),
    representative: sop.Representative(
      firstName: 'Elise',
      lastName: 'Lenotre',
      company: 'Marketin Immobilier',
      address: '3 rue des Mésanges',
      postalCode: '75001',
      city: 'Paris'
    ),
    tenants: [
      sop.Tenant(
        firstName: 'Emilie',
        lastName: 'Dupond',
        address: '3 rue des Mésanges',
        postalCode: '75001',
        city: 'Paris'
      ),
      sop.Tenant(
        firstName: 'Schmitt',
        lastName: 'Albert',
        address: '3 rue des Mésanges',
        postalCode: '75001',
        city: 'Paris'
      )
    ],
    entryExitDate: DateTime.now(),// To be changed
    property: sop.Property(
      address: '3 rue des Mésanges',
      postalCode: '75001',
      city: 'Paris',
      type: 'Appartement',
      reference: '3465',
      lot: '34',
      floor: 5,
      roomCount: 5,
      area: 108,
      annexes: 'balcon / cave / terasse',
      heatingType: 'chauffage collectif',
      hotWater: 'eau chaude collective'
    ),
    rooms: [
      sop.Room(
        name: 'Cuisine',
        decorations: [
          sop.Decoration(
            type: 'Porte',
            nature: 'Pas de porte',
            state: 'Bon',
            comments: 'Il manque la porte',
            images: [],
            newImages: [],
            imageIndexes: []
          ),
          sop.Decoration(
            type: 'Porte',
            nature: 'Pas de porte',
            state: 'Bon',
            comments: 'Il manque la porte',
            images: [],
            newImages: [],
            imageIndexes: []
          )
        ],
        electricities: [
          sop.Electricity(
            type: 'Interrupteur',
            quantity: 1,
            state: 'Neuf',
            comments: '',
            images: [],
            newImages: [],
            imageIndexes: []
          ),
          sop.Electricity(
            type: 'Prise électrique',
            quantity: 3,
            state: 'Neuf',
            comments: '',
            images: [],
            newImages: [],
            imageIndexes: []
          ),
        ],
        equipments: [
          sop.Equipment(
            type: 'Interrupteur',
            brandOrObject: 'Brandt',
            quantity: 1,
            state: 'Bon',
            comments: '',
            images: [],
            newImages: [],
            imageIndexes: []
          ),
          sop.Equipment(
            type: 'Interrupteur',
            brandOrObject: 'Brandt',
            quantity: 1,
            state: 'Bon',
            comments: '',
            images: [],
            newImages: [],
            imageIndexes: []
          ),
        ],
        generalAspect: sop.GeneralAspect(
          comments: 'Cuisine La cuisine équipée est en très bon état et complète Photo n°12',
        )
      ),
      sop.Room(
        name: 'Séjour / Salon',
        decorations: [
          sop.Decoration(
            type: 'Porte',
            nature: 'Pas de porte',
            state: 'Bon',
            comments: 'Il manque la porte',
            images: [],
            newImages: [],
            imageIndexes: []
          ),
          sop.Decoration(
            type: 'Porte',
            nature: 'Pas de porte',
            state: 'Bon',
            comments: 'Il manque la porte',
            images: [],
            newImages: [],
            imageIndexes: []
          )
        ],
        electricities: [
          sop.Electricity(
            type: 'Interrupteur',
            quantity: 1,
            state: 'Neuf',
            comments: '',
            images: [],
            newImages: [],
            imageIndexes: []
          ),
          sop.Electricity(
            type: 'Prise électrique',
            quantity: 3,
            state: 'Neuf',
            comments: '',
            images: [],
            newImages: [],
            imageIndexes: []
          ),
        ],
        equipments: [
          sop.Equipment(
            type: 'Interrupteur',
            brandOrObject: 'Brandt',
            quantity: 1,
            state: 'Bon',
            comments: '',
            images: [],
            newImages: [],
            imageIndexes: []
          ),
          sop.Equipment(
            type: 'Interrupteur',
            brandOrObject: 'Brandt',
            quantity: 1,
            state: 'Bon',
            comments: '',
            images: [],
            newImages: [],
            imageIndexes: []
          ),
        ],
        generalAspect: sop.GeneralAspect(
          comments: 'Cuisine La cuisine équipée est en très bon état et complète Photo n°12',
          image: 0
        ),
      )
    ],
    meters: [
      sop.Meter(
        type: 'Eau froide',
        location: 'Cuisine',
        dateOfSuccession: DateTime.now(),
        index: 4567,
        images: [],
        newImages: [],
        imageIndexes: []
      )
    ],
    keys: [
      sop.Key(
        type: 'Clé ascenceur',
        quantity: 1,
        comments: '',
        images: [],
        newImages: [],
        imageIndexes: []
      )
    ],
    insurance: sop.Insurance(
      company: 'Homestar',
      number: '123465468',
      dateStart: DateTime.now(),
      dateEnd: DateTime.now(),
    ),
    comments: "L'appartement vient d'être repeint",
    reserve: 'Le propritaire doit remettre une cuvette dans les toilettes',
    city: 'Mulhouse',
    documentHeader: "",
    documentEnd: "",
    images: []
  );

  void _showDialogLeave (context) async {
    await showDialog(
      context: context,
      child: AlertDialog(
        content: Text("Quitter la création de l'état des lieux ?"),
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

    Widget content2 =  Query(
      options: QueryOptions(
        documentNode: gql('''
          query user {
            user {
              id
              firstName
              lastName
              company
              documentHeader
              documentEnd
              address
              postalCode
              city
              logo
            }
          }
        ''')
      ),
      builder: (
        QueryResult result, {
        Refetch refetch,
        FetchMore fetchMore,
      }) {

        if (result.loading || result.data == null) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Nouvel état des lieux"),
            ),
            body: Center(child: CircularProgressIndicator())
          );
        }

        sop.User user;
        if (result.data != null && !result.loading) {
          print('NewStateOfPlay user: ' + result.data["user"].toString());
          user = sop.User.fromJSON(result.data["user"]);
        }

        return Mutation(
          options: MutationOptions(
            documentNode: gql('''
              mutation createStateOfPlay(\$data: CreateStateOfPlayInput!) {
                createStateOfPlay(data: \$data) {
                  id
                  fullAddress
                }
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
            QueryResult result,
          ) {
            // print('NewStateOfPlay: ' + widget.stateOfPlayId);

            if (_stateOfPlay == null) {
              print('new stateOfPlay: ' + user.logo.toString());
              _stateOfPlay = _stateOfPlay2;
              _stateOfPlay.out = widget.out;
              _stateOfPlay.documentHeader = user.documentHeader != null ? user.documentHeader : _stateOfPlay.documentHeader;
              _stateOfPlay.documentEnd = user.documentEnd != null ? user.documentEnd : _stateOfPlay.documentEnd;
              _stateOfPlay.logo = user.logo;
            }
            
            return NewStateOfPlayContent(
              title: "Nouvel état des lieux",
              onSave: () async {
                print("onSave");

                MultiSourceResult result = runMutation({
                  "data": {
                    "out": _stateOfPlay.out,
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
                        "images": [],
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
                        "images": [],
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
                        "images": [],
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
                    "meters": _stateOfPlay.meters.map((meter) => {
                      "type": meter.type,
                      "location": meter.location,
                      "index": meter.index,
                      "dateOfSuccession": meter.dateOfSuccession.toString(),
                      "images": [],
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
                    "keys": _stateOfPlay.keys.map((key) => {
                      "type": key.type,
                      "quantity": key.quantity,
                      "comments": key.comments,// TODO : complete data,
                      "images": [],
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
                  if (networkResult.exception.graphqlErrors.length > 0) { 
                    print("networkResult exception: " + networkResult.exception.graphqlErrors[0].toString());
                    print("networkResult exception: " + networkResult.exception.graphqlErrors[0].extensions.toString());
                  }
                  else
                    print("networkResult clientException: " + networkResult.exception.clientException.message);
                  return;//TODO: show error
                }
                print("");
                print("");
                
                Navigator.pop(context);
                Navigator.popAndPushNamed(context, "/state-of-plays");

              },
              stateOfPlay: _stateOfPlay,
            );
          }
        );
      }
    );

    Widget content;
    if (widget.stateOfPlayId != null) {
      content = Query(
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

          print('newStateOfPlay: ' + _stateOfPlay.toString() + ' ' + result.data.toString());
          if (_stateOfPlay == null && result.data != null) {
            print('load old StateOfPlay: ' + result.data["stateOfPlay"].toString());
            _stateOfPlay = sop.StateOfPlay.fromJSON(result.data["stateOfPlay"]);
            print('loaded stateOfPlay: ' + _stateOfPlay.toString());
          }

          if (result.hasException) {
            return Scaffold(
              appBar: AppBar(
                title: Text("Création d'un état des lieux"),
              ),
              body: Text(result.exception.toString())
            );
          }

          if (result.loading || result.data == null) {
            return Scaffold(
              appBar: AppBar(
                title: Text("Création d'un état des lieux"),
              ),
              body: CircularProgressIndicator()
            );
          }
          
          return content2;
        }
      );
    }

    return WillPopScope(
      onWillPop: () async {
        _showDialogLeave(context);
        return false;
      },
      child: widget.stateOfPlayId != null ? content : content2
    );
  }
}