import 'package:flutter_tests/utils.dart';

class Owner {
  Owner({
    this.firstname,
    this.lastname,
    this.company,
    this.address,
    this.postalCode,
    this.city
  });

  String firstname;
  String lastname;
  String company;
  String address;
  String postalCode;
  String city;
}

class Representative {
  Representative({
    this.firstname,
    this.lastname,
    this.company,
    this.address,
    this.postalCode,
    this.city
  });

  String firstname;
  String lastname;
  String company;
  String address;
  String postalCode;
  String city;
}

class Tenant {
  Tenant({
    this.firstname,
    this.lastname,
    this.address,
    this.postalCode,
    this.city
  });

  String firstname;
  String lastname;
  String address;
  String postalCode;
  String city;
}

class Property {
  Property({
    this.address,
    this.postalCode,
    this.city,
    this.type,
    this.reference,
    this.lot,
    this.floor,
    this.roomCount,
    this.area,
    this.annexes,
    this.heatingType,
    this.hotWater
  });

  String address;
  String postalCode;
  String city;
  String type;// To be replaced
  String reference;
  String lot;
  int floor;
  int roomCount;
  int area;
  String annexes;// To be replaced
  String heatingType;// To be replaced
  String hotWater;// To be replaced
}

class StateOfPlay {
  const StateOfPlay({
    this.owner,
    this.representative,
    this.tenants,
    this.entryDate,
    this.property,
    this.rooms
  });

  final Owner owner;
  final Representative representative;
  final List<Tenant> tenants;

  final DateTime entryDate;// To be changed

  final Property property;

  final List<Room> rooms;
}

// enum Decorations {
//   door,
//   floor,
//   baseboard,
//   wall,
//   ceiling,
//   window
// }

enum States {
  neww,
  good,
  used,
  defaillant,// TODO traduction
  bonFonctionnement,
  mauvaisFonctionnement
}

class Decoration {
  const Decoration({
    this.type,
    this.nature,
    this.state,
    this.comment,
    this.photo// TODO
  });

  final String type;
  final String nature;
  final States state;
  final String comment;
  final String photo;

  String getIndex(int index) {
    switch (index) {
      case 0:
        return type;
      case 1:
        return nature;
      case 2:
        return enumToString(state);
      case 3:
        return comment;
      case 4:
        return photo;
    }
    return '';
  }
}

// enum ElectricsAndHeatings {
//   lightSwitch,
//   eletricalOutlet,
//   radiator,
  
// }

class ElectricAndHeating {
  const ElectricAndHeating({
    this.type,
    this.quantity,
    this.state,
    this.comment,
    this.photo// TODO
  });

  final String type;
  final int quantity;
  final States state;
  final String comment;
  final String photo;

  String getIndex(int index) {
    switch (index) {
      case 0:
        return type;
      case 1:
        return quantity.toString();
      case 2:
        return enumToString(state);
      case 3:
        return comment;
      case 4:
        return photo;
    }
    return '';
  }
}

class Equipment {
  const Equipment({
    this.type,
    this.brandOrObject,
    this.stateOrQuantity,
    this.comment,
    this.photo// TODO
  });

  final String type;
  final String brandOrObject;
  final dynamic stateOrQuantity;
  final String comment;
  final String photo;

  String getIndex(int index) {
    switch (index) {
      case 0:
        return type;
      case 1:
        return brandOrObject;
      case 2:
        return stateOrQuantity is int ? stateOrQuantity.toString() : enumToString(stateOrQuantity);
      case 3:
        return comment;
      case 4:
        return photo;
    }
    return '';
  }
}

class GeneralAspect {
  const GeneralAspect({
    this.comment,
    this.photo// TODO
  });

  final String comment;
  final String photo;
}

class Room {
  Room({
    this.name,
    this.decorations,
    this.electricsAndHeatings,
    this.equipments,
    this.generalAspect
  });

  final String name;
  final List<Decoration> decorations;
  final List<ElectricAndHeating> electricsAndHeatings;
  final List<Equipment> equipments;
  final GeneralAspect generalAspect;
}