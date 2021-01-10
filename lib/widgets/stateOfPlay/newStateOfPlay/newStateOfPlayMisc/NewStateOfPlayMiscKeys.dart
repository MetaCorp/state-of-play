import 'package:flutter/material.dart';
import 'package:flutter_tests/models/StateOfPlay.dart' as sop;
import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/Header.dart';
import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/newStateOfPlayMisc/NewStateOfPlayMiscAddKey/NewStateOfPlayMiscAddKey.dart';
import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/newStateOfPlayMisc/NewStateOfPlayMiscKey.dart';
import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/newStateOfPlayMisc/NewStateOfPlayMiscKey.dart';
import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/newStateOfPlayMisc/NewStateOfPlayMiscKey.dart';

class NewStateOfPlayMiscKeys extends StatefulWidget {
  NewStateOfPlayMiscKeys({ Key key, this.keys }) : super(key: key);

  List<sop.Key> keys;

  @override
  _NewStateOfPlayMiscKeysState createState() => new _NewStateOfPlayMiscKeysState();
}

class _NewStateOfPlayMiscKeysState extends State<NewStateOfPlayMiscKeys> {

  final int maxKeys = 15;

  void _showDialogDeleteKey (context, sop.Key key) async {
    await showDialog(
      context: context,
      child: AlertDialog(
        content: Text("Supprimer '" + key.type + "' ?"),
        actions: [
          new FlatButton(
            child: Text('ANNULER'),
            onPressed: () {
              Navigator.pop(context);
            }
          ),
          new FlatButton(
            child: Text('SUPPRIMER'),
            onPressed: () async {
              widget.keys.remove(key);
              setState(() { });
              Navigator.pop(context);
            }
          )
        ],
      )
    );
  }

  void _showDialogLimitKeys(context) async {
    await showDialog(
      context: context,
      child: AlertDialog(
        content: Text("Nombre de clés maximal atteint (" + maxKeys.toString() + ")."),
        actions: [
          new FlatButton(
            child: Text('COMPRIS'),
            onPressed: () {
              Navigator.pop(context);
            }
          ),
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {

    debugPrint('keys: ' + widget.keys.toString());

    return Scaffold(
      appBar: AppBar(
        title: Text('Clés'),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: Column(
        children: [
          Header(
            title: "Liste des clés",
            onPressAdd: () {
              if (widget.keys.length < maxKeys)
                Navigator.push(context, PageRouteBuilder(pageBuilder: (_, __, ___) => NewStateOfPlayMiscAddKey(
                  onSelect: (keys) {
                    debugPrint('keys: ' + keys.toString());
                    if (widget.keys.length + keys.length > maxKeys)
                      _showDialogLimitKeys(context);

                    for (var i = 0; i < keys.length && widget.keys.length < maxKeys; i++) {
                      widget.keys.add(sop.Key(
                        type: keys[i],
                        comments: "",
                        quantity: 1,
                        images: [],
                        newImages: [],
                        imageIndexes: [],
                      ));
                    }
                    setState(() { });
                  },
                )));
              else
                _showDialogLimitKeys(context);
            }
          ),
          Flexible(
            child: ListView.separated(
              itemCount: widget.keys.length,
              itemBuilder: (_, i) => ListTile(
                title: Row(
                  children: [
                    Text(widget.keys[i].type),
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        _showDialogDeleteKey(context, widget.keys[i]);
                      },
                    )
                  ]
                ),
                // subtitle: Text(DateFormat('dd/MM/yyyy').format(stateOfPlays[i].date)),
                onTap: () => Navigator.push(context, PageRouteBuilder(pageBuilder: (_, __, ___) => NewStateOfPlayMiscKey(
                  sKey: widget.keys[i],
                )))
              ),
              separatorBuilder: (context, index) {
                return Divider();
              },
            ),
          ),
        ],
      ),
    );
  }
}