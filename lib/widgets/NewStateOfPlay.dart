import 'package:flutter/material.dart';

import 'package:flutter_tests/widgets/newStateOfPlay/NewStateOfPlayInterlocutors.dart';
import 'package:flutter_tests/widgets/newStateOfPlay/NewStateOfPlayProperty.dart';

import 'package:flutter_tests/models/StateOfPlay.dart' as sop;

class NewStateOfPlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // SignUpPage builds its own Navigator which ends up being a nested
    // Navigator in our app.
    return Navigator(
      initialRoute: 'new/interlocutors',
      onGenerateRoute: (RouteSettings settings) {
        WidgetBuilder builder;
        switch (settings.name) {
          case 'new/interlocutors':
          // Assume CollectPersonalInfoPage collects personal info and then
          // navigates to 'signup/choose_credentials'.
            builder = (BuildContext _) => NewStateOfPlayInterlocutors();
            break;
          case 'new/property':
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