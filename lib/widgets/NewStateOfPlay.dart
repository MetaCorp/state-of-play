import 'package:flutter/material.dart';

import 'package:flutter_tests/widgets/newStateOfPlay/NewStateOfPlayInterlocutors.dart';
import 'package:flutter_tests/widgets/newStateOfPlay/NewStateOfPlayProperty.dart';

import 'package:flutter_tests/models/StateOfPlay.dart' as sop;


//https://api.flutter.dev/flutter/widgets/Navigator-class.html
class NewStateOfPlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // SignUpPage builds its own Navigator which ends up being a nested
    // Navigator in our app.
    return Scaffold(
      appBar: AppBar(
        title: Text("New STate Of Play"),
      ),
      body: Container(
        child: Row(
          children: [
            Container(
              child: Column(
                children: [
                  RaisedButton(
                    onPressed: () => Navigator.pushNamed(context, '/new/interlocutors'),
                    child: Text(
                      'Interlocutors'
                    )
                  ),
                  RaisedButton(
                    onPressed: () => Navigator.pushNamed(context, '/new/property'),
                    child: Text(
                      'Property'
                    )
                  ),
                ],
              )
            ), 
          ]
        )
      ),
    );
  }
}

class NewStateOfPlayRouter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // SignUpPage builds its own Navigator which ends up being a nested
    // Navigator in our app.
    return Navigator(
      initialRoute: 'new/StateOfPlay',
      onGenerateRoute: (RouteSettings settings) {
        WidgetBuilder builder;
        switch (settings.name) {
          case 'new/StateOfPlay':
          // Assume CollectPersonalInfoPage collects personal info and then
          // navigates to 'signup/choose_credentials'.
            builder = (BuildContext _) => NewStateOfPlay();
            break;
          case '/new/interlocutors':
          // Assume CollectPersonalInfoPage collects personal info and then
          // navigates to 'signup/choose_credentials'.
            builder = (BuildContext _) => NewStateOfPlayInterlocutors();
            break;
          case '/new/property':
          // Assume ChooseCredentialsPage collects new credentials and then
          // invokes 'onSignupComplete()'.
            builder = (BuildContext _) => NewStateOfPlayProperty();
            break;
          
          default:
            throw Exception('Invalid route: ${settings.name}');
        }
        return MaterialPageRoute(builder: builder, settings: settings);
      },
    );   
  }
}

