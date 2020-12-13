import 'package:flutter/material.dart';

import 'package:flutter_tests/models/StateOfPlay.dart' as sop;

import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/newStateOfPlayDetails/NewStateOfPlayDetails.dart';
import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/NewStateOfPlayMisc.dart';
import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/newStateOfPlayInterlocutors/NewStateOfPlayInterlocutors.dart';
// import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/NewStateOfPlayProperty.dart';
import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/NewStateOfPlaySignature.dart';

typedef SaveCallback = void Function();

class NewStateOfPlayContent extends StatefulWidget {
  NewStateOfPlayContent({ Key key, this.stateOfPlay, this.onSave, this.title }) : super(key: key);
  
  final String title;
  final sop.StateOfPlay stateOfPlay;
  final SaveCallback onSave;

  @override
  _NewStateOfPlayContentState createState() => new _NewStateOfPlayContentState();
}

class _NewStateOfPlayContentState extends State<NewStateOfPlayContent> {
  
  int _selectedIndex = 0;

  void onNext() {
    print('property: ' + widget.stateOfPlay.property.address);
    setState(() {
      _selectedIndex = _selectedIndex + 1;
    });
  }

  @override
  Widget build(BuildContext context) {

    final List<Widget> _tabsContent = [
      NewStateOfPlayInterlocutors(
        stateOfPlay: widget.stateOfPlay,
      ),
      // NewStateOfPlayProperty(
      //   property: widget.stateOfPlay.property,
      //   onNext: onNext,
      // ),
      NewStateOfPlayDetails(
        rooms: widget.stateOfPlay.rooms,
      ),
      NewStateOfPlayMisc(),
      NewStateOfPlaySignature(
        onSave: widget.onSave
      )
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          _selectedIndex == _tabsContent.length - 1 ? IconButton(
            icon: Icon(Icons.check),
            onPressed: () => widget.onSave(),
          ) : Container()
        ]
      ),
      body: _tabsContent[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Interlocuteurs & Propriété',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.house),
          //   label: 'Propriété',
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.apps),
            label: 'Détail des pièces',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz),
            label: 'Divers',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit),
            label: 'Signature',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        backgroundColor: Colors.grey,
        onTap: (index) {
          setState(() { _selectedIndex = index; });
        },
      )
    );
  }
}