import 'package:flutter/material.dart';

import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:flutter_tests/models/StateOfPlay.dart' as sop;

import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/NewStateOfPlayContent.dart';


class NewStateOfPlay extends StatefulWidget {
  NewStateOfPlay({Key key}) : super(key: key);

  @override
  _NewStateOfPlayState createState() => new _NewStateOfPlayState();
}

class _NewStateOfPlayState extends State<NewStateOfPlay> {
  
  final sop.StateOfPlay _stateOfPlay = sop.StateOfPlay(
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
            state: sop.States.good,
            comment: 'Il manque la porte',
            photo: 0
          ),
          sop.Decoration(
            type: 'Porte',
            nature: 'Pas de porte',
            state: sop.States.good,
            comment: 'Il manque la porte',
            photo: 0
          )
        ],
        electricsAndHeatings: [
          sop.ElectricAndHeating(
            type: 'Interrupteur',
            quantity: 1,
            state: sop.States.neww,
            comment: '',
            photo: 0
          ),
          sop.ElectricAndHeating(
            type: 'Prise électrique',
            quantity: 3,
            state: sop.States.neww,
            comment: '',
            photo: 0
          ),
        ],
        equipments: [
          sop.Equipment(
            type: 'Interrupteur',
            brandOrObject: 'Brandt',
            stateOrQuantity: sop.States.good,
            comment: '',
            photo: 0
          ),
          sop.Equipment(
            type: 'Interrupteur',
            brandOrObject: 'Brandt',
            stateOrQuantity: sop.States.good,
            comment: '',
            photo: 0
          ),
        ],
        generalAspect: sop.GeneralAspect(
          comment: 'Cuisine La cuisine équipée est en très bon état et complète Photo n°12',
          photo: 0
        )
      ),
      sop.Room(
        name: 'Séjour / Salon',
        decorations: [
          sop.Decoration(
            type: 'Porte',
            nature: 'Pas de porte',
            state: sop.States.good,
            comment: 'Il manque la porte',
            photo: 0
          ),
          sop.Decoration(
            type: 'Porte',
            nature: 'Pas de porte',
            state: sop.States.good,
            comment: 'Il manque la porte',
            photo: 0
          )
        ],
        electricsAndHeatings: [
          sop.ElectricAndHeating(
            type: 'Interrupteur',
            quantity: 1,
            state: sop.States.neww,
            comment: '',
            photo: 0
          ),
          sop.ElectricAndHeating(
            type: 'Prise électrique',
            quantity: 3,
            state: sop.States.neww,
            comment: '',
            photo: 0
          ),
        ],
        equipments: [
          sop.Equipment(
            type: 'Interrupteur',
            brandOrObject: 'Brandt',
            stateOrQuantity: sop.States.good,
            comment: '',
            photo: 0
          ),
          sop.Equipment(
            type: 'Interrupteur',
            brandOrObject: 'Brandt',
            stateOrQuantity: sop.States.good,
            comment: '',
            photo: 0
          ),
        ],
        generalAspect: sop.GeneralAspect(
          comment: 'Cuisine La cuisine équipée est en très bon état et complète Photo n°12',
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
    comment: "L'appartement vient d'être repeint",
    reserve: 'Le propritaire doit remettre une cuvette dans les toilettes',
    city: 'Mulhouse',
    date: DateTime.now()
  );

  Widget build(BuildContext context) {
    return Mutation(
      options: MutationOptions(
        documentNode: gql('''
          mutation createStateOfPlay(\$data: CreateStateOfPlayInput!) {
            createStateOfPlay(data: \$data) {
              id
              fullAddress
            }
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
        RunMutation runMutation,
        QueryResult result,
      ) {
        
        return NewStateOfPlayContent(
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
              }
            });

            QueryResult networkResult = await result.networkResult;

            print("networkResult hasException: " + networkResult.hasException.toString());
            if (networkResult.hasException)
              print("networkResult exception: " + networkResult.exception.graphqlErrors[0].toString());
            print("");
            print("");
            
            Navigator.pop(context);
            Navigator.popAndPushNamed(context, "/state-of-plays");

          },
          stateOfPlay: _stateOfPlay
        );
      }
    );
  }
}