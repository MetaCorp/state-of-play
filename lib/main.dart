import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:graphql_flutter/graphql_flutter.dart';


import 'package:flutter_tests/widgets/stateOfPlay/StateOfPlay.dart';
import 'package:flutter_tests/widgets/stateOfPlay/StateOfPlays.dart';
import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/NewStateOfPlay.dart';

import 'package:flutter_tests/widgets/property/Property.dart';
import 'package:flutter_tests/widgets/property/Properties.dart';

class StateOfPlayArguments {
  final String stateOfPlayId;

  StateOfPlayArguments(this.stateOfPlayId);
}

class PropertyArguments {
  final String propertyId;

  PropertyArguments(this.propertyId);
}

String get host {
  if (Platform.isAndroid) {
    return 'localhost';
  } else {
    return 'localhost';
  }
}

void main() {
  runApp(MyApp());
}

final HttpLink httpLink = HttpLink(
  uri: 'http://$host:4000/graphql',
);


// final AuthLink authLink = AuthLink(
//   getToken: () async => 'Bearer <YOUR_PERSONAL_ACCESS_TOKEN>',
//   // OR
//   // getToken: () => 'Bearer <YOUR_PERSONAL_ACCESS_TOKEN>',
// );

// final Link link = authLink.concat(httpLink);

ValueNotifier<GraphQLClient> client = ValueNotifier(
  GraphQLClient(
    cache: InMemoryCache(),
    link: httpLink,
  ),
);

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    //Force Device Orientation 
    //https://stackoverflow.com/questions/49418332/flutter-how-to-prevent-device-orientation-changes-and-force-portrait
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    return
      GraphQLProvider(
        client: client,
        child:
          MaterialApp(
            title: 'États des lieux',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            initialRoute: '/state-of-plays',
            // routes: {
            //   '/state-of-plays': (context) => StateOfPlays(),
            //   '/state-of-play': (context) => StateOfPlay(),
            //   '/properties': (context) => Properties(),
            //   '/property': (context) => Property(),
            // //  '/new': (context) => NewStateOfPlayRouter(),
            // },
            onGenerateRoute: (settings) {
              if (settings.name == "/state-of-plays") 
                return PageRouteBuilder(pageBuilder: (_, __, ___) => StateOfPlays());
              else if (settings.name == '/state-of-play') {
                print('args: ' + settings.arguments.toString());
                final StateOfPlayArguments args = settings.arguments;
                return PageRouteBuilder(pageBuilder: (_, __, ___) => StateOfPlay(stateOfPlayId: args.stateOfPlayId));
              }
              else if (settings.name == '/new-state-of-play')
                return PageRouteBuilder(pageBuilder: (_, __, ___) => NewStateOfPlay());
              else if (settings.name == '/properties')
                return PageRouteBuilder(pageBuilder: (_, __, ___) => Properties());
              else if (settings.name == '/property')
                return PageRouteBuilder(pageBuilder: (_, __, ___) => Property());

              return null;
            },
          )
      );
  }
}
