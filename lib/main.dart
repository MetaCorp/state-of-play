import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_tests/models/StateOfPlay.dart' as sop;

import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_tests/widgets/login_register/Login.dart';
import 'package:flutter_tests/widgets/login_register/Register.dart';

import 'package:flutter_tests/widgets/stateOfPlay/StateOfPlay.dart';
import 'package:flutter_tests/widgets/stateOfPlay/StateOfPlays.dart';
import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/NewStateOfPlay.dart';
import 'package:flutter_tests/widgets/stateOfPlay/EditStateOfPlay.dart';
import 'package:flutter_tests/widgets/stateOfPlay/SearchStateOfPlays.dart';

import 'package:flutter_tests/widgets/property/Property.dart';
import 'package:flutter_tests/widgets/property/Properties.dart';
import 'package:flutter_tests/widgets/property/NewProperty.dart';
import 'package:flutter_tests/widgets/property/EditProperty.dart';
import 'package:flutter_tests/widgets/property/SearchProperties.dart';

import 'package:flutter_tests/widgets/owner/Owner.dart';
import 'package:flutter_tests/widgets/owner/Owners.dart';
import 'package:flutter_tests/widgets/owner/NewOwner.dart';
import 'package:flutter_tests/widgets/owner/EditOwner.dart';
import 'package:flutter_tests/widgets/owner/SearchOwners.dart';

import 'package:flutter_tests/widgets/representative/Representative.dart';
import 'package:flutter_tests/widgets/representative/Representatives.dart';
import 'package:flutter_tests/widgets/representative/NewRepresentative.dart';
import 'package:flutter_tests/widgets/representative/EditRepresentative.dart';
import 'package:flutter_tests/widgets/representative/SearchRepresentatives.dart';

import 'package:flutter_tests/widgets/tenant/Tenant.dart';
import 'package:flutter_tests/widgets/tenant/Tenants.dart';
import 'package:flutter_tests/widgets/tenant/NewTenant.dart';
import 'package:flutter_tests/widgets/tenant/EditTenant.dart';
import 'package:flutter_tests/widgets/tenant/SearchTenants.dart';

import 'package:flutter_tests/widgets/settings/Settings.dart';


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

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  ValueNotifier<GraphQLClient> client;

  deleteToken() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("token", null);
  }

  @override
  void initState() {
    
    deleteToken();
    
    final HttpLink httpLink = HttpLink(
      // uri: 'https://dry-fjord-30387.herokuapp.com/graphql'
      uri: 'http://$host:4000/graphql',
    );
  
    final AuthLink authLink = AuthLink(
      getToken: () async {
        final prefs = await SharedPreferences.getInstance();
        return prefs.getString("token") != null ? "Bearer " + prefs.getString("token") : "";
      },
    );

    final Link link = authLink.concat(httpLink);

    client = ValueNotifier(
      GraphQLClient(
        cache: InMemoryCache(),
        link: link,
      ),
    );
    super.initState();
  }

  //todo move 
  Map<int, Color> color = 
  { 
    50:Color.fromRGBO(39, 125, 161, .1), 
    100:Color.fromRGBO(39, 125, 161, .2), 
    200:Color.fromRGBO(39, 125, 161, .3), 
    300:Color.fromRGBO(39, 125, 161, .4), 
    400:Color.fromRGBO(39, 125, 161, .5), 
    500:Color.fromRGBO(39, 125, 161, .6), 
    600:Color.fromRGBO(39, 125, 161, .7), 
    700:Color.fromRGBO(39, 125, 161, .8), 
    800:Color.fromRGBO(39, 125, 161, .9), 
    900:Color.fromRGBO(39, 125, 161, 1),
  }; 

  @override
  Widget build(BuildContext context) {
    //Force Device Orientation 
    //https://stackoverflow.com/questions/49418332/flutter-how-to-prevent-device-orientation-changes-and-force-portrait
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.landscapeLeft,
    //   DeviceOrientation.landscapeRight,
    // ]);

    MaterialColor colorCustom = MaterialColor(0xFF4AAAD3, color); 

    return GraphQLProvider(
      client: client,
      child: MaterialApp(
        title: 'États des lieux',
        theme: ThemeData(
          primarySwatch: colorCustom, 
          visualDensity: VisualDensity.adaptivePlatformDensity,
          buttonColor: Colors.grey, 
        ),
        initialRoute: '/login',
        onGenerateRoute: (settings) {
          
          if (settings.name == "/login") 
            return PageRouteBuilder(pageBuilder: (_, __, ___) => Login());
          else if (settings.name == "/register") 
            return PageRouteBuilder(pageBuilder: (_, __, ___) => Register());


          else if (settings.name == "/state-of-plays") 
            return PageRouteBuilder(pageBuilder: (_, __, ___) => StateOfPlays());
          else if (settings.name == '/state-of-play') {
            final Map args = settings.arguments;
            return PageRouteBuilder(pageBuilder: (_, __, ___) => StateOfPlay(stateOfPlayId: args["stateOfPlayId"]));
          }
          else if (settings.name == '/new-state-of-play') {
            final Map args = settings.arguments;
            return PageRouteBuilder(pageBuilder: (_, __, ___) => NewStateOfPlay(stateOfPlayId: args != null ? args["stateOfPlayId"] : null));
          }
          else if (settings.name == '/edit-state-of-play') {
            final Map args = settings.arguments;
            return PageRouteBuilder(pageBuilder: (_, __, ___) => EditStateOfPlay(stateOfPlayId: args["stateOfPlayId"]));
          }
          else if (settings.name == '/search-state-of-plays') {
            return PageRouteBuilder(pageBuilder: (_, __, ___) => SearchStateOfPlays());
          }


          else if (settings.name == '/properties')
            return PageRouteBuilder(pageBuilder: (_, __, ___) => Properties());
          else if (settings.name == '/property') {
            final Map args = settings.arguments;
            return PageRouteBuilder(pageBuilder: (_, __, ___) => Property(propertyId: args["propertyId"]));
          }
          else if (settings.name == '/new-property')
            return PageRouteBuilder(pageBuilder: (_, __, ___) => NewProperty());
          else if (settings.name == '/edit-property') {
            final Map args = settings.arguments;
            return PageRouteBuilder(pageBuilder: (_, __, ___) => EditProperty(propertyId: args["propertyId"]));
          }
          else if (settings.name == '/search-properties')
            return PageRouteBuilder(pageBuilder: (_, __, ___) => SearchProperties());
            

          else if (settings.name == '/owners')
            return PageRouteBuilder(pageBuilder: (_, __, ___) => Owners());
          else if (settings.name == '/owner') {
            final Map args = settings.arguments;
            return PageRouteBuilder(pageBuilder: (_, __, ___) => Owner(ownerId: args["ownerId"],));
          }
          else if (settings.name == '/new-owner')
            return PageRouteBuilder(pageBuilder: (_, __, ___) => NewOwner());
          else if (settings.name == '/edit-owner') {
            final Map args = settings.arguments;
            return PageRouteBuilder(pageBuilder: (_, __, ___) => EditOwner(ownerId: args["ownerId"]));
          }
          else if (settings.name == '/search-owners')
            return PageRouteBuilder(pageBuilder: (_, __, ___) => SearchOwners());
            

          else if (settings.name == '/representatives')
            return PageRouteBuilder(pageBuilder: (_, __, ___) => Representatives());
          else if (settings.name == '/representative') {
            final Map args = settings.arguments;
            return PageRouteBuilder(pageBuilder: (_, __, ___) => Representative(representativeId: args["representativeId"]));
          }
          else if (settings.name == '/new-representative')
            return PageRouteBuilder(pageBuilder: (_, __, ___) => NewRepresentative());
          else if (settings.name == '/edit-representative') {
            final Map args = settings.arguments;
            return PageRouteBuilder(pageBuilder: (_, __, ___) => EditRepresentative(representativeId: args["representativeId"]));
          }
          else if (settings.name == '/search-representatives')
            return PageRouteBuilder(pageBuilder: (_, __, ___) => SearchRepresentatives());
            

          else if (settings.name == '/tenants')
            return PageRouteBuilder(pageBuilder: (_, __, ___) => Tenants());
          else if (settings.name == '/tenant') {
            final Map args = settings.arguments;
            return PageRouteBuilder(pageBuilder: (_, __, ___) => Tenant(tenantId: args["tenantId"]));
          }
          else if (settings.name == '/new-tenant')
            return PageRouteBuilder(pageBuilder: (_, __, ___) => NewTenant());
          else if (settings.name == '/edit-tenant') {
            final Map args = settings.arguments;
            return PageRouteBuilder(pageBuilder: (_, __, ___) => EditTenant(tenantId: args["tenantId"]));
          }
          else if (settings.name == '/search-tenants')
            return PageRouteBuilder(pageBuilder: (_, __, ___) => SearchTenants());


          else if (settings.name == '/settings')
            return PageRouteBuilder(pageBuilder: (_, __, ___) => Settings());

          return null;
        }
      )
    );
  }
}
