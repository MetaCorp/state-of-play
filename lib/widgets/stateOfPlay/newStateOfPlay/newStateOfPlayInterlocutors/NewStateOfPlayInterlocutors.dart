import 'package:flutter/material.dart';
import 'package:flutter_tests/models/StateOfPlay.dart' as sop;

import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/newStateOfPlayInterlocutors/DoubleButton.dart';
import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/newStateOfPlayInterlocutors/NewStateOfPlayInterlocutorsOwner.dart';
import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/newStateOfPlayInterlocutors/NewStateOfPlayInterlocutorsProperty.dart';
import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/newStateOfPlayInterlocutors/NewStateOfPlayInterlocutorsRepresentative.dart';
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
          text: widget.stateOfPlay.owner.lastName != "" ? widget.stateOfPlay.owner.firstName + ' ' + widget.stateOfPlay.owner.lastName : null,
          hintText: "Sélectionner un propriétaire",
          onPressAdd: () {
            Navigator.push(context, PageRouteBuilder(pageBuilder: (_, __, ___) => NewStateOfPlayInterlocutorsOwner(
              owner: sop.Owner(),
              onSave : (owner) {
                widget.stateOfPlay.owner = owner;
                setState(() { }); // To rerender widget
              }
            )));
          },
        ),
        Text("Mandataire"),
        DoubleButton(
          text: widget.stateOfPlay.representative.lastName != "" ? widget.stateOfPlay.representative.firstName + ' ' + widget.stateOfPlay.representative.lastName : null,
          hintText: "Sélectionner un mandataire",
          onPressAdd: () {
            Navigator.push(context, PageRouteBuilder(pageBuilder: (_, __, ___) => NewStateOfPlayInterlocutorsRepresentative(
              representative: sop.Representative(),
              onSave : (representative) {
                widget.stateOfPlay.representative = representative;
                setState(() { }); // To rerender widget
              }
            )));
          },
        ),
        Text("Locataires"),
        DoubleButton(
          hintText: "Sélectionner un locataire",
          onPressAdd: () {
            Navigator.push(context, PageRouteBuilder(pageBuilder: (_, __, ___) => NewStateOfPlayInterlocutorsTenant(
              tenant: sop.Tenant(),
              onSave : (tenant) {
                widget.stateOfPlay.tenants.add(tenant);
                setState(() { }); // To rerender widget
              }
            )));
          },
        ),
        Column(
          children: widget.stateOfPlay.tenants.map((tenant) => Text(tenant.firstName + ' ' + tenant.lastName)).toList()
        ),
        Divider(),
        Text("Propriété"),
        DoubleButton(
          text: widget.stateOfPlay.property.address != "" ? widget.stateOfPlay.property.address + ', ' + widget.stateOfPlay.property.postalCode + ' ' + widget.stateOfPlay.property.city : null,
          hintText: "Sélectionner une propriété",
          onPressAdd: () {
            Navigator.push(context, PageRouteBuilder(pageBuilder: (_, __, ___) => NewStateOfPlayInterlocutorsProperty(
              property: sop.Property(),
              onSave : (property) {
                widget.stateOfPlay.property = property;
                setState(() { }); // To rerender widget
              }
            )));
          },
        ),
      ],
    );
  }
}