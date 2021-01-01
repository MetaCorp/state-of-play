

import 'package:flutter/material.dart';
import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/newStateOfPlayInterlocutors/ListTileInterlocutor.dart';

import 'package:feature_discovery/feature_discovery.dart';

typedef PressAddCallBack = void Function();

class HeaderDiscovery extends StatelessWidget {
  const HeaderDiscovery({ Key key, this.title, this.onPressAdd }) : super(key: key);

  final String title;
  final PressAddCallback onPressAdd;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold
            ),
          ),
          Spacer(),
          DescribedFeatureOverlay(
            featureId: 'add_room',
            tapTarget: Icon(Icons.add),
            targetColor: Colors.grey[200],
            title: Text('Ajouter une pièce'),
            description: Text('Pour ajouter une pièce, cliquez sur le bouton +, puis choisissez parmis la liste de pièce pré-remplie'),
            onComplete: () async {
              onPressAdd();
              return true;
            },
            child: RaisedButton(
              child: Icon(Icons.add),
              onPressed: onPressAdd,
              color: Colors.grey[200],
            ),
          )
        ],
      ),
    );
  }
}