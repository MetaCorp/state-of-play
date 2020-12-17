import 'package:flutter/material.dart';
import 'package:flutter_tests/models/StateOfPlay.dart' as sop;
import 'package:flutter_tests/widgets/owner/EditOwner.dart';
import 'package:flutter_tests/widgets/property/NewPropertyContent.dart';
import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/newStateOfPlayInterlocutors/HeaderInterlocutor.dart';

import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/newStateOfPlayInterlocutors/ListTileInterlocutor.dart';
import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/newStateOfPlayInterlocutors/NewStateOfPlayInterlocutorsSearchOwners.dart';
import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/newStateOfPlayInterlocutors/NewStateOfPlayInterlocutorsSearchProperties.dart';
import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/newStateOfPlayInterlocutors/NewStateOfPlayInterlocutorsSearchRepresentatives.dart';
import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/newStateOfPlayInterlocutors/NewStateOfPlayInterlocutorsSearchTenants.dart';
import 'package:flutter_tests/widgets/utilities/NewInterlocutorContent.dart';


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
        HeaderInterlocutor(
          text: "Propriétaire"
        ),
        ListTileInterlocutor(
          text: widget.stateOfPlay.owner.lastName != null ? widget.stateOfPlay.owner.firstName + ' ' + widget.stateOfPlay.owner.lastName : null,
          labelText: "Sélectionner un propriétaire",
          onPress: () {
            if (widget.stateOfPlay.owner.lastName != null)
              Navigator.push(context, PageRouteBuilder(pageBuilder: (_, __, ___) => NewInterlocutorContent(
                title: 'Éditer un propriétaire',
                interlocutor: widget.stateOfPlay.owner,
                onSave : (owner) {
                  widget.stateOfPlay.owner = owner;
                  Navigator.pop(context);
                  setState(() { });
                }
              )));
            else
              Navigator.push(context, PageRouteBuilder(pageBuilder: (_, __, ___) => NewStateOfPlayInterlocutorsSearchOwners(
                onSelect : (owner) {
                  widget.stateOfPlay.owner = owner;
                  setState(() { }); // To rerender widget
                }
              )));
          },
          onPressAdd: () {
            Navigator.push(context, PageRouteBuilder(pageBuilder: (_, __, ___) => NewInterlocutorContent(
              title: 'Nouveau propriétaire',
              interlocutor: sop.Owner(),
              onSave : (owner) {
                widget.stateOfPlay.owner = owner;
                Navigator.pop(context);
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
        HeaderInterlocutor(
          text: "Mandataire"
        ),
        ListTileInterlocutor(
          text: widget.stateOfPlay.representative.lastName != null ? widget.stateOfPlay.representative.firstName + ' ' + widget.stateOfPlay.representative.lastName : null,
          labelText: "Sélectionner un mandataire",
          onPress: () {
            if (widget.stateOfPlay.representative.lastName != null)
              Navigator.push(context, PageRouteBuilder(pageBuilder: (_, __, ___) => NewInterlocutorContent(
                title: 'Éditer un mandataire',
                interlocutor: widget.stateOfPlay.representative,
                onSave : (representative) {
                  widget.stateOfPlay.representative = representative;
                  Navigator.pop(context);
                  setState(() { });
                }
              )));
            else
              Navigator.push(context, PageRouteBuilder(pageBuilder: (_, __, ___) => NewStateOfPlayInterlocutorsSearchRepresentatives(
                onSelect : (representative) {
                  widget.stateOfPlay.representative = representative;
                  setState(() { });
                }
              )));
          },
          onPressAdd: () {
            Navigator.push(context, PageRouteBuilder(pageBuilder: (_, __, ___) => NewInterlocutorContent(
              title: 'Nouveau mandataire',
              interlocutor: sop.Representative(),
              onSave : (representative) {
                widget.stateOfPlay.representative = representative;
                Navigator.pop(context);
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
        HeaderInterlocutor(
          text: "Locataires"
        ),
        ListTileInterlocutor(
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
            Navigator.push(context, PageRouteBuilder(pageBuilder: (_, __, ___) => NewInterlocutorContent(
              title: 'Nouveau locataire',
              interlocutor: sop.Tenant(),
              onSave : (tenant) {
                widget.stateOfPlay.tenants.add(tenant);
                Navigator.pop(context);
                setState(() { });
              }
            )));
          }, 
        ),
        Column(
          children: widget.stateOfPlay.tenants.asMap().map((i, tenant) => MapEntry(
            i,
            ListTileInterlocutor(
              text: tenant.firstName + ' ' + tenant.lastName,
              onPress: () {
                Navigator.push(context, PageRouteBuilder(pageBuilder: (_, __, ___) => NewInterlocutorContent(
                  title: 'Éditer un locataire',
                  interlocutor: tenant,
                  onSave : (tenant) {
                    widget.stateOfPlay.tenants[i] = tenant;
                    Navigator.pop(context);
                    setState(() { });
                  }
                )));
              },
              onPressRemove: () {
                widget.stateOfPlay.tenants.remove(tenant);
                setState(() { });
              },
            ),
          )).values.toList()
        ),

        Divider(),
        HeaderInterlocutor(
          text: "Propriété"
        ),
        ListTileInterlocutor(
          text: widget.stateOfPlay.property.address != null ? widget.stateOfPlay.property.address + ', ' + widget.stateOfPlay.property.postalCode + ' ' + widget.stateOfPlay.property.city : null,
          labelText: "Sélectionner une propriété",
          onPress: () {
            if (widget.stateOfPlay.property.address != null)
              Navigator.push(context, PageRouteBuilder(pageBuilder: (_, __, ___) => NewPropertyContent(
                title: 'Éditer une propriété',
                property: widget.stateOfPlay.property,
                onSave : (property) {
                  widget.stateOfPlay.property = property;
                  Navigator.pop(context);
                  setState(() { });
                }
              )));
            else
              Navigator.push(context, PageRouteBuilder(pageBuilder: (_, __, ___) => NewStateOfPlayInterlocutorsSearchProperties(
                onSelect : (property) {
                  widget.stateOfPlay.property = property;
                  setState(() { });
                }
              )));
          },
          onPressAdd: () {
            Navigator.push(context, PageRouteBuilder(pageBuilder: (_, __, ___) => NewPropertyContent(
              title: 'Nouvelle propriété',
              property: sop.Property(
                reference: "000",
                address: "42 rue du Test",
                postalCode: "75001",
                city: "Paris",
                lot: "000",
                floor: 4,
                roomCount: 4,
                area: 60,
                heatingType: "test",
                hotWater: "test"
              ),
              onSave : (property) {
                widget.stateOfPlay.property = property;
                Navigator.pop(context);
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