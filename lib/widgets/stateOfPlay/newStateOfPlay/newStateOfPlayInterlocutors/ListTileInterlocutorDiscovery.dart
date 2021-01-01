

import 'package:flutter/material.dart';
import 'package:feature_discovery/feature_discovery.dart';

typedef PressCallback = void Function();
typedef PressAddCallback = void Function();
typedef PressRemoveCallback = void Function();

class ListTileInterlocutorDiscovery extends StatelessWidget {
  const ListTileInterlocutorDiscovery({ Key key, this.text, this.labelText, this.onPress, this.onPressAdd, this.onPressRemove }) : super(key: key);

  final String text;
  final String labelText;
  final PressCallback onPress;
  final PressAddCallback onPressAdd;
  final PressRemoveCallback onPressRemove;

  @override
  Widget build(BuildContext context) {
    return DescribedFeatureOverlay(
      featureId: 'select_interlocutor',
      tapTarget: Icon(Icons.touch_app),
      title: Text('Ou sélectionner un propriétaire déjà éxistant'),
      description: Text("Pour sélectionner un propriétaire déjà éxistant, cliquez sur 'Sélectionner un propriétaire'."),
      // onComplete: () async {
      //   onPress();
      //   return true;
      // },
      child: ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                text != null ? text : labelText,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // Spacer(),
            DescribedFeatureOverlay(
              featureId: 'add_interlocutor',
              tapTarget: Icon(Icons.add),
              title: Text('Commencez par ajouter un nouveau propriétaire'),
              description: Text('Pour ajouter un nouveau propriétaire, cliquez sur le +.'),
              // onComplete: () async {
              //   onPressAdd();
              //   return true;
              // },
              child: IconButton(
                icon: text != null ? Icon(Icons.close) : Icon(Icons.add),
                onPressed: text != null ? onPressRemove : onPressAdd,
              ),
            )
          ]
        ),
        onTap: onPress,
        tileColor: text != null ? null : Colors.grey[200],
      ),
    );
  }
}