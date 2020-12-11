import 'package:flutter_tests/utils.dart';
import 'package:intl/intl.dart';// DateFormat

class Owner {
  Owner({
    this.id,
    this.firstName,
    this.lastName,
    this.company,
    this.address,
    this.postalCode,
    this.city
  });

  String id;
  String firstName;
  String lastName;
  String company;
  String address;
  String postalCode;
  String city;

  factory Owner.fromJSON(Map<String, dynamic> json) {

    return Owner(
      id: json["id"],
      firstName: json["firstName"],
      lastName: json["lastName"],
      company: json["company"],
      address: json["address"],
      postalCode: json["postalCode"],
      city: json["city"],
    );
  }
}

class Representative {
  Representative({
    this.id,
    this.firstName,
    this.lastName,
    this.company,
    this.address,
    this.postalCode,
    this.city
  });

  String id;
  String firstName;
  String lastName;
  String company;
  String address;
  String postalCode;
  String city;

  factory Representative.fromJSON(Map<String, dynamic> json) {

    return Representative(
      id: json["id"],
      firstName: json["firstName"],
      lastName: json["lastName"],
      company: json["company"],
      address: json["address"],
      postalCode: json["postalCode"],
      city: json["city"],
    );
  }
}

class Tenant {
  Tenant({
    this.id,
    this.firstName,
    this.lastName,
    this.address,
    this.postalCode,
    this.city
  });

  String id;
  String firstName;
  String lastName;
  String address;
  String postalCode;
  String city;

  factory Tenant.fromJSON(Map<String, dynamic> json) {

    return Tenant(
      id: json["id"],
      firstName: json["firstName"],
      lastName: json["lastName"],
      address: json["address"],
      postalCode: json["postalCode"],
      city: json["city"],
    );
  }
}

class Property {
  Property({
    this.id,
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
    this.hotWater,

    this.door,
    this.building
  });

  String id;

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
  String door;
  String building;

  factory Property.fromJSON(Map<String, dynamic> json) {

    return Property(
      id: json["id"],
      address: json["address"],
      postalCode: json["postalCode"],
      city: json["city"],
      type: json["type"],
      reference: json["reference"],
      lot: json["lot"],
      // floor: int.parse(json["floor"]),
      // roomCount: int.parse(json["roomCount"]),
      // area: int.parse(json["area"]),
      annexes: json["annexes"],
      heatingType: json["heatingType"],
      hotWater: json["hotWater"],
      door: json["door"],
      building: json["building"],
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      "address": address,
      "postalCode": postalCode,
      "city": city,
      // "type": type,
      // "reference": reference,
      // "lot": lot,// TODO
    };
  }
}

class StateOfPlay {
  StateOfPlay({
    this.id,
    this.owner,
    this.representative,
    this.tenants,
    this.entryDate,
    this.property,
    this.rooms,
    this.meters,
    this.keys,
    this.insurance,
    this.comment,
    this.reserve,
    this.city,
    this.date,
    this.photos
  });

  String id;

  Owner owner;
  Representative representative;
  List<Tenant> tenants;

  DateTime entryDate;// To be changed

  Property property;

  List<Room> rooms;

  List<Meter> meters;

  List<Key> keys;

  Insurance insurance;
  String comment;
  String reserve;

  String city;
  DateTime date;

  List<String> photos;

  factory StateOfPlay.fromJSON(Map<String, dynamic> json) {

    return StateOfPlay(
      id: json["id"],
      // owner: Owner.fromJSON(json["owner"]),
      // representative: Representative.fromJSON(json["representative"]),
      // tenants: (json["tenants"] as List).map((tenant) => Tenant.fromJSON(tenant)).toList(),
      // entryDate: DateTime.parse(json["entryDate"]),
      property: Property.fromJSON(json["property"]),
      // rooms: (json["rooms"] as List).map((room) => Room.fromJSON(room)).toList(),
      // meters: (json["meters"] as List).map((meter) => Meter.fromJSON(meter)).toList(),
      // keys: (json["keys"] as List).map((key) => Key.fromJSON(key)).toList(),
      // insurance: Insurance.fromJSON(json["insurance"]),
      // comment: json["comment"],
      // reserve: json["reserve"],
      // city: json["city"],
      date: json["date"] != null ? DateTime.parse(json["date"]) : null,
      // photos: ??? TODO
    );
  }
}

// enum Decorations {
//   door,
//   floor,
//   baseboard,
//   wall,
//   ceiling,
//   window
// }

// enum String {
//   neww,
//   good,
//   used,
//   defaillant,// TODO traduction
//   bonFonctionnement,
//   mauvaisFonctionnement
// }

class Decoration {
  Decoration({
    this.type,
    this.nature,
    this.state,
    this.comment,
    this.photo// TODO
  });

  String type;
  String nature;
  String state;
  String comment;
  int photo;

  String getIndex(int index) {
    switch (index) {
      case 0:
        return type;
      case 1:
        return nature;
      case 2:
        return state;
      case 3:
        return comment;
      case 4:
        return photo.toString();
    }
    return '';
  }
  
  factory Decoration.fromJSON(Map<String, dynamic> json) {

    return Decoration(
      type: json["type"],
      nature: json["brandOrObject"],
      state: json["state"],// TODO parse dual type
      comment: json["comment"],
      photo: int.parse(json["photo"])
    );
  }
}

// enum ElectricsAndHeatings {
//   lightSwitch,
//   eletricalOutlet,
//   radiator,
  
// }

class ElectricAndHeating {
  ElectricAndHeating({
    this.type,
    this.quantity,
    this.state,
    this.comment,
    this.photo// TODO
  });

  String type;
  int quantity;
  String state;
  String comment;
  int photo;

  String getIndex(int index) {
    switch (index) {
      case 0:
        return type;
      case 1:
        return quantity.toString();
      case 2:
        return state;
      case 3:
        return comment;
      case 4:
        return photo.toString();
    }
    return '';
  }

  factory ElectricAndHeating.fromJSON(Map<String, dynamic> json) {

    return ElectricAndHeating(
      type: json["type"],
      quantity: int.parse(json["brandOrObject"]),
      state: json["state"],// TODO parse dual type
      comment: json["comment"],
      photo: int.parse(json["photo"])
    );
  }
}

class Equipment {
  Equipment({
    this.type,
    this.brandOrObject,
    this.stateOrQuantity,
    this.comment,
    this.photo// TODO
  });

  String type;
  String brandOrObject;
  dynamic stateOrQuantity;
  String comment;
  int photo;

  String getIndex(int index) {
    switch (index) {
      case 0:
        return type;
      case 1:
        return brandOrObject;
      case 2:
        return stateOrQuantity is int ? stateOrQuantity.toString() : stateOrQuantity;
      case 3:
        return comment;
      case 4:
        return photo.toString();
    }
    return '';
  }

  factory Equipment.fromJSON(Map<String, dynamic> json) {

    return Equipment(
      type: json["type"],
      brandOrObject: json["brandOrObject"],
      stateOrQuantity: json["stateOrQuantity"],// TODO parse dual type
      comment: json["comment"],
      photo: int.parse(json["photo"])
    );
  }
}

class GeneralAspect {
  GeneralAspect({
    this.comment,
    this.photo// TODO
  });

  String comment;
  int photo;
  
  factory GeneralAspect.fromJSON(Map<String, dynamic> json) {

    return GeneralAspect(
      comment: json["comment"],
      photo: int.parse(json["photo"])
    );
  }
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
  
  factory Room.fromJSON(Map<String, dynamic> json) {

    return Room(
      name: json["name"],
      decorations: (json["decorations"] as List).map((decoration) => Decoration.fromJSON(decoration)).toList(),
      electricsAndHeatings: (json["electricsAndHeatings"] as List).map((electricsAndHeating) => ElectricAndHeating.fromJSON(electricsAndHeating)).toList(),
      equipments: (json["equipments"] as List).map((equipment) => Equipment.fromJSON(equipment)).toList(),
      generalAspect: GeneralAspect.fromJSON(json["generalAspect"]),
    );
  }
}

class Meter {
  const Meter({
    this.type,
    this.location,
    this.dateOfSuccession,
    this.index,
    this.photo// TODO
  });

  final String type;
  final String location;
  final DateTime dateOfSuccession;
  final int index;
  final int photo;

  String getIndex(int index) {
    switch (index) {
      case 0:
        return type;
      case 1:
        return location;
      case 2:
        return DateFormat('dd/MM/yyyy').format(dateOfSuccession);
      case 3:
        return index.toString();
      case 4:
        return photo.toString();
    }
    return '';
  }

  factory Meter.fromJSON(Map<String, dynamic> json) {

    return Meter(
      type: json["type"],
      location: json["location"],
      dateOfSuccession: DateTime.parse(json["dateOfSuccession"]),
      index: int.parse(json["index"]),
      photo: int.parse(json["photo"])
    );
  }
}

class Key {
  const Key({
    this.type,
    this.count,
    this.comments,
    this.photo// TODO
  });

  final String type;
  final int count;
  final String comments;
  final int photo;

  String getIndex(int index) {
    switch (index) {
      case 0:
        return type;
      case 1:
        return count.toString();
      case 2:
        return comments;
      case 3:
        return photo.toString();
    }
    return '';
  }

  factory Key.fromJSON(Map<String, dynamic> json) {

    return Key(
      type: json["type"],
      count: int.parse(json["count"]),
      comments: json["comments"],
      photo: int.parse(json["photo"])
    );
  }
}

class Insurance {
  const Insurance({
    this.company,
    this.number,
    this.dateStart,
    this.dateEnd
  });

  final String company;
  final String number;
  final DateTime dateStart;
  final DateTime dateEnd;

  factory Insurance.fromJSON(Map<String, dynamic> json) {

    return Insurance(
      company: json["company"],
      number: json["number"],
      dateStart: DateTime.parse(json["dateStart"]),
      dateEnd: DateTime.parse(json["dateEnd"])
    );
  }
}

class User {
  User({
    this.firstName,
    this.lastName,
    this.stateOfPlays,
    this.properties
  });

  final String firstName;
  final String lastName;
  final List<StateOfPlay> stateOfPlays;
  final List<Property> properties;

  factory User.fromJSON(Map<String, dynamic> json) {

    return User(
      firstName: json["firstName"],
      lastName: json["lastName"],// TODO : pb ici avec la sérialisation
      stateOfPlays: json["stateOfPlays"] != null ? (json["stateOfPlays"] as List).map((stateOfPlay) => StateOfPlay.fromJSON(stateOfPlay)).toList() : null,
      properties: json["properties"] != null ? (json["properties"] as List).map((property) => Property.fromJSON(property)).toList() : null,
    );
  }
}