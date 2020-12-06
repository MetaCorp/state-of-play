import 'package:flutter_tests/utils.dart';
import 'package:intl/intl.dart';// DateFormat

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

  factory Owner.fromJSON(Map<String, dynamic> json) {

    return Owner(
      firstname: json["firstname"],
      lastname: json["lastname"],
      company: json["company"],
      address: json["address"],
      postalCode: json["postalCode"],
      city: json["city"],
    );
  }
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

  factory Representative.fromJSON(Map<String, dynamic> json) {

    return Representative(
      firstname: json["firstname"],
      lastname: json["lastname"],
      company: json["company"],
      address: json["address"],
      postalCode: json["postalCode"],
      city: json["city"],
    );
  }
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

  factory Tenant.fromJSON(Map<String, dynamic> json) {

    return Tenant(
      firstname: json["firstname"],
      lastname: json["lastname"],
      address: json["address"],
      postalCode: json["postalCode"],
      city: json["city"],
    );
  }
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
    this.hotWater,

    this.door,
    this.building
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
  String door;
  String building;

  factory Property.fromJSON(Map<String, dynamic> json) {

    return Property(
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

  Map<String, dynamic> toJSON(Property property) {
    return {
      "address": property.address,
      "postalCode": property.postalCode,
      "city": property.city,
      "type": property.type,
      "reference": property.reference,
      "lot": property.lot,// TODO
    };
  }
}

class StateOfPlay {
  const StateOfPlay({
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

  final Owner owner;
  final Representative representative;
  final List<Tenant> tenants;

  final DateTime entryDate;// To be changed

  final Property property;

  final List<Room> rooms;

  final List<Meter> meters;

  final List<Key> keys;

  final Insurance insurance;
  final String comment;
  final String reserve;

  final String city;
  final DateTime date;

  final List<String> photos;

  factory StateOfPlay.fromJSON(Map<String, dynamic> json) {

    return StateOfPlay(
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
  final int photo;

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
        return photo.toString();
    }
    return '';
  }
  
  factory Decoration.fromJSON(Map<String, dynamic> json) {

    return Decoration(
      type: json["type"],
      nature: json["brandOrObject"],
      state: enumFromString(json["state"], States.values),// TODO parse dual type
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
  final int photo;

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
        return photo.toString();
    }
    return '';
  }

  factory ElectricAndHeating.fromJSON(Map<String, dynamic> json) {

    return ElectricAndHeating(
      type: json["type"],
      quantity: int.parse(json["brandOrObject"]),
      state: enumFromString(json["state"], States.values),// TODO parse dual type
      comment: json["comment"],
      photo: int.parse(json["photo"])
    );
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
  final int photo;

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
  const GeneralAspect({
    this.comment,
    this.photo// TODO
  });

  final String comment;
  final int photo;
  
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
    this.firstname,
    this.lastname,
    this.stateOfPlays,
    this.properties
  });

  final String firstname;
  final String lastname;
  final List<StateOfPlay> stateOfPlays;
  final List<Property> properties;

  factory User.fromJSON(Map<String, dynamic> json) {

    return User(
      firstname: json["firstname"],
      lastname: json["lastname"],// TODO : pb ici avec la sérialisation
      stateOfPlays: json["stateOfPlays"] != null ? (json["stateOfPlays"] as List).map((stateOfPlay) => StateOfPlay.fromJSON(stateOfPlay)).toList() : null,
      properties: json["properties"] != null ? (json["properties"] as List).map((property) => Property.fromJSON(property)).toList() : null,
    );
  }
}