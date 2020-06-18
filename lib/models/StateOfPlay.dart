
class Owner {
  const Owner(
    this.firstname,
    this.lastname,
    this.company,
    this.address
  );

  final String firstname;
  final String lastname;
  final String company;
  final String address;
}

class Representative {
  const Representative(
    this.firstname,
    this.lastname,
    this.company,
    this.address
  );

  final String firstname;
  final String lastname;
  final String company;
  final String address;
}

class Tenant {
  const Tenant(
    this.firstname,
    this.lastname,
    this.address
  );

  final String firstname;
  final String lastname;
  final String address;
}

class Property {
  const Property(
    this.address,
    this.type,
    this.reference,
    this.lot,
    this.floor,
    this.roomCount,
    this.area,
    this.annexe,
    this.heatingType,
    this.hotWater
  );

  final String address;
  final String type;// To be replaced
  final String reference;
  final String lot;
  final int floor;
  final int roomCount;
  final int area;
  final String annexe;// To be replaced
  final String heatingType;// To be replaced
  final String hotWater;// To be replaced
}

class StateOfPlay {
  const StateOfPlay(
    this.owner,
    this.representative,
    this.tenants,
    this.entryDate,
    this.property,
    this.kitchen
  );

  final Owner owner;
  final Representative representative;
  final List<Tenant> tenants;

  final String entryDate;// To be changed

  final Property property;

  final Kitchen kitchen;
}

enum Decorations {
  door,
  floor,
  baseboard,
  wall,
  ceiling,
  window
}

enum States {
  neww,
  good,
  used
}

enum DoorNature {
  noDoor,
  woodDoor,
  woodDoors
}

class Decoration {
  const Decoration(
    this.decoration,
    this.nature,
    this.state,
    this.comment,
    this.photo// TODO
  );

  final Decorations decoration;
  final dynamic nature;
  final States state;
  final String comment;
  final String photo;

  String getIndex(int index) {
    switch (index) {
      case 0:
        return decoration.toString().split('.').last;
      case 1:
        return nature.toString().split('.').last;
      case 2:
        return state.toString().split('.').last;
      case 3:
        return comment;
      case 4:
        return photo;
    }
    return '';
  }
}

class Kitchen {
  Kitchen(
    this.decorations
  );

  final List<Decoration> decorations;
}