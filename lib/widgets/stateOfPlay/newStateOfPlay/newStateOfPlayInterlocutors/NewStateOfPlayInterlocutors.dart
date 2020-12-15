import 'package:flutter/material.dart';
import 'package:flutter_tests/models/StateOfPlay.dart' as sop;

import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/newStateOfPlayInterlocutors/DoubleButton.dart';
import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/newStateOfPlayInterlocutors/NewStateOfPlayInterlocutorsOwner.dart';
import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/newStateOfPlayInterlocutors/NewStateOfPlayInterlocutorsProperty.dart';
import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/newStateOfPlayInterlocutors/NewStateOfPlayInterlocutorsRepresentative.dart';
import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/newStateOfPlayInterlocutors/NewStateOfPlayInterlocutorsSearchOwners.dart';
import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/newStateOfPlayInterlocutors/NewStateOfPlayInterlocutorsSearchProperties.dart';
import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/newStateOfPlayInterlocutors/NewStateOfPlayInterlocutorsSearchRepresentatives.dart';
import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/newStateOfPlayInterlocutors/NewStateOfPlayInterlocutorsSearchTenants.dart';
import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/newStateOfPlayInterlocutors/NewStateOfPlayInterlocutorsTenant.dart';


class NewStateOfPlayInterlocutors extends StatefulWidget {
  NewStateOfPlayInterlocutors({ Key key, this.stateOfPlay }) : super(key: key);

  final sop.StateOfPlay stateOfPlay;

  @override
  _NewStateOfPlayInterlocutorsState createState() => new _NewStateOfPlayInterlocutorsState();
}

class _NewStateOfPlayInterlocutorsState extends State<NewStateOfPlayInterlocutors> {
  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        Text("Propriétaire"),
        DoubleButton(
          text: widget.stateOfPlay.owner.lastName != null ? widget.stateOfPlay.owner.firstName + ' ' + widget.stateOfPlay.owner.lastName : null,
          labelText: "Sélectionner un propriétaire",
          onPress: () {
            Navigator.push(context, PageRouteBuilder(pageBuilder: (_, __, ___) => NewStateOfPlayInterlocutorsSearchOwners(
              onSelect : (owner) {
                widget.stateOfPlay.owner = owner;
                setState(() { }); // To rerender widget
              }
            )));
          },
          onPressAdd: () {
            Navigator.push(context, PageRouteBuilder(pageBuilder: (_, __, ___) => NewStateOfPlayInterlocutorsOwner(
              owner: sop.Owner(),
              onSave : (owner) {
                widget.stateOfPlay.owner = owner;
                setState(() { });
              }
            )));
          },
          onPressRemove: () {
            widget.stateOfPlay.owner = sop.Owner();
            setState(() { });
          },
        ),

        Divider(),
        Text("Mandataire"),
        DoubleButton(
          text: widget.stateOfPlay.representative.lastName != null ? widget.stateOfPlay.representative.firstName + ' ' + widget.stateOfPlay.representative.lastName : null,
          labelText: "Sélectionner un mandataire",
          onPress: () {
            Navigator.push(context, PageRouteBuilder(pageBuilder: (_, __, ___) => NewStateOfPlayInterlocutorsSearchRepresentatives(
              onSelect : (representative) {
                widget.stateOfPlay.representative = representative;
                setState(() { });
              }
            )));
          },
          onPressAdd: () {
            Navigator.push(context, PageRouteBuilder(pageBuilder: (_, __, ___) => NewStateOfPlayInterlocutorsRepresentative(
              representative: sop.Representative(),
              onSave : (representative) {
                widget.stateOfPlay.representative = representative;
                setState(() { });
              }
            )));
          },
          onPressRemove: () {
            widget.stateOfPlay.representative = sop.Representative();
            setState(() { });
          },
        ),

        Divider(),
        Text("Locataires"),
        DoubleButton(
          labelText: "Selectionner un locataire",
          onPress: () {
            Navigator.push(context, PageRouteBuilder(pageBuilder: (_, __, ___) => NewStateOfPlayInterlocutorsSearchTenants(
              onSelect : (tenant) {
                widget.stateOfPlay.tenants.add(tenant);
                setState(() { });
              }
            )));
          },
          onPressAdd: () {
            Navigator.push(context, PageRouteBuilder(pageBuilder: (_, __, ___) => NewStateOfPlayInterlocutorsTenant(
              tenant: sop.Tenant(),
              onSave : (tenant) {
                widget.stateOfPlay.tenants.add(tenant);
                setState(() { });
              }
            )));
          }, 
        ),
        Column(
          children: widget.stateOfPlay.tenants.map((tenant) => DoubleButton(
            text: tenant.firstName + ' ' + tenant.lastName,
            onPressRemove: () {
              widget.stateOfPlay.tenants.remove(tenant);
              setState(() { });
            },
          ),).toList()
        ),

        Divider(),
        Text("Propriété"),
        DoubleButton(
          text: widget.stateOfPlay.property.address != null ? widget.stateOfPlay.property.address + ', ' + widget.stateOfPlay.property.postalCode + ' ' + widget.stateOfPlay.property.city : null,
          labelText: "Sélectionner une propriété",
          onPress: () {
            Navigator.push(context, PageRouteBuilder(pageBuilder: (_, __, ___) => NewStateOfPlayInterlocutorsSearchProperties(
              onSelect : (property) {
                widget.stateOfPlay.property = property;
                setState(() { });
              }
            )));
          },
          onPressAdd: () {
            Navigator.push(context, PageRouteBuilder(pageBuilder: (_, __, ___) => NewStateOfPlayInterlocutorsProperty(
              property: sop.Property(),
              onSave : (property) {
                widget.stateOfPlay.property = property;
                setState(() { });
              }
            )));
          },
          onPressRemove: () {
            widget.stateOfPlay.property = sop.Property();
            setState(() { });
          },
        ),
      ],
    );
  }
}