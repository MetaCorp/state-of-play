import 'package:flutter/material.dart';
import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/NewStateOfPlayDetails.dart';
import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/NewStateOfPlayMisc.dart';
import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/NewStateOfPlayInterlocutors.dart';
import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/NewStateOfPlayProperty.dart';
import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/NewStateOfPlaySignature.dart';

class NewStateOfPlay extends StatefulWidget {
  NewStateOfPlay({Key key}) : super(key: key);

  @override
  _NewStateOfPlayState createState() => new _NewStateOfPlayState();
}

class _NewStateOfPlayState extends State<NewStateOfPlay> {
  int _selectedIndex = 0;

  final List<Widget> _tabsContent = [
    NewStateOfPlayInterlocutors(),
    NewStateOfPlayProperty(),
    NewStateOfPlayDetails(),
    NewStateOfPlayMisc(),
    NewStateOfPlaySignature()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nouvel états des lieux'),
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