import 'package:flutter/material.dart';

import 'package:flutter_tests/widgets/newStateOfPlay/NewStateOfPlayInterlocutors.dart';
import 'package:flutter_tests/widgets/newStateOfPlay/NewStateOfPlayOwner.dart';
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
            Column(
              children: [
                RaisedButton(
                  onPressed: () => Navigator.pushNamed(context, '/new/owner'),
                  child: Text(
                    'Owner'
                  )
                ),
                RaisedButton(
                  onPressed: () => Navigator.pushNamed(context, '/new/property'),
                  child: Text(
                    'Property'
                  )
                ),
                RaisedButton(
                  onPressed: () => Navigator.pushNamed(context, '/new/estateAgent'),
                  child: Text(
                    'Estate Agent'
                  )
                ),
              ],
            ),
            Column(
              children: [
                //add co-tenant !! must be held as list !
                RaisedButton(
                  onPressed: () => Navigator.pushNamed(context, '/new/tenants'),
                  child: Text(
                    'Tenants'
                  )
                ),
              ],
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
          case '/new/estateAgent':
          // Assume ChooseCredentialsPage collects new credentials and then
          // invokes 'onSignupComplete()'.
            builder = (BuildContext _) => NewStateOfPlayProperty();
            break;
          case '/new/tenants':
          // Assume ChooseCredentialsPage collects new credentials and then
          // invokes 'onSignupComplete()'.
            builder = (BuildContext _) => NewStateOfPlayProperty();
            break;
          case '/new/owner':
          // Assume ChooseCredentialsPage collects new credentials and then
          // invokes 'onSignupComplete()'.
            builder = (BuildContext _) => NewStateOfPlayOwner();
            break;
          case '/new/property/knownProperties':
          // Assume ChooseCredentialsPage collects new credentials and then
          // invokes 'onSignupComplete()'.
            builder = (BuildContext _) => NewStateOfPlayProperty();
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

