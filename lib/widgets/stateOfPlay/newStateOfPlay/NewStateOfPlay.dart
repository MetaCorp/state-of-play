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
    entryDate: DateTime.now(),// To be changed
    property: sop.Property(
      address: '3 rue des Mésanges',
      postalCode: '75001',
      city: 'Paris',
      type: 'appartement',
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
            imageFiles: []
          ),
          sop.Decoration(
            type: 'Porte',
            nature: 'Pas de porte',
            state: 'Bon',
            comments: 'Il manque la porte',
            imageFiles: []
          )
        ],
        electricities: [
          sop.Electricity(
            type: 'Interrupteur',
            quantity: 1,
            state: 'Neuf',
            comments: '',
            photo: 0
          ),
          sop.Electricity(
            type: 'Prise électrique',
            quantity: 3,
            state: 'Neuf',
            comments: '',
            photo: 0
          ),
        ],
        equipments: [
          sop.Equipment(
            type: 'Interrupteur',
            brandOrObject: 'Brandt',
            quantity: 1,
            state: 'Bon',
            comments: '',
            photo: 0
          ),
          sop.Equipment(
            type: 'Interrupteur',
            brandOrObject: 'Brandt',
            quantity: 1,
            state: 'Bon',
            comments: '',
            photo: 0
          ),
        ],
        generalAspect: sop.GeneralAspect(
          comments: 'Cuisine La cuisine équipée est en très bon état et complète Photo n°12',
          photo: 0
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
            imageFiles: []
          ),
          sop.Decoration(
            type: 'Porte',
            nature: 'Pas de porte',
            state: 'Bon',
            comments: 'Il manque la porte',
            imageFiles: []
          )
        ],
        electricities: [
          sop.Electricity(
            type: 'Interrupteur',
            quantity: 1,
            state: 'Neuf',
            comments: '',
            photo: 0
          ),
          sop.Electricity(
            type: 'Prise électrique',
            quantity: 3,
            state: 'Neuf',
            comments: '',
            photo: 0
          ),
        ],
        equipments: [
          sop.Equipment(
            type: 'Interrupteur',
            brandOrObject: 'Brandt',
            quantity: 1,
            state: 'Bon',
            comments: '',
            photo: 0
          ),
          sop.Equipment(
            type: 'Interrupteur',
            brandOrObject: 'Brandt',
            quantity: 1,
            state: 'Bon',
            comments: '',
            photo: 0
          ),
        ],
        generalAspect: sop.GeneralAspect(
          comments: 'Cuisine La cuisine équipée est en très bon état et complète Photo n°12',
          photo: 0
        ),
      )
    ],
    meters: [
      sop.Meter(
        type: 'Eau froide',
        location: 'Cuisine',
        dateOfSuccession: DateTime.now(),
        index: 4567,
        photo: 0
      )
    ],
    keys: [
      sop.Key(
        type: 'Clé ascenceur',
        count: 1,
        comments: '',
        photo: 0
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
    date: DateTime.now()
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

    Widget content2 = Mutation(
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
          print('new stateOfPlay');
          _stateOfPlay = _stateOfPlay2;
          _stateOfPlay.out = widget.out;
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
                    "comments": decoration.comments,
                    "images": decoration.imageFiles.map((imageFile) {
                      print('imageFile');
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
                    "comments": electricity.comments
                  }).toList(),
                  "equipments": room.equipments.map((equipment) => {
                    "type": equipment.type,
                    "brandOrObject": equipment.brandOrObject,
                    "quantity": equipment.quantity,
                    "state": equipment.state,
                    "comments": equipment.comments
                  }).toList()
                }).toList(),
                "meters": _stateOfPlay.meters.map((meter) => {
                  "type": meter.type,
                  "location": meter.location,
                  "index": meter.index,// TODO : complete data
                }).toList(),
                "comments": _stateOfPlay.comments,
                "reserve": _stateOfPlay.reserve,
                "insurance": {
                  "company": _stateOfPlay.insurance.company,
                  "number": _stateOfPlay.insurance.number
                }
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
          stateOfPlay: _stateOfPlay
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