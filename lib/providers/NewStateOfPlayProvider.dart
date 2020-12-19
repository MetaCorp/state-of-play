import 'package:flutter/foundation.dart';

import 'package:flutter_tests/models/StateOfPlay.dart' as sop;

class NewStateOfPlayProvider with ChangeNotifier {
  sop.StateOfPlay value = sop.StateOfPlay(
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

  void update(sop.StateOfPlay newValue) {
    print('NewStateOfPlayProvider update: ' + newValue.property.reference);
    value = newValue;
    notifyListeners();
  }
}