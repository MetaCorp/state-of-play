import 'package:flutter/material.dart';

import 'package:flutter_tests/models/StateOfPlay.dart' as sop;

import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/NewStateOfPlayDetails.dart';
import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/NewStateOfPlayMisc.dart';
import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/NewStateOfPlayInterlocutors.dart';
import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/NewStateOfPlayProperty.dart';
import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/NewStateOfPlaySignature.dart';

typedef SaveCallback = void Function();

class NewStateOfPlayContent extends StatefulWidget {
  NewStateOfPlayContent({ Key key, this.stateOfPlay, this.onSave }) : super(key: key);
  
  final sop.StateOfPlay stateOfPlay;
  final SaveCallback onSave;

  @override
  _NewStateOfPlayContentState createState() => new _NewStateOfPlayContentState();
}

class _NewStateOfPlayContentState extends State<NewStateOfPlayContent> {
  
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {

    final List<Widget> _tabsContent = [
      NewStateOfPlayInterlocutors(),
      NewStateOfPlayProperty(),
      NewStateOfPlayDetails(),
      NewStateOfPlayMisc(),
      NewStateOfPlaySignature(
        onSave: widget.onSave
      )
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Nouvel état des lieux'),
      ),
      body: _tabsContent[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Interlocuteurs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.house),
            label: 'Propriété',
          ),
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