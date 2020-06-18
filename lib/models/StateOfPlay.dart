
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
    this.property
  );

  final Owner owner;
  final Representative representative;
  final List<Tenant> tenants;

  final String entryDate;// To be changed

  final Property property;
}