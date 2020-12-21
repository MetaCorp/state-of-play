import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_tests/utils.dart';
import 'package:intl/intl.dart';// DateFormat
import 'dart:convert';

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
      floor: json["floor"],
      roomCount: json["roomCount"],
      area: json["area"],
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
    this.out,
    this.owner,
    this.representative,
    this.tenants,
    this.entryExitDate,
    this.property,
    this.rooms,
    this.meters,
    this.keys,
    this.insurance,
    this.comments,
    this.reserve,
    this.city,
    this.date,
    this.documentHeader,
    this.documentEnd,
    this.signatureOwner,
    this.signatureRepresentative,
    this.signatureTenants,
    this.images
  });

  String id;

  bool out;

  Owner owner;
  Representative representative;
  List<Tenant> tenants;

  DateTime entryExitDate;// To be changed

  Property property;

  List<Room> rooms;

  List<Meter> meters;

  List<Key> keys;

  Insurance insurance;
  String comments;
  String reserve;

  String city;
  DateTime date;

  String documentHeader;
  String documentEnd;

  Uint8List signatureOwner;
  Uint8List signatureRepresentative;
  List<Uint8List> signatureTenants;

  List<Map> images;

  factory StateOfPlay.fromJSON(Map<String, dynamic> json) {

    return StateOfPlay(
      id: json["id"],
      out: json["out"],
      owner: json["owner"] != null ? Owner.fromJSON(json["owner"]) : null,
      representative: json["representative"] != null ? Representative.fromJSON(json["representative"]) : null,
      tenants: json["tenants"] != null ? (json["tenants"] as List).map((tenant) => Tenant.fromJSON(tenant)).toList() : null,
      entryExitDate: json["entryExitDate"] != null ? DateTime.parse(json["entryExitDate"]) : null,
      property: json["property"] != null ? Property.fromJSON(json["property"]) : null,
      rooms: json["rooms"] != null ? (jsonDecode(json["rooms"]) as List).map((room) => Room.fromJSON(room)).toList() : null,
      meters: json["meters"] != null ? (jsonDecode(json["meters"]) as List).map((meter) => Meter.fromJSON(meter)).toList() : null,
      keys: json["keys"] != null ? (jsonDecode(json["keys"]) as List).map((key) => Key.fromJSON(key)).toList() : null,
      insurance: json["insurance"] != null ? Insurance.fromJSON(jsonDecode(json["insurance"])) : null,
      comments: json["comments"],
      reserve: json["reserve"],
      city: json["city"],
      date: json["date"] != null ? DateTime.parse(json["date"]) : null,
      documentHeader: json["documentHeader"],
      documentEnd: json["documentEnd"],
      images: []
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

// TODO: define return type
final imageIndexesToString = (List<int> imageIndexes) {
  String str = "";

  for (var i = 0; i < imageIndexes.length; i++) {
    str += 'Photo n°' + (imageIndexes[i] + 1).toString();

    if (i != imageIndexes.length - 1)
      str += "\n";
  }

  return str;
};

class Decoration {
  Decoration({
    this.type,
    this.nature,
    this.state,
    this.comments,
    this.newImages,
    this.images,
    this.imageIndexes
  });

  String type;
  String nature;
  String state;
  String comments;
  List<File> newImages;
  List<String> images;
  List<int> imageIndexes;

  String getIndex(int index) {
    switch (index) {
      case 0:
        return type;
      case 1:
        return nature;
      case 2:
        return state;
      case 3:
        return comments;
      case 4:
        return imageIndexesToString(imageIndexes);
    }
    return '';
  }
  
  factory Decoration.fromJSON(Map<String, dynamic> json) {
    print('fromJSON images: ' + json["images"].toString());

    return Decoration(
      type: json["type"],
      nature: json["nature"],
      state: json["state"],// TODO parse dual type
      comments: json["comments"],
      newImages: [],// need to init here bc not from server
      images: json["images"] != null ? json["images"].cast<String>() : null,
      imageIndexes: []
    );
  }
}

// enum ElectricsAndHeatings {
//   lightSwitch,
//   eletricalOutlet,
//   radiator,
  
// }

class Electricity {
  Electricity({
    this.type,
    this.quantity,
    this.state,
    this.comments,
    this.newImages,
    this.images,
    this.imageIndexes
  });

  String type;
  int quantity;
  String state;
  String comments;
  List<File> newImages;
  List<String> images;
  List<int> imageIndexes;


  String getIndex(int index) {
    switch (index) {
      case 0:
        return type;
      case 1:
        return quantity.toString();
      case 2:
        return state;
      case 3:
        return comments;
      case 4:
        return imageIndexesToString(imageIndexes);
    }
    return '';
  }

  factory Electricity.fromJSON(Map<String, dynamic> json) {

    return Electricity(
      type: json["type"],
      quantity: json["quantity"],
      state: json["state"],// TODO parse dual type
      comments: json["comments"],
      newImages: [],
      images: json["images"] != null ? json["images"].cast<String>() : null,
      imageIndexes: []
    );
  }
}

class Equipment {
  Equipment({
    this.type,
    this.brandOrObject,
    this.state,
    this.comments,
    this.quantity,
    this.newImages,
    this.images,
    this.imageIndexes
  });

  String type;
  String brandOrObject;
  dynamic state;
  String comments;
  int quantity;
  List<File> newImages;
  List<String> images;
  List<int> imageIndexes;

  String getIndex(int index) {
    switch (index) {
      case 0:
        return type;
      case 1:
        return brandOrObject;
      case 2:
        return state + ' / ' + quantity.toString();
      case 3:
        return comments;
      case 4:
        return imageIndexesToString(imageIndexes);
    }
    return '';
  }

  factory Equipment.fromJSON(Map<String, dynamic> json) {

    return Equipment(
      type: json["type"],
      brandOrObject: json["brandOrObject"],
      state: json["state"],
      quantity: json["quantity"],
      comments: json["comments"],
      newImages: [],
      images: json["images"] != null ? json["images"].cast<String>() : null,
      imageIndexes: []
    );
  }
}

class GeneralAspect {
  GeneralAspect({
    this.comments,
    this.image// TODO
  });

  String comments;
  int image;
  
  factory GeneralAspect.fromJSON(Map<String, dynamic> json) {

    return GeneralAspect(
      comments: json["comments"],
      image: json["image"]
    );
  }
}

class Room {
  Room({
    this.name,
    this.decorations,
    this.electricities,
    this.equipments,
    this.generalAspect
  });

  final String name;
  final List<Decoration> decorations;
  final List<Electricity> electricities;
  final List<Equipment> equipments;
  final GeneralAspect generalAspect;
  
  factory Room.fromJSON(Map<String, dynamic> json) {

    return Room(
      name: json["name"],
      decorations: json["decorations"] != null ? (json["decorations"] as List).map((decoration) => Decoration.fromJSON(decoration)).toList() : null,
      electricities: json["electricities"] != null ? (json["electricities"] as List).map((electricsAndHeating) => Electricity.fromJSON(electricsAndHeating)).toList() : null,
      equipments: json["equipments"] != null ? (json["equipments"] as List).map((equipment) => Equipment.fromJSON(equipment)).toList() : null,
      generalAspect: json["generalAspect"] != null ? GeneralAspect.fromJSON(json["generalAspect"]) : null,
    );
  }
}

class Meter {
  Meter({
    this.type,
    this.location,
    this.dateOfSuccession,
    this.index,
    this.newImages,
    this.images,
    this.imageIndexes
  });

  String type;
  String location;
  DateTime dateOfSuccession;
  int index;
  List<File> newImages;
  List<String> images;
  List<int> imageIndexes;

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
        return imageIndexesToString(imageIndexes);
    }
    return '';
  }

  factory Meter.fromJSON(Map<String, dynamic> json) {

    return Meter(
      type: json["type"],
      location: json["location"],
      dateOfSuccession: json["dateOfSuccession"] != null ? DateTime.parse(json["dateOfSuccession"]) : null,
      index: json["index"],
      newImages: [],
      images: json["images"] != null ? json["images"].cast<String>() : null,
      imageIndexes: []
    );
  }
}

class Key {
  Key({
    this.type,
    this.quantity,
    this.comments,
    this.newImages,
    this.images,
    this.imageIndexes
  });

  String type;
  int quantity;
  String comments;
  List<File> newImages;
  List<String> images;
  List<int> imageIndexes;

  String getIndex(int index) {
    switch (index) {
      case 0:
        return type;
      case 1:
        return quantity.toString();
      case 2:
        return comments;
      case 3:
        return imageIndexesToString(imageIndexes);
    }
    return '';
  }

  factory Key.fromJSON(Map<String, dynamic> json) {

    return Key(
      type: json["type"],
      quantity: json["quantity"],
      comments: json["comments"],
      newImages: [],
      images: json["images"] != null ? json["images"].cast<String>() : null,
      imageIndexes: []
    );
  }
}

class Insurance {
  Insurance({
    this.company,
    this.number,
    this.dateStart,
    this.dateEnd
  });

  String company;
  String number;
  DateTime dateStart;
  DateTime dateEnd;

  factory Insurance.fromJSON(Map<String, dynamic> json) {

    return Insurance(
      company: json["company"],
      number: json["number"],
      dateStart: json["dateStart"] != null ? DateTime.parse(json["dateStart"]) : null,
      dateEnd: json["dateEnd"] != null ? DateTime.parse(json["dateEnd"]) : null
    );
  }
}

class User {
  User({
    this.firstName,
    this.lastName,
    this.documentHeader,
    this.documentEnd,
    this.address,
    this.postalCode,
    this.city,
    this.company,
    this.stateOfPlays,
    this.properties,
  });

  String firstName;
  String lastName;
  String documentHeader;
  String documentEnd;
  String address;
  String postalCode;
  String city;
  String company;
  List<StateOfPlay> stateOfPlays;
  List<Property> properties;

  factory User.fromJSON(Map<String, dynamic> json) {

    return User(
      firstName: json["firstName"],
      lastName: json["lastName"],
      documentHeader: json["documentHeader"],
      documentEnd: json["documentEnd"],
      address: json["address"],
      postalCode: json["postalCode"],
      city: json["city"],
      company: json["company"],
      stateOfPlays: json["stateOfPlays"] != null ? (json["stateOfPlays"] as List).map((stateOfPlay) => StateOfPlay.fromJSON(stateOfPlay)).toList() : null,
      properties: json["properties"] != null ? (json["properties"] as List).map((property) => Property.fromJSON(property)).toList() : null,
    );
  }
}