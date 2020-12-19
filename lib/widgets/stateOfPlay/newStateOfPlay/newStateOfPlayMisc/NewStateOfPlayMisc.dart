import 'package:flutter/material.dart';
import 'package:flutter_tests/models/StateOfPlay.dart' as sop;
import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/newStateOfPlayMisc/NewStateOfPlayMiscComments.dart';
import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/newStateOfPlayMisc/NewStateOfPlayMiscMeters.dart';
import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/newStateOfPlayMisc/NewStateOfPlayMiscInsurance.dart';
import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/newStateOfPlayMisc/NewStateOfPlayMiscKeys.dart';

class NewStateOfPlayMisc extends StatefulWidget {
  NewStateOfPlayMisc({ Key key, this.stateOfPlay }) : super(key: key);

  sop.StateOfPlay stateOfPlay;

  @override
  _NewStateOfPlayMiscState createState() => new _NewStateOfPlayMiscState();
}

class _NewStateOfPlayMiscState extends State<NewStateOfPlayMisc> {

  @override
  Widget build(BuildContext context) {

    List<Map> listItems = [{
      "title": "Compteurs",
      "route": NewStateOfPlayMiscMeters(
        meters: widget.stateOfPlay.meters,
      ),
    }, {
      "title": "Commentaires / Réserves",
      "route": NewStateOfPlayMiscComments(
        stateOfPlay: widget.stateOfPlay,
      ),
    }, {
      "title": "Clés",
      "route": NewStateOfPlayMiscKeys(
        keys: widget.stateOfPlay.keys
      ),
    }, {
      "title": "Assurance",
      "route": NewStateOfPlayMiscInsurance(
        insurance: widget.stateOfPlay.insurance,
      ),
    }];

    return Column(
      children: [
        Flexible(
          child: ListView.separated(
            itemCount: listItems.length,
            itemBuilder: (_, i) => ListTile(
              title: Row(
                children: [
                  Text(listItems[i]["title"]),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.chevron_right),
                  )
                ]
              ),
              // subtitle: Text(DateFormat('dd/MM/yyyy').format(stateOfPlays[i].date)),
              onTap: () => Navigator.push(context, PageRouteBuilder(pageBuilder: (_, __, ___) => listItems[i]["route"]))
            ),
            separatorBuilder: (context, index) {
              return Divider();
            },
          ),
        ),
      ],
    );
  }
}