import 'package:flutter/material.dart';
import 'package:flutter_tests/models/StateOfPlay.dart' as sop;
import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/Header.dart';
import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/newStateOfPlayMisc/NewStateOfPlayMiscAddMeter.dart';
import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/newStateOfPlayMisc/NewStateOfPlayMiscMeter.dart';

class NewStateOfPlayMiscMeters extends StatefulWidget {
  NewStateOfPlayMiscMeters({ Key key, this.meters }) : super(key: key);

  List<sop.Meter> meters;

  @override
  _NewStateOfPlayMiscMetersState createState() => new _NewStateOfPlayMiscMetersState();
}

class _NewStateOfPlayMiscMetersState extends State<NewStateOfPlayMiscMeters> {

  void _showDialogDeleteMeter (context, sop.Meter meter) async {
    await showDialog(
      context: context,
      child: AlertDialog(
        content: Text("Supprimer '" + meter.type + "' ?"),
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
              widget.meters.remove(meter);
              setState(() { });
              Navigator.pop(context);
            }
          )
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {

    print('meters: ' + widget.meters.toString());

    return Scaffold(
      appBar: AppBar(
        title: Text('Compteurs'),
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
            title: "Liste des compteurs",
            onPressAdd: () => Navigator.push(context, PageRouteBuilder(pageBuilder: (_, __, ___) => NewStateOfPlayMiscAddMeter(
              onSelect: (meters) {
                print('meters: ' + meters.toString());
                for (var i = 0; i < meters.length; i++) {
                  widget.meters.add(sop.Meter(
                    type: meters[i],
                    index: 0,
                    location: "",// TODO : complete fields
                  ));
                }
                setState(() { });
              },
            ))),
          ),
          Flexible(
            child: ListView.separated(
              itemCount: widget.meters.length,
              itemBuilder: (_, i) => ListTile(
                title: Row(
                  children: [
                    Text(widget.meters[i].type),
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        _showDialogDeleteMeter(context, widget.meters[i]);
                      },
                    )
                  ]
                ),
                // subtitle: Text(DateFormat('dd/MM/yyyy').format(stateOfPlays[i].date)),
                onTap: () => Navigator.push(context, PageRouteBuilder(pageBuilder: (_, __, ___) => NewStateOfPlayMiscMeter(
                  meter: widget.meters[i],
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